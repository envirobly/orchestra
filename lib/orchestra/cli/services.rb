require "httparty"
require "open3"

class Orchestra::Cli::Services < Thor
  desc "up", "Start services from provided URL authenticating with a HTTP bearer token"
  method_options url: :string, authorization: :string
  def up
    fetch_service_definition_file

    output, status = Open3.capture2e *compose_up_cmd

    puts output

    if status.to_i > 0
      # TODO: Parse output for service uuids
    end
  end

  desc "down", "Stop services previously launched by up"
  def down
    output, status = Open3.capture2e *compose_down_cmd

    puts output

    FileUtils.rm service_definition_path
  end

  private
    def authorization_headers
      { "Authorization" => options.authorization }
    end

    def fetch_service_definition_file
      response = HTTParty.get options.url, headers: authorization_headers
      # content = JSON.pretty_generate(JSON.parse(response.body))

      if File.write(service_definition_path, response.body)
        puts "Service definition file saved to #{service_definition_path}"
      else
        raise StandardError, "Unable to save service definition file into #{service_definition_path}"
      end
    end

    def service_definition_path
      Orchestra::Cli::SERVICE_DEFINITION_PATH
    end

    # https://docs.docker.com/engine/reference/commandline/compose_up/
    def compose_up_cmd
      [
        "docker", "compose",
        "--progress=plain",
        "-f", service_definition_path,
        "up",
        "--detach",
        "--wait"
      ]
    end

    def compose_down_cmd
      [
        "docker", "compose",
        "--progress=plain",
        "-f", service_definition_path,
        "down"
      ]
    end
end
