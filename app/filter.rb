require 'lib/clip'
require 'set'

class Filter
  def initialize
    @id_list = Hash.new
  end

  def init(input_dir)

    puts "Searching files."

    Dir.glob "#{input_dir}/*.xml" do |file_path|
      f = File.open file_path, 'r'
      document = Clip.new f
      f.close
      add_id_key document.zedId, file_path
    end

    @id_list

  end

  private

  def add_id_key(id, file_path)
    if @id_list.key? id
      @id_list[id].push file_path
    else
      @id_list[id] = Array.new
      @id_list[id].push file_path
    end
  end
end
