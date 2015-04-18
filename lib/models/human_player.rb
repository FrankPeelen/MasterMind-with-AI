require_relative "player"
require 'active_support/core_ext/integer/inflections'

class HumanPlayer < Player
	@@valid = ["1", "2", "3", "4", "5", "6"]  # User's input will have to match one of these strings to be valid.

	def create_code
		puts "\nCreate a code."
		input_code
	end

	def break_code
		puts "\nTry to break the code."
		input_code
	end

	# Gets a human player to try and break the code via the command line.
	#
	# ==== Returns
	#
	# * +Array+ - with 4 numbers listed in @@valid. Board::Code.is_valid? will return true when given result as param.
	def input_code
		guess = []
		(1..4).each do |x|
			puts "Please enter your #{x.ordinalize} number."
			loop do
				input = gets.chomp
				if @@valid.include?(input)
					guess.push(input.to_i)
					break
				end
				puts "Your input was not a number between 1 and 6. Please try again."
			end
		end
		return guess
	end
end
