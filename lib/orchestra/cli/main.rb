require "thor"

class Orchestra::Cli::Main < Thor
  desc "version", "Show Orchestra version"
  def version
    puts Orchestra::VERSION
  end

  desc "docker-version", "Show Docker version"
  def docker_version
    puts `docker -v`
  end

  # @deprecated
  desc "list", "List running containers in JSON format"
  def list
    puts `docker ps --format '{{json .}}'`
  end

  desc "services", "Manage services"
  subcommand "services", Orchestra::Cli::Services

  desc "traefik", "Manage traefik"
  subcommand "traefik", Orchestra::Cli::Traefik
end