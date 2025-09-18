def launch_game
  number = rand(1..100)

  puts 'Number is set'
  attempts = 0

  loop do
    print 'Try to guess: '

    input = Integer(gets, exception:false)
    if input.nil?
      puts 'Invalid input'
      next
    end

    attempts += 1

    if input == number
      puts "Game is finished! You guessed!!! Attempts: #{attempts}"
      break
    elsif input > number
      puts 'Less'
    else
      puts 'More'
    end
  end
end

loop do
  print 'Enter "start" to start the game (press Enter to exit): '
  input = gets&.downcase&.chomp
  if input.nil? || input.empty?
    break
  elsif input == 'start'
    launch_game
  end
end