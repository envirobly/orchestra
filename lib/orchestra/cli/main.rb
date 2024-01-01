class Orchestra::Cli::Main < Orchestra::Base
  desc "version", "Show Orchestra version"
  def version
    puts Orchestra::VERSION
  end

  desc "docker-version", "Show Docker version"
  def docker_version
    puts `docker -v`
  end

  desc "services", "Manage services"
  subcommand "services", Orchestra::Cli::Services

  desc "images", "Docker images"
  subcommand "images", Orchestra::Cli::Images
end
