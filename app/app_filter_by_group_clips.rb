require 'trollop'
require 'filter_by_group'

opts = Trollop::options do
  opt :input_dir, 'Directory with iSite clip dump', :type => :string, :required => true
  opt :content_dir, 'Directory with iSite2 downloaded content', :type => :string, :required => true
  opt :output_dir, 'Directory to copy filtered files into', :type => :string, :required => true
end

def check_if_directory_exists(directory)
    if not Dir.exists? directory
      $stderr.puts "ERROR: Directory '#{directory}' does not exist (or is not a directory)."
      exit 1
    end
end

check_if_directory_exists opts[:input_dir]
check_if_directory_exists opts[:content_dir]
check_if_directory_exists opts[:output_dir]

filter = FilterByGroup.new
ids = filter.init opts[:input_dir], opts[:content_dir], opts[:output_dir]