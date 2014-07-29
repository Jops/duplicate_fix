require 'nokogiri'

class Asset
  attr_reader :is_learning_clip, :file_type, :file_path

  def initialize(xml, file_path)
    namespaces = Hash.new
    namespaces['study-guide-list'] = 'https://production.bbc.co.uk/isite2/project/education/sg-study-guide-list'
    namespaces['study-guide'] = 'https://production.bbc.co.uk/isite2/project/education/sg-study-guide'
    namespaces['revision-chapter'] = 'https://production.bbc.co.uk/isite2/project/education/revision-chapter'
    namespaces['glossary-term'] = 'https://production.bbc.co.uk/isite2/project/education/sg-glossary-term'
    namespaces['audio-chapter'] = 'https://production.bbc.co.uk/isite2/project/education/sg-audio-chapter'
    namespaces['activity-chapter'] = 'https://production.bbc.co.uk/isite2/project/education/sg-activity-chapter'
    namespaces['video-chapter'] = 'https://production.bbc.co.uk/isite2/project/education/sg-video-chapter'
    namespaces['test-chapter'] = 'https://production.bbc.co.uk/isite2/project/education/sg-test-chapter'
    namespaces['learning-clip'] = 'https://production.bbc.co.uk/isite2/project/education/learning-clip'
    namespaces['topic'] = "https://production.bbc.co.uk/isite2/project/education/topic"
    namespaces['c-sg-dialogue'] = "https://production.bbc.co.uk/isite2/project/education/c-sg-dialogue"
    namespaces['generic-picker'] = "https://production.bbc.co.uk/isite2/project/education/generic-picker"
    namespaces['related-links'] = "https://production.bbc.co.uk/isite2/project/education/related-links"
    namespaces['programme-of-study'] = "https://production.bbc.co.uk/isite2/project/education/programme-of-study"
    namespaces['programme-of-study'] = "https://production.bbc.co.uk/isite2/project/education/programme-of-study"
    namespaces['homepage-promos'] = "https://production.bbc.co.uk/isite2/project/education/homepage-promos"
    namespaces['homepage-related-links'] = "https://production.bbc.co.uk/isite2/project/education/homepage-related-links"
    namespaces['nation'] = "https://production.bbc.co.uk/isite2/project/education/nation"
    namespaces['field-of-study'] = "https://production.bbc.co.uk/isite2/project/education/field-of-study"
    namespaces['topic-of-study'] = "https://production.bbc.co.uk/isite2/project/education/topic-of-study"
    namespaces['testfiletype'] = "https://production.bbc.co.uk/isite2/project/education/testfiletype"

    @is_learning_clip = false
    @file_type = ""
    @file_path = file_path

    @document = Nokogiri::XML xml
    namespaces.each do |type, ns|
      if @document.namespaces.has_value? ns
        @file_type = type
        if @file_type == 'learning-clip'
          @is_learning_clip = true
        end
      end
    end
    $stderr.puts "Namespace not found: #{@document.namespaces.to_s} for #{file_path}" if @file_type.empty?
    @document.remove_namespaces!
  end

  def type
    @file_type
  end

  def zedId
    id_node = @document.xpath '//id'
    if id_node.first.nil? or id_node.first.nil?
      puts "Asset document of type #{file_type} has no id: #{file_path}"
      return ""
    end
    id_content = id_node.first.content
    match = /(?<zid>z[a-z0-9]{6})/.match(id_content)
    if match.nil? == false
        match[:zid]
    else
        ""
    end
  end
end