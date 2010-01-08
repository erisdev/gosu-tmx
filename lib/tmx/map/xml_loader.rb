module TMX
  module Map::XMLLoader
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
  
  end # Map::XMLLoader
end