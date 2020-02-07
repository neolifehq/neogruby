module NeoGruby
  module CLI
    module Commands
      class Console < Dry::CLI::Command
        def call(*)
          require './config/boot'
          require 'pry'
          Pry.config.prompt_name = 'NeoGruby'
          Pry.start
          puts 'Goodbye 👋'

        rescue Interrupt => e
          puts 'Goodbye 👋'
        rescue SignalException => e
        rescue Exception => e
          puts e.message
          puts e.backtrace
        end
      end

      register 'console', Console, aliases: ['c']
    end
  end
end
