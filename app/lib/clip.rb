require 'nokogiri'

class Clip
  # attr_reader :zid,

  def initialize(xml)
    @document = Nokogiri::XML xml
  end

  def zedId
    id_node = @document.xpath '//asset:id'
    /(?<zid>z[a-z0-9]{6})/.match(id_node.first.content)[:zid]
  end
end