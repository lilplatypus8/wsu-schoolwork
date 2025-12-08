# Josiah Schmitz

# PROBLEM 1 -----------------------------

# PART A
# string_a has exactly two integers and will match regex answer_1a
answer_1a = /^(\D*)(\d+)(\D+)(\d+)(\D*)$/
string_1a = "There are 2 numbers in this 1 sentence."
puts answer_1a.match?(string_1a)

# PART B
# string_b has no digits and will match regex answer_1b
answer_1b = /^(\D+)$/
string_1b = "This string has no digits."
puts answer_1b.match?(string_1b)

# PART C
# string_c starts with 's', has two consecutive vowels, and has those same two vowels later in string, so it will match regex answer_1c
answer_1c = /^(s([aeiou]{2})).*\2/
string_1c = "sour soup"
puts answer_1c.match?(string_1c)

# PROBLEM 5 -----------------------------

module Countable
  # Returns the number of enumerated objects from each()
  # Returns 0 if method doesn't have each()
  def count
    total = 0
    if self.class.method_defined?(:each)
      self.each { total = total + 1 }
    end
    return total
  end
end
