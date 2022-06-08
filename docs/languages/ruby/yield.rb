# yield.rb

#
# To load this code into the Ruby interpreter:
#
#   $ irb -I . -r yield.rb --simple-prompt
#

#
# Yields 3 different values.
#
# >> yield_stuff {|x| puts x }
# start
# 3
# cow
# 2.09
# stop
# => nil
#
def yield_stuff
    puts "start"
    yield 3
    yield 'cow'
    yield 2.09
    puts "stop"
end

#
# Yields the first n Fibonacci numbers.
#
# >> fib(5) {|x| puts x}
# 1
# 1
# 2
# 3
# 5
# => 5
#
def fib(n)
    case n  # similar to a switch statement
    when 1
        yield 1
    when 2
        yield 1
        yield 1
    else # n > 2
        a, b = 1, 1
        n.times do |i|
            yield a
            a, b = b, a + b
        end
    end
end

#
# Iterates from 0 up to, and including, n-1:
#
# >> mytimes(5) {|n| puts n**2}
# 0
# 1
# 4
# 9
# 16
# => 0...5
#
def mytimes(n)
    for i in 0...n  # ... excludes n
        yield i
    end
end

#
# mytimes implemented as a method of Integer:
#
# >> 5.mytimes {|n| puts n**2}
# 0
# 1
# 4
# 9
# 16
# => 0...5
#
class Integer
    def mytimes
        for i in 0...self  # ... excludes self
            yield i
        end
    end
end


#
# Iterates through the digits of the number, as integers e.g.:
# 
# >> 4589.digits {|d| puts d}
# 4
# 5
# 8
# 9
# => "4589"
#
class Integer    
    def digits
        s = self.to_s
        s.each_char do |c|
            yield c.to_i
        end
    end
end

#
# String iterator that returns just the alphabetic characters that appear in a
# string. The regular expression /^[a-zA-Z]$/ matches just the alphabetic
# characters.
#
# For example:
#
# >> "96372f1..9b42511".just_letters {|c| puts c}
# f
# b
# => "96372f1..9b42511"
#
class String
    def just_letters
        self.each_char do |c|
            if c =~ /^[a-zA-Z]$/
                yield c
            end
        end
    end
end # String


class Integer 
    #
    # Returns true if the integer n is prime, and false otherwise.
    #
    # >> 32883.is_prime?
    # => false
    # >> 32887.is_prime?
    # => true
    #
    def is_prime?
        return false if self < 2    # self refers to the value of the object
        return true if self == 2
        return false if even?       # even? is a method in Integer

        # self > 2, and odd
        candidate = 3
        while candidate * candidate <= self
            # return false if self % candidate == 0
            return false if remainder(candidate) == 0
            candidate += 2
        end
        return true
    end

    #
    # Iterates through all the primes less than this integer.
    #
    # >> 10.primes_less_than {|p| puts p}
    # 2
    # 3
    # 5
    # 7
    # => 2...10
    #
    def primes_less_than
        for i in (2...self)  # ... excludes self
            yield i if i.is_prime?
        end
    end

    #
    # Iterates through all the composites less than this integer.
    #
    # >> 10.composites_less_than {|p| puts p}
    # 1
    # 4
    # 6
    # 8
    # 9
    # => 1...10
    #
    def composites_less_than
         for i in (1...self)  # 1 is first composite; ... excludes self
            yield i if not i.is_prime?
        end       
    end
end # Integer


class Integer
    def bit_arrays
        # non-recursive base cases
        return [] if self < 0
        return ['0','1'] if self == 1

        # recursive case
        n1bits = nbits(n-1)

        # map returns a new array
        zero = n1bits.map {|s| '0' + s}
        one = n1bits.map {|s| '1' + s}
        
        return zero + one
    end
end # Integer


#
# Our own implementations of the standard Array methods each and
# each_with_index.
#
# >> %w(a b c).myeach {|s| puts s}
# a
# b
# c
# => 0...3
#
# %w(a b c) is shorthand for ["a", "b", "c"]
#
# >> %w(a b c).myeach_with_index {|i,s| puts "#{i+1}. #{s}"}
# 1. a
# 2. b
# 3. c
# => 0...3
#
class Array
    def myeach
        for i in (0...self.size)
            yield self[i]
        end
    end

    def myeach_with_index
        for i in (0...self.size)
            yield i, self[i]
        end
    end
end

#
# This example is based on this posting:
# https://scoutapm.com/blog/ruby-yield-blocks
#
# You can use it to estimate the time it takes for a block to be executed.
#
def measure_seconds
  start = Time.now
  yield
  elapsed = Time.now - start
  puts "Elapsed seconds: #{elapsed}"
end

measure_seconds do
    arr = (1..1000000).to_a
    arr.shuffle!
    arr.sort!
end

measure_seconds do
    arr = (1..10000000).to_a
    arr.shuffle!
    arr.sort!
end
