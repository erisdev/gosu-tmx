module TMX
  class Map
    attr_reader :window
    
    attr_reader :properties
    attr_reader :width,      :height
    attr_reader :tile_width, :tile_height
    
    attr_reader :tile_sets, :layers, :object_groups
    
    DEFAULT_OPTIONS = {
      :scale_units => true,
      :on_object   => nil,
    }
    
    def initialize window, file_name, options = {}
      options = DEFAULT_OPTIONS.merge options
      
      mapdef = File.open(file_name) do |io|
        doc = Nokogiri::XML(io) { |conf| conf.noent.noblanks }
        
        # TODO figure out why this always fails
        # errors = doc.validate
        
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
      
      @properties = mapdef.tmx_parse_properties
      
      @all_tiles = []
      
      @tile_sets     = Hash[]
      @layers        = Hash[]
      @object_groups = Hash[]
      
      # callback for custom object creation
      @on_object = options[:on_object]
      
      mapdef.xpath('tileset').each do |xml|
        tile_set = parse_tile_set_def xml
        name     = tile_set.properties[:name]
        @tile_sets[name] = tile_set
      end
      
      mapdef.xpath('layer').each do |xml|
        layer = parse_layer_def xml
        name  = layer.properties[:name]
        @layers[name] = layer
      end # layers
      
      mapdef.xpath('objectgroup').each do |xml|
        group = parse_object_group_def xml
        name  = group.properties[:name]
        @object_groups[name] = group
      end # object groups
      
      rebuild_tile_set!
    end # initialize
    
    def rebuild_tile_set!
      @tile_sets.each_value do |tile_set|
        @all_tiles[tile_set.range] = tile_set.tiles
      end
    end # rebuild_tile_set!
    
    protected
    
    def parse_tile_set_def xml
      properties = xml.tmx_parse_attributes
      image_path = File.absolute_path xml.xpath('image/@source').first.value, File.dirname(xml.document.url)
      TileSet.new self, image_path, properties
    end
    
    def parse_layer_def xml
      properties = xml.tmx_parse_properties.merge! xml.tmx_parse_attributes
      Layer.new self, xml.tmx_data, properties
    end
    
    def parse_object_group_def xml
      properties = xml.tmx_parse_properties.merge! xml.tmx_parse_attributes
      group = ObjectGroup.new self, properties
      
      xml.xpath('object').each do |child|
        parse_object_def child, group
      end
      
      group
    end # parse_object_group_def
    
    def parse_object_def xml, group
      properties = xml.tmx_parse_properties.merge! xml.tmx_parse_attributes
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
