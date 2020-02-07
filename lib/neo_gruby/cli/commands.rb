require "dry/cli"

module NeoGruby
  module CLI
    module Commands
      extend Dry::CLI::Registry
    end
  end
end

require_relative 'commands/db'
require_relative 'commands/protoc'
require_relative 'commands/server'
require_relative 'commands/console'
