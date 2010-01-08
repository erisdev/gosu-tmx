module TMX
  class Map::TileCache
    def initialize map
      @map = WeakRef.new map
      
      @tile_cache = []
      @map_cache  = []
      
      @layer_count = 0
      
      @width,      @height      = 0, 0
      @tile_width, @tile_height = 0, 0
    end # initialize
    
    def rebuild!
      rebuild_tile_set!
      rebuild_map!
    end
    
    def rebuild_tile_set!
      @tile_cache.clear
      @map.tile_sets.each_value do |tile_set|
        @tile_cache[tile_set.range] = tile_set.tiles
      end
    end
    
    def rebuild_map!
      @map_cache.clear
      
      @layer_count = @map.layers.count
      
      @width,      @height      = @map.width,      @map.height
      @tile_width, @tile_height = @map.tile_width, @map.tile_height
      
      @map.layers.each_value.with_index do |layer, layer_index|
        (0...@height).each do |y|
          (0...@width).each do |x|
            index   = _tile_index layer_index, x, y
            tile_id = layer[x, y]
            @map_cache[index] = @tile_cache[tile_id]
          end
        end
      end
    end # rebuild_map!
    
    def draw x_off, y_off, z_off, x_range, y_range
      x_range = [x_range.min, 0].max .. [x_range.max, @width  - 1].min
      y_range = [y_range.min, 0].max .. [y_range.max, @height - 1].min
      
      y_range.each do |y|
        tile_y_off = y_off + y * @tile_height
        
        x_range.each do |x|
          tile_x_off = x_off + x * @tile_width
          
          range = _tile_range x, y
          @map_cache[range].each.with_index do |image, z|
            next if image.nil?
            image.draw tile_x_off, tile_y_off, z_off + z
          end
          
        end
      end
    end # draw
    
    protected
    
    def _tile_index layer_index, x, y
      y * @width * @layer_count + x * @layer_count + layer_index
    end
    
    def _tile_range x, y
      first = _tile_index 0, x, y
      first...(first + @layer_count)
    end
    
  end
end