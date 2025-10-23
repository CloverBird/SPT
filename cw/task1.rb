class FileBatchEnumerator
  include Enumerable

  def initialize(file_path, batch_size)
    @file_path = file_path
    @batch_size = batch_size
  end

  def each
    File.open(@file_path, "r") do |file|
      batch = []

      file.each_line do |line|
        batch << line
        if batch.size == @batch_size
          yield batch
          batch = []
        end
      end
      # if count of lines doesn't divide on batch_size
      yield batch unless batch.empty?
    end

  end
end

enumerator = FileBatchEnumerator.new("data.txt", 3)

enumerator.each do |batch|
  puts "Start batch"
  puts batch
  puts "End batch"
end