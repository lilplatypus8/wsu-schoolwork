# Josiah Schmitz

import random

words_list = {} # dictionary to hold list of all words organized by length
chosen_length = 0 # integer to hold user-chosen length of word
chosen_word = "" # string to hold word for game
num_guesses = 0 # integer to hold number of guesses left
word_solved = False # boolean to determine if the word has been solved
max_length = 0 # determines length of longest word in text file
guessed_chars = [] # holds all characters already guessed


def initalize_word_list():

    global words_list
    global max_length

    # Initialize dictionary with empty lists for word lengths 3 to 10
    for i in range(3, 11):
        words_list[i] = []

    # Read words from file and populate the dictionary
    with open("wordlist.txt") as infile:
        for line in infile:
            word = line.strip().lower()
            word_len = len(word)
            
            # Check if word is new longest word
            if word_len > max_length: 
                max_length = word_len
                
            # If words_list doesn't have key for word_len, create new key/value
            # Otherwise, add word to appropriate list by length
            if not words_list.__contains__(word_len):
                words_list[word_len] = [word]
            else: 
                words_list[word_len].append(word) 

# MAIN PROGRAM

# Initialize word list from file
initalize_word_list()

# Continually play game until user chooses to quit
while True:

    # Initial welcome and word-length prompt
    print("Welcome to Hangman!")

    # Check if user input is valid and print error message and retry if not
    while True:
        length_input = input("What word-length would you like to play? (3 to n): ")
        if length_input.isdigit() and int(length_input) >= 3 and int(length_input) <= 10:
            chosen_length = int(length_input)
            break
        print("Invalid input. Please enter a number between 3 and n.")
    
    # Select random word of given length and remove it from words_list
    chosen_word = random.choice(words_list[chosen_length])
    words_list[chosen_length].remove(chosen_word)
    
    # Set num_guesses (2n - 1)
    num_guesses = (2 * chosen_length - 1)
    print(num_guesses)
    
    # Create blank word with the same length as chosen_word
    hidden_word = ""
    for i in range(chosen_length):
        hidden_word = hidden_word + "*"

    # Main gameplay loop
    while not word_solved:
        
        # Display main text
        print("Word: " + chosen_word)
        print(f"You have {num_guesses} guesses remaining.")
        guess_input = input("Type a letter or a word guess: ").lower()

        # Work through various gameplay choices:
        # Case 1: User guesses with invalid input;
        # return error message and retry
        if not guess_input.isalpha() or len(guess_input) == 2 or len(guess_input) > max_length:
            print("Invalid input! Try again.")
            
        # Case 2: User guesses repeat letter;
        # retry
        elif len(guess_input) == 1 and guess_input in guessed_chars:
            print(f"You guessed {guess_input} before!")
            
        # Case 3: User guesses new incorrect letter;
        # update num_guesses and guessed_chars and retry
        elif len(guess_input) == 1 and guess_input not in chosen_word:
            num_guesses = num_guesses - 1
            guessed_chars.append(guess_input)
            print(f"Sorry, there are no {guess_input}'s.")
            
        # Case 4: User guesses new correct letter;
        # update num_guesses, guessed_chars, and word display and retry
        elif len(guess_input) == 1 and guess_input in chosen_word:
            num_guesses = num_guesses - 1
            guessed_chars.append(guess_input)
            num_letters = chosen_word.count(guess_input)
            # Checks if I need to use plural language in the response
            if num_letters > 1:
                print(f"There are {num_letters} {guess_input}'s!")
            else:
                print(f"There is 1 {guess_input}!")
        
        # Case 5: User guesses incorrect word;
        # update num_guesses and retry
        elif guess_input != chosen_word:
            num_guesses = num_guesses - 1
            print(f"Sorry, the word is not '{guess_input}'.")
        
        # Case 6: User guesses correct word;
        # print success message and set word_solved to true from gameplay loop
        else:
            print("Congratulations, you guessed it!")
            word_solved = True
        
        # Exit gameplay loop if user runs out of guesses
        if num_guesses == 0:
            print("Failure. You ran out of guesses.")
            word_solved = False
        
    # If user selects 'y', reset game (including any necessary global variables and play again
    # If user selects anything else (including 'n'), exit game entirely
    if input("Would you like to play again? (y/n): ") == "y":
        chosen_length = 0
        chosen_word = ""
        num_guesses = 0
        word_solved = False
        guessed_chars = []
    else:
        exit()
    
    