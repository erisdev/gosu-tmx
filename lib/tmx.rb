autoload :Base64,   'base64'
autoload :Gosu,     'gosu'
autoload :Nokogiri, 'nokogiri'
autoload :WeakRef,  'weakref'
# autoload :Zlib,     'zlib'

# mysterious autoload failure
require 'zlib'

require 'tmx/nokogiri_additions'

module TMX
  autoload :Coder,       'tmx/coder'
  autoload :Layer,       'tmx/layer'
  autoload :Map,         'tmx/map'
  autoload :ObjectGroup, 'tmx/object_group'
  autoload :TileSet,     'tmx/tile_set'
end
