module TMX
  class Map
    attr_reader :properties
    attr_reader :width,      :height
    attr_reader :tile_width, :tile_height
    
    DEFAULT_OPTIONS = {
      :scale_units => true,
      :on_object   => nil,
    }
    
    def initialize window, file_name, options = {}
      options = DEFAULT_OPTIONS.merge options
      
      # this needs to be saved for tileset loading
      @file_name = file_name
      
      mapdef = File.open(@file_name) do |io|
        doc = Nokogiri::XML(io) { |conf| conf.noent.noblanks }
        # TODO validate xml???
        doc.root
      end
      
      raise "Only version 1.0 maps are currently supported" unless mapdef['version']     == '1.0'
      raise "Only orthogonal maps are currently supported"  unless mapdef['orientation'] == 'orthogonal'
      
      @window = window
      
      @tile_width  = mapdef['tilewidth'].to_i
      @tile_height = mapdef['tileheight'].to_i
      
      @width  = mapdef['width'].to_i
      @height = mapdef['height'].to_i
      
      @scale_units = options[:scale_units] \
        ? 1.0 / [@tile_height, @tile_width].min \
        : false
      
      @properties = mapdef.parse_properties
      
      @tile_sets     = Hash[]
      @layers        = Hash[]
      @object_groups = Hash[]
      
      # callback for custom object creation
      @on_object = options[:on_object]
      
      mapdef.xpath('tileset').each do |xml|
        tile_set = create_tile_set xml
        name     = tile_set.properties[:name]
        @tile_sets[name] = tile_set
      end
      
      mapdef.xpath('layer').each do |xml|
        layer = create_layer xml
        name  = layer.properties[:name]
        @layers[name] = layer
      end # layers
      
      mapdef.xpath('objectgroup').each do |xml|
        group = create_object_group xml
        name  = group.properties[:name]
        @object_groups[name] = group
      end # object groups
      
    end # initialize
    
    def tile index
      if index.zero? then nil
      else @all_tiles[index - 1]
      end
    end
    
    protected
    
    def create_tile_set xml
      properties = xml.parse_attributes
      image_path = File.absolute_path xml.xpath('image/@source').first.value, File.dirname(@file_name)
      TileSet.new @window, image_path, properties
    end
    
    def create_layer xml
      properties = xml.parse_properties.merge! xml.parse_attributes
      Layer.new xml.data, properties
    end
    
    def create_object_group xml
      properties = xml.parse_properties.merge! xml.parse_attributes
      group = ObjectGroup.new properties
      
      xml.xpath('object').each do |child|
        create_object child, group
      end
      
      group
    end # create_object_group
    
    def create_object xml, group
      properties = xml.parse_properties.merge! xml.parse_attributes
      name       = properties.delete(:name)
      
      [:x, :y, :width, :height].each do |key|
        properties[key] = properties[key] * @scale_units
      end if @scale_units
      
      on_object name, group, properties
    end
    
    def on_object name, group, properties
      if @on_object
        @on_object.call group, name, properties
      else
        properties
      end
    end # on_object
    
  end # Map
end
