require "httparty"

class Orchestra::Cli::Traefik < Orchestra::Base
  desc "fetch_dynamic_config_files", 
       "Fetch Traefik dynamic config files from provided URL authenticating with a HTTP bearer token"
  method_options url: :string, authorization: :string, config_dir: "/etc/traefik"

  def fetch_dynamic_config_files
    response = HTTParty.get options.url, headers: authorization_headers

    response.each do |path, content|
      full_path = File.join options.config_dir, path

      if File.write(full_path, content)
        puts "Wrote #{full_path}"
      else
        raise StandardError, "Error writing to #{full_path}"
      end
    end
  end

  private
    def authorization_headers
      { "Authorization" => options.authorization }
    end
end
