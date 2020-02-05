require "neo_gruby/version"

module NeoGruby
  class Error < StandardError; end

  class << self

    def boot
      pp caller_locations.first.path
    end

    def run!

    end
  end
end
