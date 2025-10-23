# Josiah Schmitz

# NOTES: Method pair? is a general object method.
# Methods list?, count, to_s, and null? are defined in both NilClass and Pair class. 
# All other methods requested (except global cons method) are specific to the Pair class.

class Object

    # Return false if the object is not a pair
    def pair?()
        false
    end

end

# Add custom methods to NilClass to handle the empty list represented by the nil value
class NilClass

    def list?()
        true
    end

    def count()
        0
    end

    def to_s()
        "()"
    end

    def null?()
        true
    end

end

class Pair 

    # Constructor to initialize the pair with two values
    def initialize(value1, value2)
        @value1 = value1
        @value2 = value2
    end

    # Get the first value of the pair
    def car()
        @value1
    end

    # Get the second value of the pair
    def cdr()
        @value2
    end

    # Returns null value (nil)
    def self.null()
        nil
    end

    # Returns true if object is a member of pair class
    def pair?()
       true
    end

    # Puts pair into string format
    def to_s()
        "(" + self.pair_to_s + ")"
    end
    
    # Helper method for to_s that recursives over nested pairs
    def pair_to_s()
        # Initializes string with just car value
        str = "#{car} "
        # If cdr is a pair, recursively call pair_to_s to make nested pair a string
        # If it doesn't end with the null value, add a dot and end the string with the cdr value
        # If it does end with null (proper list), strip the extra space at the end of the string and return it 
        if (cdr.pair?)
            str += cdr.pair_to_s
        elsif (cdr != Pair.null)
            str += ". #{cdr}"
        else
            str = str.strip
        end
        return str
    end

   # Returns true if the pair is a proper list (ends with null value)
   def list?()
        # BASE CASE: If the object is not a pair, return false
        # BASE CASE: If the pair ends in null, return true
        # RECURSIVE CASE: If the cdr is a pair, recursively call list? on the cdr
        # Otherwise, return false (This line shouldn't get hit, but just in case)
        if (self.pair? == false)
            return false
        elsif (self.cdr == Pair.null)
            return true
        elsif (self.cdr.pair? == true)
            return self.cdr.list?
        else 
            return false
        end
    end

    # Returns the count of elements in a proper list and false if not a proper list
    def count()
        # BASE CASE: If the object is not a proper list, return false
        # BASE CASE: If the cdr is null, return 1
        # RECURSIVE CASE: Return 1 + the count of the cdr
        if (self.list? == false)
            return false
        elsif (cdr == Pair.null)
            return 1
        else
            return 1 + cdr.count()
        end
    end

    # Returns false since a pair can never be null
    def null?()
        return false
    end

    def append(other)   
        # BASE CASE: If the object is not a list, return false
        # BASE CASE: If the cdr is null, return a new pair with car and other as values
        # RECURSIVE CASE: Return a new pair with the car and the result of appending other to the cdr
        if (self.list? == false)
            return false
        elsif (self.cdr == Pair.null)
            return cons(self.car, other)
        else
            return cons(self.car, self.cdr.append(other))
        end
    end

end

# Function to create a new Pair using Racket style cons
def cons(value1, value2)
    Pair.new(value1, value2)
end


=begin
puts("GIVEN TESTS:")
a = Pair.new(7, 5)
puts(a.to_s) # same as puts(a) ==> (7 . 5) 
b = cons(1, cons(2, cons(3, Pair.null)))
puts(b.to_s) # same as puts(b) ==> (1 2 3)
puts(a.pair?) # ==> true
puts(a.list?) # ==> false
puts(b.list?) # ==> true
puts(b.count) # ==> 3
c = b.append(a)
puts(c) # same as puts(c.to_s) ==> (1 2 3 7 . 5)
somestring = "hello world"
puts(somestring.pair?) # ==> false
puts("END GIVEN TESTS\n\n")

puts("ADDITIONAL TESTS:")
a = cons(1, cons(2, cons(3, cons(4, Pair.null))))
puts(a)
puts(a.list?)
puts(a.count)
puts(a.null?)
puts()
b = Pair.null
puts(b)
puts(b.list?)
puts(b.count)
puts(b.null?)
d = cons(Pair.null, Pair.null)
c = a.append(d)
puts(c)
=end