module TMX
  class ObjectGroup
    include Enumerable
    
    attr_reader :properties
    
    def initialize properties = {}
      @properties = properties
      @objects = Hash[]
    end
    
    def add obj
      @objects[obj.object_id] = obj
    end
    
    def remove obj
      @objects.delete obj.object_id
    end
    
    def each &block
      @objects.each_value &block
    end
  end
end
