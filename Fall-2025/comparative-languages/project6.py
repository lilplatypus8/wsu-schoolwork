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
    """Reads in words from wordlist.txt and populates words_list dictionary"""

    global words_list
    global max_length

    # Check for file and read words, return error message if not found
    try:
        # Read words from file and populate the dictionary
        with open("wordlist.txt") as infile:
            
            # Read each line from file
            for line in infile:
                word = line.strip().lower()
                word_len = len(word)
                
                # Check if word is new longest word
                if word_len > max_length: 
                    max_length = word_len
                    
                # If words_list doesn't have key for word_len, create new key/value
                # Otherwise, add word to appropriate list by length
                if word_len not in words_list:
                    words_list[word_len] = [word]
                else: 
                    words_list[word_len].append(word) 
    except FileNotFoundError:
        print("Error: wordlist.txt file not found.")
        exit()
                
                
def update_hidden_word(hidden, chosen, guess):
    """Updates hidden word display based on user guess"""
    
    new_hidden = ""

    # Loop through each character in chosen word
    for i in range(len(chosen)):
        
        # If character matches guess, update hidden word display
        # Otherwise, keep existing asterisk in hidden word display
        if chosen[i] == guess:
            new_hidden = new_hidden + guess
        else:
            new_hidden = new_hidden + hidden[i]
    
    # Return updated hidden word display
    return new_hidden


# MAIN PROGRAM -------------------------------------------------------------------------

if __name__ == "__main__":
    
    # Initialize word list from file
    initalize_word_list()
    
    # Continually play game until user chooses to quit
    while True:
    
        # Initial welcome and word-length prompt
        print("Welcome to Hangman!")
    
        # Check if user input is valid and print error message and retry if not
        while True:
            length_input = input(f"What word-length would you like to play? (3 to {max_length}): ")
            if length_input.isdigit() and int(length_input) >= 3 and int(length_input) <= max_length:
                chosen_length = int(length_input)
                
                # Check if there are any words of chosen length left
                if chosen_length not in words_list or len(words_list[chosen_length]) == 0:
                    print(f"No more words of length {chosen_length} available. Please choose a different length.")
                    continue
                    
                break
            print("Invalid input. Please enter a number between 3 and n.")
        
        # Select random word of given length and remove it from words_list
        chosen_word = random.choice(words_list[chosen_length])
        words_list[chosen_length].remove(chosen_word)
        
        # Set num_guesses (2n - 1)
        num_guesses = (2 * chosen_length - 1)
        
        # Create word hidden with asterisks with the same length as chosen_word
        hidden_word = ""
        for i in range(chosen_length):
            hidden_word = hidden_word + "*"
    
        # Main gameplay loop
        while not word_solved:
            
            # Display main text
            print("Word: " + hidden_word)
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
                hidden_word = update_hidden_word(hidden_word, chosen_word, guess_input)
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
            # print success message, set word_solved to true, and exit from gameplay loop
            else:
                print("Congratulations, you guessed it!")
                word_solved = True
            
            # If the user guesses all correct letters;
            # print success message and set word_solved to true to exit from gameplay loop
            if hidden_word == chosen_word:
                print("Congratulations, you guessed it!")
                word_solved = True
            
            # If user runs out of guesses;
            # print failure message and break to exit from gameplay loop
            if num_guesses == 0:
                print("Failure. You ran out of guesses.")
                print(f"The word was: {chosen_word}")
                break
            
        replay_input = input("Would you like to play again? (y/n): ")
        
        # If user selects 'y', reset game (including any necessary global variables and play again
        # If user selects 'n', exit game entirely
        # Else, prompt again
        while True:
            if replay_input == "y":
                chosen_length = 0
                chosen_word = ""
                num_guesses = 0
                word_solved = False
                guessed_chars = []
                break
            elif replay_input == "n":
                print("Exiting...")
                exit()
            else: 
                print("Invalid input. Please try again.")
        
        