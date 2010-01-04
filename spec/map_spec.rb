require File.join(File.dirname(__FILE__), 'spec_helper')
describe 'Map' do
  it 'can load the test map' do
    $map = TMX::Map.new $window, File.join($data_dir, 'test.tmx')
    $map.should.is_a? TMX::Map
  end
  
  it 'has the correct dimensions' do
    $map.width.should  == 16
    $map.height.should == 16
  end
  
  it 'has the correct tile dimensions' do
    $map.tile_width.should  == 16
    $map.tile_height.should == 16
  end
  
  it 'loads all tile sets' do
    $map.tile_sets.count.should == 1
    $map.tile_sets.each do |name, ts|
      TMX::TileSet.should === ts
    end
  end
  
  it 'loads all layers' do
    $map.layers.count.should == 3
    $map.layers.each do |name, layer|
      layer.should.is_a? TMX::Layer
    end
  end
  
  it 'loads all object groups' do
    $map.object_groups.count.should == 2
    $map.object_groups.each do |name, group|
      TMX::ObjectGroup.should === group
    end
  end
  
  it 'can fetch arbitrary tile images'
  it 'can draw itself'
  
end
