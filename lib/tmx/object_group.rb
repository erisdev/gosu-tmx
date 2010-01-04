module TMX
  class ObjectGroup
    include Enumerable
    
    def initialize *objects
      @objects = objects.to_a.reduce({}) { |h, obj| h.merge! obj.object_id => obj }
    end
    
    def add obj
      @objects[obj.object_id] = obj
    end
    
    def remove obj
      @objects.delete obj.object_id
    end
    
    def each &block = nil
      @objects.each_value &block
    end
  end
end
