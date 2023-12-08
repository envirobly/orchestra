require "thor"

class Orchestra::Base < Thor
  def self.exit_on_failure?
    true
  end
end
