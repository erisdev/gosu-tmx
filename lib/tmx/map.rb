module TMX
  class Map
    autoload :TileCache, 'tmx/map/tile_cache'
    autoload :XMLLoader, 'tmx/map/xml_loader'
    
    include XMLLoader
    
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
      @cache  = TileCache.new self
      
      @tile_width  = mapdef['tilewidth'].to_i
      @tile_height = mapdef['tileheight'].to_i
      
      @width  = mapdef['width'].to_i
      @height = mapdef['height'].to_i
      
      @scale_units = options[:scale_units] \
        ? 1.0 / [@tile_height, @tile_width].min \
        : false
      
      @properties = mapdef.tmx_parse_properties
      
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
      
      @cache.rebuild!
    end # initialize
    
    def create_tile_set name, file_name_or_images, properties
      raise NotImplementedError
    end
    
    def create_layer name, data, properties
      raise NotImplementedError
    end
    
    def create_object_group name, properties
      raise NotImplementedError
    end
    
    def draw x_off, y_off, z_off = 0, x_range = 0...@width, y_range = 0...@height
      @cache.draw x_off, y_off, z_off, x_range, y_range
    end
    
    protected
    
    def on_object name, group, properties
      if @on_object
        @on_object.call group, name, properties
      else
        properties
      end
    end # on_object
  end # Map
end
