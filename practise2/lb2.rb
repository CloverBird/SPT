def menu
  puts "=== Menu ==="
  while true
    puts "1. Sample 1"
    puts "2. Sample 2"
    puts "3. Sample 3"
    puts "4. Input by myself"
    puts "5. Exit"
    choice = gets.to_i
    case choice
    when 1
      puts "Sample 1"
      cake = [["o","o",".",".","o","."],
              [".",".",".",".","o","."],
              [".",".","o",".",".","o"]]
      cake.each do |part|
        puts part.join(' ')
      end
      pieces = cut_cake(cake, [], 6, [[3,1], [1,3]])
      print_cake(cake, pieces)
    when 2
      puts "Sample 2"
      cake = [["o","o",".",".","o","."],
              [".",".",".",".","o","."],
              [".",".",".",".",".","."],
              [".",".","o",".","o","."]]
      cake.each do |part|
        puts part.join(' ')
      end
      pieces = cut_cake(cake, [], 6, [[4,1], [2,2], [1,4]])
      print_cake(cake, pieces)
    when 3
      puts "Sample 3"
      cake = [["o","o",".",".","o",".","."],
              [".",".",".",".","o",".","o"],
              [".",".",".",".",".",".","."],
              [".",".","o",".","o",".","."]]
      cake.each do |part|
        puts part.join(' ')
      end
      pieces = cut_cake(cake, [], 7, [[4,1], [2,2], [1,4]])
      print_cake(cake, pieces)
    when 4
      puts "Your input:"
      cake = cake_input
      puts "Your cake:"
      cake.each do |part|
        puts part.join(' ')
      end
      n = raisin_count(cake)
      if (cake.size * cake[0].size) % n != 0
        puts "It is impossible to divide cake!"
      else
        m = piece_shapes((cake.size * cake[0].size) / n)
        pieces = cut_cake(cake, [], n, m)
        print_cake(cake, pieces)
      end
    when 5
      puts "Exit."
      break
    else
      puts "Wrong choice. Please choose again."
    end
  end
end

def cut_cake(cake, pieces, n, m)
  m.each do |piece_shapes|
    # potential pieces of cake
    # vertical coordinates, horizontal coordinates
    potential_pieces = []
    # potential possible horizontal pieces of cake
    # row, start, end, is there a raisin?
    potential_horizontals = []
    a = piece_shapes[0] # required count of cells along horizontal
    b = piece_shapes[1] # required count of cells along vertical

    cake.each_with_index do |row, row_index|
      raisin = 0 # count of raisins in horizontal piece
      raisin_index = -1 # raisin index in array
      a_c = 0 # counter of available unit cells along the horizontal (available array elements)


      row.each_with_index do |element, col_index|
        # check whether this cell belongs to an already cut-out piece and stop if true
        pieces.each do |piece|
          if (row_index >= piece[0]) && (row_index <= piece[1]) && (col_index >= piece[2]) && (col_index <= piece[3])
            a_c = -1
            break
          end
        end

        if a_c == -1
          a_c = 0
          raisin = 0
          next
        end

        if element == "o"
          raisin += 1
          raisin_index = col_index
        end
        if raisin > 1
          raisin = 1
          a_c = 1
          next
        end
        a_c += 1

        if (a_c == a) && ((raisin_index >= col_index - a + 1) && (raisin_index <= col_index))
          potential_horizontals.push([row_index, col_index - a + 1, col_index, 1]) # row, start, end, is there a raisin?
          a_c -= 1
        elsif a_c == a
          potential_horizontals.push([row_index, col_index - a + 1, col_index, 0] ) # row, start, end, is there a raisin?
          a_c -= 1
          raisin = 0
        end

      end

    end

    potential_horizontals.each_with_index do |x, x_index|
      raisin = 0 # count of raisins in potential piece
      vert_horizontals = 0 # shows how many horizontal parts coincide vertically

      potential_horizontals[x_index..-1].each do |y|
        if (vert_horizontals == b) || (y[0] > x[0] + vert_horizontals)
          break
        elsif (y[0] == x[0] + vert_horizontals) && (y[1] == x[1]) && (y[2] == x[2])
          vert_horizontals += 1
          if y[3] == 1
            raisin += 1
          end
        end
      end

      if (raisin == 1) && (vert_horizontals == b)
        potential_pieces.push([x[0], x[0] + b - 1, x[1], x[2]]) # coordinates by vertical,
        # coordinates by horizontal
      end
    end

    potential_pieces.each do |piece|
      pieces.push(piece)
      if n == 1
        return pieces
      end

      pieces = cut_cake(cake, pieces, n - 1, m)
      if pieces[-1] == [-1, -1, -1, -1]
        pieces.pop
        pieces.pop
      else
        return pieces
      end
    end

  end
  # push this piece if it is impossible to divide cake
  pieces.push([-1, -1, -1, -1])
  pieces
end

def cake_input
  x = 0
  while true
    puts "Enter vertical size of cake:"
    x = gets.to_i
    if x <= 0
      puts "Wrong data. Repeat please"
    else
      break
    end
  end

  y = 0
  while true
    puts "Enter horizontal size of cake:"
    y = gets.to_i
    if y <= 0
      puts "Wrong data. Repeat please"
    else
      break
    end
  end

  cake = []
  for a in 0..(x-1)

    puts "Horizontal pice #{a+1}:"
    h_piece_input = gets.chomp
    h_piece = h_piece_input.split("")
    if h_piece.size != y
      puts "Wrong size. Repeat please!"
      redo
    end

    flag = 0
    for b in 0..(y-1)
      if h_piece[b] != "o" && h_piece[b] != "."
        flag = -1
        break
      end
    end

    if flag == -1
      puts "Not allowed symbols. Repeat please"
      redo
    end

    cake[a] = h_piece
  end

  cake
end

def raisin_count(cake)
  cake.sum {|row| row.count("o")}
end

# by area count all possible shapes for one piece
def piece_shapes(num)
  m = []
  for a in num.downto(1)
    for b in 1..num
      if a * b == num
        m.push([a, b])
      end
    end
  end
  m
end

def print_cake(cake, pieces)
  if pieces[0] == [-1, -1, -1, -1]
    puts "It is impossible to divide the cake"
    return
  end

  # sorting cake
  sorted_pieces = get_sorted_pieces(cake, pieces)

  # printing cake
  puts "["
  sorted_pieces.each_with_index  do |part, part_index|
    for i in part[0]..part[1]
      print " "
      for j in part[2]..part[3]
        print cake[i][j]
      end
      if i == part[0]
        print " // piece #{part_index + 1}"
      end
      print "\n"
    end
    if part_index < sorted_pieces.size - 1
      puts ","
    end
  end
  puts "]"
end

# sorting cake for more readable look
def get_sorted_pieces(cake, pieces)
  sorted_pieces = []
  for i in 0..(cake[0].size-1)
    for j in 0..(cake.size)
      pieces.each do |part|
        if part[2] == i && part[0] == j
          sorted_pieces.push(part)
          pieces.delete(part)
        end
      end
    end
  end

  sorted_pieces
end

menu