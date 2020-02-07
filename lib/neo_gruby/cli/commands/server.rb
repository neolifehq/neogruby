require "dry/cli"

module NeoGruby
  module CLI
    module Commands
      class Server < Dry::CLI::Command
        desc "Run GRPC server"

        def call(*)
          system '/usr/bin/env ruby config.ru'

        rescue Interrupt => e
        rescue SignalException => e
        rescue Exception => e
          puts e.backtrace
        end
      end

      register "server", Server, aliases: ['s']
    end
  end
end
