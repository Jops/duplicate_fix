require 'nokogiri'

class Clip
  # attr_reader :zid,

  def initialize(xml)
    @document = Nokogiri::XML xml
    @document.remove_namespaces!
  end

  def zedId
    id_node = @document.xpath '/learning-clip/details/id'
    id_content = id_node.first.content
    match = /(?<zid>z[a-z0-9]{6})/.match(id_content)
    if match.nil? == false
        match[:zid]
    else
        ""
    end
  end
end