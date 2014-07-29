require 'lib/clip'
require 'lib/asset'
require 'fileutils'

class FilterByGroup
  def initialize
    @clip_id_list = Hash.new
    @asset_id_list = Hash.new
    @duplicate_files = Array.new
  end

  def init(input_dir, content_dir, output_dir)

    puts "Loading clip files."

    Dir.glob "#{input_dir}/**/**/*.xml" do |file_path|
      f = File.open file_path, 'r'
      document = Clip.new f
      f.close
      add_clip_id_key document.zedId, file_path
    end

    puts "Loading content asset files."

    Dir.glob "#{content_dir}/*.xml" do |file_path|
      f = File.open file_path, 'r'
      document = Asset.new f, file_path
      f.close
      if document.is_learning_clip == false
        add_asset_id_key document.zedId, document.type, file_path
      end
    end

    puts "Filtering files for duplicates."

    compile_duplicate_list

    puts "Summary"
    puts "========"
    puts "INFO: Duplicate documents found: #{@duplicate_files.size.to_s}"

    copy_files_to_output_directory output_dir
  end

  private

  def add_clip_id_key(id, file_path)
    if id.empty? == false
      @clip_id_list[id] = file_path
    end
  end

  def add_asset_id_key(id, type, file_path)
    if id.empty? == false
      asset_data = Hash.new
      asset_data['type'] = type
      asset_data['filepath'] = file_path
      @asset_id_list[id] = asset_data
    end
  end

  def compile_duplicate_list
    @clip_id_list.each do |id, path|
      if @asset_id_list.key? id
        asset_data = @asset_id_list[id]
        $stderr.puts "ZID: #{id} features in #{path} AND #{asset_data['type']} #{asset_data['filepath']}"
        @duplicate_files.push path
      end
    end
  end

  def copy_files_to_output_directory(output_directory)
    output_path = output_directory + "/filtered_by_group"
    FileUtils.mkdir_p output_path
    @duplicate_files.each do |path|
      groupNum = /group-(?<groupNum>\d{1,2})/.match(path)[:groupNum]
      group_path = output_path + "/group-#{groupNum}/content"
      FileUtils.mkdir_p group_path
      FileUtils.cp path, group_path
    end
  end
end
