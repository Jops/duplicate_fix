require 'fileutils'
require 'set'
require "net/http"
require "uri"

class Clarify
  def initialize
    @duplicate_files = Set.new
  end

  def init(ids, output_dir)
    @id_list = ids

    # uri = URI.parse("https://api.live.bbc.co.uk/electron/solr/default/select/?q=atomWorkspace:kandlcurriculum+AND+learning_clip_id_s:#{zedId}&version=2.2&start=0&rows=40&indent=on")

    # # Shortcut
    # response = Net::HTTP.get_response(uri)

    # # Will print response.body
    # Net::HTTP.get_print(uri)

    # # Full
    # http = Net::HTTP.new(uri.host, uri.port)
    # response = http.request(Net::HTTP::Get.new(uri.request_uri))

    puts "filtering files for duplicates"

    compile_duplicate_list

    puts "Summary"
    puts "========"
    puts "INFO: Duplicate documents found: #{@duplicate_files.size.to_s}"

    copy_files_to_output_directory output_dir
  end

  private

  def compile_duplicate_list
    @id_list.delete_if do |id, paths|
      paths.size == 1
    end

    @id_list.each do |id, paths|
      $stderr.puts "ZID: #{id} features in #{paths.size.to_s} files."
      paths.each do |path|
        @duplicate_files.add path
      end
    end
  end

  def copy_files_to_output_directory(output_directory)
    published_dir = output_directory+"/published"
    FileUtils.mkdir published_dir
    FileUtils.cp @duplicate_files.to_a, published_dir
    unpublished_dir = output_directory+"/unpublished"
    FileUtils.mkdir unpublished_dir
    # FileUtils.cp @duplicate_files.to_a, unpublished_dir
  end
end

