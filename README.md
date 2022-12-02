# ruby-hangman
Hangman Game in Ruby - Assignment from The Odin Project

The goal of this project is to build a simple command line Hangman game where
one player plays against a computer, but including the ability to save the game.

When a new game is started, a word between 5 and 12 characters long will be
randomly selected as the secret word from the provided dictionary.

As the player guesses, a count will be displayed informing them of how many
incorrect guesses remain before the game ends. 
Incorrect letters that have been chosen will be displayed, as well as any
correct letters chosen along with their position in the word.

Every turn, the player is allowed to make a guess of a letter (case insensitive).
At the start of each turn, the player also will have the option to save the game.

When the program first loads, the player can either start a new game or continue
from a previously saved game.