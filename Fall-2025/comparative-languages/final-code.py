# Josiah Schmitz

# PROBLEM 9 -----------------------------
print("PROBLEM 9 -----")

# set check_type to return value of test_int's type
test_int = 9
check_type = type(test_int)
print(check_type) # --> <class 'int'>

# PROBLEM 10 -----------------------------
print("PROBLEM 10 -----")

# set check_object to return whether int_object is an instance of int
int_object = 11
check_object = isinstance(int_object, int)
print(f"{check_object} is an instance of the integer class.")

# PROBLEM 11 -----------------------------
print("PROBLEM 11 -----")

# Function to be used as first class object
def first_class(text):
    print(text)

# Function is assigned to a variable
first_class_object = first_class("This function is a first class object.")

# Function that is passed and returns a function
def return_function(func):
    return func

# Function is returned from another function
returned_first_class = return_function(first_class)

# PROBLEM 12 -----------------------------
print("PROBLEM 12 -----")

# sort() is destructive because the original list is modified in place
# Notice how the type of list1 becomes Nonetype after calling sort()
list1 = [1, 3, 5, 2, 4]
print(f"list1's type: {type(list1)}")
list1 = list1.sort()
print(f"list1.sort()'s type: {type(list1)}")

# sorted() is non-destructive because it returns a new sorted list
# Notice how the type of list2 remains a list after calling sorted()
list2 = [7, 10, 8, 6, 9]
print(f"list2's type: {type(list2)}")
list2 = sorted(list2)
print(f"list2.sort()'s type: {type(list2)}")

# PROBLEM 13 -----------------------------
print("PROBLEM 13 -----")

# List3 takes all numbers 0-9 and doubles the evens and triples the odds
list3 = [2*x if x % 2 == 0 else 3*x for x in range(10)]
print(list3) # --> [0, 3, 4, 9, 8, 15, 12, 21, 16, 27]

# PROBLEM 15 -----------------------------
print("PROBLEM 15 -----")

# Generator that yields each element of data in order
def generator(data):
    for i in range(len(data)):
        yield(data[i])

# Use generator to print each element twice
for element in generator("hello"):
    print(f"{element}{element}") # --> "hh ee ll ll oo"

# PROBLEM 16 -----------------------------
print("PROBLEM 16 -----")

# Decorator that reverses the output of a string-returning function
def reverse_string(function):
    def wrapper():
        new_string = ""
        for i in range(len(function())-1, -1, -1): # Iterating over function's string in reverse
            new_string = new_string + function()[i]
        return new_string
    return wrapper

# Original function that returns name, now with decorator tag
@reverse_string
def name():
    return "john doe"

print(name()) # --> "eod nhoj"

# PROBLEM 17 -----------------------------
print("PROBLEM 17 -----")

# Generator that produces binary numbers as strings
def my_generator():
    for i in range(1000): # Iterates until break is called in test code or 1000 is reached (unlikely to happen)
        int_as_binary = bin(i) # Converts number to binary
        return_string = str(int_as_binary[2:]) # Returns binary number without prefix
        yield(return_string)


# PROBLEM 18 -----------------------------
print("PROBLEM 18 -----")

# Prints the return value of the function and returns None instead
def print_instead(function):
    def wrapper(*args):
        print(function(*args))
        return None
    return wrapper