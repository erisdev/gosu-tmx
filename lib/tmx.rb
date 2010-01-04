require 'gosu'
require 'nokogiri'

require 'tmx/nokogiri_additions'

module TMX
  autoload :Layer,       'tmx/layer'
  autoload :Map,         'tmx/map'
  autoload :ObjectGroup, 'tmx/object_group'
end
