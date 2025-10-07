COUNT_OF_BYTES = 1024 * 1024 # 1 MB

require "json"

def group_files(directory_path)
  groups = Hash.new {|h, k| h[k] = []}
  process_directory(directory_path, groups)
  groups
end

def process_directory(directory_path, groups)
  Dir.each_child(directory_path) do |entry|
    full_path = File.join(directory_path, entry)

    begin
      st = File.lstat(full_path)
    rescue Errno::ENOENT, Errno::EACCES
      next
    end

    if st.directory?
      process_directory(full_path, groups) unless st.symlink?
    elsif st.file?
      # if group with this key doesn't exist it will create new group with value []
      # else it will add new value to list
      groups[st.size] << full_path
    end
  end
end

def bytes_equal?(first, second)
  File.open(first, "rb") do |first_file|
    File.open(second, "rb") do |second_file|
      loop do
        first_bytes = first_file.read(COUNT_OF_BYTES)
        second_bytes = second_file.read(COUNT_OF_BYTES)

        return true if first_bytes.nil? && second_bytes.nil?
        return false if first_bytes != second_bytes
      end
    end
  end
end

def get_duplicates_buckets(paths)
  buckets = []
  paths.each do |path|
    placed = false
    buckets.each do |bucket|
      # check with first element of bucket only
      if bytes_equal?(bucket.first, path)
        bucket << path
        placed = true
        break
      end
    end
    # create new bucket if it's a unique file
    buckets << [path] unless placed
  end
  buckets.select { |b| b.size > 1 } # return only duplicates buckets
end

def duplicates_report(directory_path)
  groups = group_files(directory_path)

  result_groups = []
  groups.each do |size, file_names|
    buckets = get_duplicates_buckets(file_names)
    buckets.each do |bucket|
      result_groups << {
        size_bytes: size,
        saved_if_dedup_bytes: size * (bucket.size - 1),
        files: bucket
      }
    end
  end

  {
    scanned_files: groups.values.sum {  |v|  v.size },
    groups: result_groups
  }
end

def write_report(report)
  File.write("duplicates.json", JSON.pretty_generate(report))
end

def main
  print "Enter the full path name to directory: "
  input = gets.chomp
  if input.nil? || input.empty?
    print "Wrong path!\n"
    return
  end
  dir_name = input.chomp

  dir = File.expand_path(dir_name)
  unless Dir.exist?(dir)
    print "Directory not found: #{dir}"
    return
  end

  puts "Scanning: #{dir}"
  report = duplicates_report(dir)

  write_report(report)
  puts 'Report written to: duplicates.json'
end

main