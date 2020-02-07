module NeoGruby
  module Registry
    class << self
      attr_accessor :bucket

      def add(name, &block)
        bucket[name.to_sym] ||= []
        bucket[name.to_sym] << block if block_given?
      end

      def trigger(name, *params)
        if bucket.has_key?(name.to_sym)
          bucket[name.to_sym].each {|b| b.call(*params)}
        end
      end
    end
  end
end

NeoGruby::Registry.bucket = {}
