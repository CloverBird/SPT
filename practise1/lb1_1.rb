def word_stats(text)
  # regex in ruby is in /.../
  # this is regex for all symbols except letters (both latin and cyrillic) and "'"
  array = text.split(/[^[:alpha:]']+/)

  unique = array.uniq { |word| word.downcase }
  longest = array.max_by { |word| word.length }

  # no need in 'return'
  {
    total: array.length,
    unique: unique.length,
    longest: longest
  }
end

# loop do is like 'while true'
loop do
  puts "Enter a line of text (press ENTER to exit):"
  input = gets
  if input.nil? || input.chomp.empty?
    puts "The program has finished"
    break
  end
    stats = word_stats(input.chomp)

    puts "Words count: #{stats[:total]}"
    puts "Longest word: #{stats[:longest]}, length: #{stats[:longest]&.length}"
    puts "Number of unique words: #{stats[:unique]}"
end