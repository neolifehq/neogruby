
module NeoGruby
  class Application

    attr_accessor :logger,
                  :proto_path,
                  :protos,
                  :services,
                  :server,
                  :load_paths

    def initialize
      @protos = []
      @services = []
      @load_paths = [
        NeoGruby.root.join('app', 'protobuf'),
        NeoGruby.root.join('app', 'models'),
        NeoGruby.root.join('app', 'services'),
      ]

      @proto_path = NeoGruby.root.join('protos')

      prepare_application
      running_initializers
    end

    def loadpaths
      NeoGruby::Registry.trigger(:before_loadpaths, @load_paths, self)
      @load_paths.each {|f| $: << f }
    end

    def run
      create_logger if logger.nil?
      prepare_grpc
      load_services
      start_services
    end

    def configure(&block)
      yield self if block_given?
    end

    protected

    def prepare_application
      require NeoGruby.root.join('config', 'application')

      environment_file = NeoGruby.root.join('config', 'environments', NeoGruby.env)
      require environment_file if File.exist? environment_file
    end

    def running_initializers
      NeoGruby::Registry.trigger(:before_initializers, @load_paths, self)
      Dir[NeoGruby.root.join('config', 'initializers', '*.rb')].each do |f|
        require f
      end
      NeoGruby::Registry.trigger(:after_initializers, @load_paths, self)

    end

    def prepare_grpc
      require 'grpc'

      load_grpc_resources

      @port = "0.0.0.0:#{ENV.fetch('PORT') { 50051 }}"
      @server = GRPC::RpcServer.new
      @server.add_http2_port(@port, :this_port_is_insecure)
    end

    def load_services
      Dir[NeoGruby.root.join('app', 'services', '*.rb')].each do |f|
        require f
      end
    end

    def start_services
      NeoGruby::Registry.trigger(:before_start, self)
      puts '[SERVER] Adding services'
      ObjectSpace.each_object(Class).select { |c| c.included_modules.include? GRPC::GenericService }.each do |s|
        unless s.to_s.end_with? "::Service"
          puts "[SERVER] - #{s}"
          server.handle(s.new)
        end
      end

      puts("[SERVER] running insecurely on #{@port}")
      # Runs the server with SIGHUP, SIGINT and SIGQUIT signal handlers to
      #   gracefully shutdown.
      # User could also choose to run server via call to run_till_terminated
      server.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])

      NeoGruby::Registry.trigger(:after_start, self)
    end

    def load_grpc_resources
      Dir[NeoGruby.root.join('app', 'protobuf', '*_pb.rb')].each do |f|
        require f
      end
    end

    private

    def create_logger
      NeoGruby::Registry.trigger(:before_create_logger, self)
      return unless @logger.nil?
      require 'logger'
      FileUtils.mkdir_p NeoGruby.root.join('log')
      output = NeoGruby.env.production? ? NeoGruby.root.join('log', "#{NeoGruby.env}.log") : '/dev/stdout'
      @logger = Logger.new output
      NeoGruby::Registry.trigger(:after_create_logger, self)
    end
  end
end
