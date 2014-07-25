require 'trollop'
require 'filter'
require 'clarify'

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

filter = Filter.new
ids = filter.init opts[:input_dir]

clarify = Clarify.new
clarify.init ids, opts[:output_dir]


