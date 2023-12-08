require "httparty" # @deprecated
require "open3"
require "httpx"
require "pathname"

class Orchestra::Cli::Services < Orchestra::Base
  desc "up", "Start services from provided compose file and report containers afterwards"
  method_option :config_dir,    type: :string, required: true
  method_option :config_bucket, type: :string, required: true
  method_option :event_url,     type: :string, required: true
  method_option :authorization, type: :string, required: true
  def up
    output, status = Open3.capture2e *sync_config_files_cmd

    puts output

    if status.to_i > 0
      # AWS access denied error code is 256, which is not a valid unix error code
      exit 1
    end

    output, status = Open3.capture2e *compose_up_cmd

    puts output

    if status.to_i > 0
      exit status.to_i
    else
      post_services_up_event
    end
  end

  desc "down", "Stop services defined in supplied compose file"
  method_option :config_dir, type: :string, required: true
  def down
    output, status = Open3.capture2e *compose_down_cmd

    puts output

    exit status.to_i
  end

  private
    def list_containers
      http = HTTPX.with(transport: "unix", addresses: ["/var/run/docker.sock"])

      response = http.get("http://localhost/v1.43/containers/json")

      response.body
    end

    def post_services_up_event
      headers = authorization_headers.merge({ "Content-Type" => "application/json" })

      body = JSON.generate({
        event: "services_up",
        services: JSON.parse(list_containers)
      })

      HTTParty.post(options.event_url, body:, headers:)
    end

    def authorization_headers
      { "Authorization" => options.authorization }
    end

    # https://docs.docker.com/engine/reference/commandline/compose_up/
    def compose_up_cmd
      [
        "docker", "compose",
        "-f", compose_file_path,
        "up",
        "--remove-orphans",
        "--detach",
        "--wait"
      ]
    end

    def compose_down_cmd
      [
        "docker", "compose",
        "-f", compose_file_path,
        "down"
      ]
    end

    def compose_file_path
      Pathname.new(options.config_dir).join("compose.yml").to_s
    end

    def sync_config_files_cmd
      [
        "aws", "s3",
        "sync",
        "s3://#{options.config_bucket}",
        options.config_dir,
        "--delete"
      ]
    end
end
