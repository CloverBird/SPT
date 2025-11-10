def curry3(callable, acc = [])
  raise ArgumentError, "Callable is required" unless callable.respond_to?(:call)
  raise ArgumentError, "curry3 requires arity 3 (given #{callable.arity})" unless callable.arity == 3

  ->(*args) do
    # call() without args return just callable
    return curry3(callable, []) if args.empty?

    # add argument to list
    total = acc + args
    raise ArgumentError, "Too many arguments (#{total.length})" if total.length > 3

    if total.length == 3
      callable.call(*total)
    else
      curry3(callable, total)
    end
  end
end

# demo
sum3 = ->(a, b, c) { a + b + c }
cur = curry3(sum3)

puts cur.call(1).call(2).call(3)        #=> 6
puts cur.call(1, 2).call(3)             #=> 6
puts cur.call(1).call(2, 3)             #=> 6
puts cur.call()                         #=> callable, which is waiting for 3 arguments
puts cur.call(1, 2, 3)                  #=> 6

f  = ->(a, b, c) { "#{a}-#{b}-#{c}" }
cF = curry3(f)
puts cF.call('A').call('B', 'C')        #=> "A-B-C"

begin cur.call(1, 2, 3, 4)            #=> ArgumentError
rescue ArgumentError => e
  puts "Argument Error caught: #{e}"
end