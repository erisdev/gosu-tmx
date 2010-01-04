require 'base64'
require 'gosu'
require 'nokogiri'
require 'zlib'

require 'tmx/nokogiri_additions'

module TMX
  autoload :Coder,       'tmx/coder'
  autoload :Layer,       'tmx/layer'
  autoload :Map,         'tmx/map'
  autoload :ObjectGroup, 'tmx/object_group'
end
