require "dry/cli"

module NeoGruby
  module CLI
    module Commands
      class Protoc < Dry::CLI::Command
        desc "Compile proto3 files into ruby classes"

        def call(*)
          require './config/boot'

          prepare_folders

          puts "> Loading proto files from '#{NeoGruby.app.proto_path.join ', '}'"
          compiling_messages
          compiling_services
        end

        def prepare_folders
          @output_path = NeoGruby.root.join('app', 'protobuf')
          FileUtils.rm_rf @output_path
          FileUtils.mkdir_p @output_path
        end

        def compiling_messages
          puts "> Compiling proto into MESSAGES classes"

          NeoGruby.app.protos.flatten.each do |proto|
            puts "#{proto}.proto"

            system 'grpc_tools_ruby_protoc',
              NeoGruby.app.proto_path.map {|p| "-I#{p}" }.join(' '),
              "--ruby_out=#{@output_path}",
              "--grpc_out=#{@output_path}",
              "#{proto}.proto"
          end
        end

        def compiling_services
          puts "> Compiling proto into SERVICES classes"

          NeoGruby.app.services.flatten.each do |proto|
            puts "#{proto}.proto"

            system 'grpc_tools_ruby_protoc',
              NeoGruby.app.proto_path.map {|p| "-I#{p}" }.join(' '),
              "--ruby_out=#{@output_path}",
              "#{proto}.proto"
          end
        end
      end

      register "protoc", Protoc, aliases: ['compile']
    end
  end
end
