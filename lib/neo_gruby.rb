require "neo_gruby/version"
require "neo_gruby/ext/class"
require "dotenv"

module NeoGruby
  class Error < StandardError; end

  autoload :Registry, 'neo_gruby/registry'
  autoload :Application, 'neo_gruby/application'

  module CLI
    autoload :Commands, 'neo_gruby/cli/commands'
  end

  class << self

    attr_accessor :root, :app, :env, :db

    def boot
      if @root.nil?
        @root = File.expand_path('../../', File.expand_path(caller_locations.first.path))

        def @root.join(*args)
          File.join self, args.join(File::Separator)
        end
      end

      @env = (ENV['NEOGRUBY_ENV'] || ENV['APP_ENV'] || ENV.fetch('RACK_ENV') { 'development' }).to_s
      def @env.development?
        self == 'development'
      end

      def @env.production?
        self == 'production'
      end

      def @env.test?
        self == 'test'
      end

      Dotenv.load(root.join('.env'), root.join(".env.#{NeoGruby.env}"), root.join(".env.#{NeoGruby.env}.local"))

      @configs = []
      NeoGruby::Registry.trigger(:before_boot)
      @app = Application.new
      @configs.each {|c| app.configure {|app| c.call(app) } }
      app.loadpaths
      NeoGruby::Registry.trigger(:after_boot, @app)
    end

    def configure(&block)
      @configs << block if block_given?
    end

    def run!
      app.run
    end
  end
end
