require "dry/cli"

module NeoGruby
  module CLI
    module Commands
      module Db
        class Migrate < Dry::CLI::Command
          desc "Run database migration"

          argument :version, type: :string, desc: "Informe the migration name to destination"

          def call(version: nil, **)
            require './config/boot'
            require 'sequel'
            require 'yaml'

            Sequel.extension :migration

            config = YAML.load_file(NeoGruby.root.join('config', 'database.yml'))
            config[NeoGruby.env].keys.each do |name|
              dir = NeoGruby.root.join('db/migrations', name)
              puts dir if File.directory? dir
              Sequel::Migrator.run(NeoGruby::Db.conn[name.to_sym], dir, target: version) if File.directory? dir
            end
          end
        end
      end

      register "db" do |prefix|
        prefix.register "migrate", Db::Migrate
      end
    end
  end
end
