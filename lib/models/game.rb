require_relative  "board"
require_relative  "player"
require_relative  "ai"
require_relative  "human_player"


class Game
	def initialize
		initialize_players
		@board = Board.new(create_code)
	end

	def play
		until game_over
			@board.display
			@board.move(break_code)
		end
		@board.display
		puts "#{game_over.name} has won the game!"
		puts "The secret code was #{@board.secret_code.combination}"
	end

	# Finds out whether there is a winner or the game is still in progress.
	#
	# ==== Returns
	#
	# * +Player+ - The player who has won or nil if there is no winner.
	def game_over
		return @breaker if @board.feedback.last == ["C", "C", "C", "C"]
		return @creator if @board.field.length == 12
		return nil
	end

	private
	def initialize_players
		puts "Please enter your name:"
		name = gets.chomp
		puts "Would you like to break or create the code?"
		puts "Enter 'b' to attempt to break our AI's code."
		puts "Enter 'c' to create a code for our AI to break."
		loop do 
			input = gets.chomp
			if input == 'b'
				@breaker = HumanPlayer.new(name)
				@creator = AI.new("AI")
				return
			elsif input == 'c'
				@breaker = AI.new("AI")
				@creator = HumanPlayer.new(name)
				return
			else
				puts "Your input did not match 'b' nor 'c'."
				puts "Enter 'b' to attempt to break our AI's code."
				puts "Enter 'c' to create a code for our AI to break."
			end
		end
	end

	def create_code
		Board::Code.new(@creator.create_code)
	end

	def break_code
		Board::Code.new(@breaker.break_code(@board.field, @board.feedback))
	end
end
