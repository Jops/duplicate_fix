require 'trollop'
require "net/http"
require "uri"

opts = Trollop::options do
  opt :input_dir, 'Directory with iSite clip dump', :type => :string, :required => true
  opt :output_dir, 'Directory to copy filtered files into', :type => :string, :required => true
end

def check_if_directory_exists(directory)
    if not Dir.exists? directory
      $stderr.puts "ERROR: Directory '#{directory}' does not exist (or is not a directory)."
      exit 1
    end
end

check_if_directory_exists opts[:input_dir]
check_if_directory_exists opts[:output_dir]

@hit_list = Hash.new

def forEachFile do
    Dir.glob "#{input_dir}/*.xml" do |file_path|
      f = File.open file_path, 'r'
      document = Clip.new f
      f.close
      checkIdOnISite2 document.zedId, file_path
    end
end

def checkIdOnISite2 do |id, file_path|
    uri = URI.parse("https://api.test.bbc.co.uk/isite2-content-reader/content/file?project=education&id="+id)

    responce = Nokogiri::XML Net::HTTP.get_response(uri).body
    responce.remove_namespaces!

    zid = zedId responce
    type = typeName responce

    storeFind zid, type, file_path if !type.nil? and !type.empty

    # Full
    # http = Net::HTTP.new(uri.host, uri.port)
    # response = http.request(Net::HTTP::Get.new(uri.request_uri))
    # Will print response.body
    # Net::HTTP.get_print(uri)
end

def zedId(doc)
    id_node = doc.xpath '//details/id'
    /(?<zid>z[a-z0-9]{6})/.match(id_node.first.content)[:zid]
end

def typeName(doc)
    type_node = doc.xpath '//metadata/type'
    type_node.first.content
end

def storeFind(id, type, file_path)
    isite2_dir = output_directory + "/isite2_filtered"
    FileUtils.mkdir isite2_dir

    published_dir = output_directory+"/published"
    FileUtils.mkdir published_dir
    FileUtils.cp @duplicate_files.to_a, published_dir
    unpublished_dir = output_directory+"/unpublished"
    FileUtils.mkdir unpublished_dir
    # FileUtils.cp @duplicate_files.to_a, unpublished_dir
end




# ZID: zwr4q6f features in 3 files.
# ZID: zdgcjxs features in 3 files.
# ZID: zrsy4wx features in 2 files.
# ZID: zh7qhyc features in 2 files.
# ZID: z3ph34j features in 2 files.
# ZID: z8brwmn features in 3 files.
# Summary
# ========
# INFO: Duplicate documents found: 15

# c9076948-7e66-3eca-8bc3-041339948343
# 5903c9ec-5af1-353b-ae6b-3f1385ab4347
# bbe873bd-eea4-35f2-9d10-3ab3af838155
# ff0ea070-26c7-3c65-b485-8fa024c08c04
# 99a10d48-482b-39eb-8d03-fd84a919a224
# f3dee30a-b787-374f-a6a2-8161490e4fa9
# b5bd66fc-fc13-3773-8413-e8412aede8f7
# c3d3b14f-5a1e-31d8-918f-8844630bfc57

# Not found on invalids list:
# 430bd47e-3f13-384a-a61b-04a3795c35c5
# 24797bfe-00e3-3e60-a8e9-4c7ea566f031
# 2dccedf0-6128-3cbf-977d-1a03c2694665
# 3023b57f-54e8-3894-8b2b-b40f939e1b88
# 81e3b96d-07b8-3d21-bf6f-0be2ebbc6fe1
# 93fd11cc-b36a-3fc0-8e46-a673e134e445
# 9b31cd0f-9ecc-38ae-bffa-4d20da5103fd