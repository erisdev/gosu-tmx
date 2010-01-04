require 'spec'

tmx_root = File.dirname(File.dirname(__FILE__))

$:.unshift File.join(tmx_root, 'lib')
$data_dir = File.join(tmx_root, 'data')

require 'tmx'

$window = Gosu::Window.new 400, 200, false
