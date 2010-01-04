class Nokogiri::XML::Node
  def to_sym; self.to_s.to_sym end
  
  def to_i; self.to_s.to_i end
  def to_f; self.to_s.to_f end
  def to_c; self.to_s.to_c end
  def to_r; self.to_s.to_r end
  
  def parse
    str = to_s
    case str
    when %r(^ [+-]?     \d+        / [+-]?  \d+   $)x then str.to_r
    when %r(^ [+-]? (?: \d+ \. \d+   [+-] ) \d+ i $)x then str.to_c
    when %r(^ [+-]?     \d+ \. \d+                $)x then str.to_f
    when %r(^ [+-]?     \d+                       $)x then str.to_i
    else str
    end
  end
end

class Nokogiri::XML::Element
  def parse_attributes
    attributes.reduce({}) do |h, pair|
      name  = pair[0].to_sym
      value = pair[1].parse
      h.merge name => value
    end
  end
  
  def parse_properties
    properties_element = xpath('./properties') or return {}
    properties_element.xpath('./property').reduce({}) do |h, property|
      name  = property.attribute('name').to_sym
      value = property.attribute('value').parse
      h.merge! name => value
    end
  end
end
