class Class
  class << self
    def descendants
      descendants = []
      ObjectSpace.each_object(singleton_class) do |k|
        next if k.singleton_class?
        descendants.unshift k unless k == self
      end
      descendants
    end

    def subclasses
      subclasses, chain = [], descendants
      chain.each do |k|
        subclasses << k unless chain.any? { |c| c > k }
      end
      subclasses
    end
  end
end
