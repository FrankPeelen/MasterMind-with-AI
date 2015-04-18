class Board
	attr_reader :secret_code, :field, :feedback

	def initialize(secret_code)
		@secret_code = secret_code
		@field = []
		@feedback = []
	end

	def display
		puts "\nMastermind Field"
		x = 1
		while x <= @field.length
			display_helper(x, @field[x - 1].combination, @feedback[x - 1])
			x += 1
		end 
		display_helper(x) if x == 1
	end

	# Makes a move on the board and updates @feedback.
	#
	# ==== Arguments
	#
	# * +code+ - Has to be an instance of Board::Code
	#
	# ==== Returns
	#
	# * +boolean+ True if the move is valid, false if the board is full.
	def move(code)
		raise ArgumentError unless code.is_a?(Code)
		return @field.size < 12 ? field.push(code) && give_feedback : false
	end

	class Code
		attr_reader :combination
		def initialize(combination)
			raise ArgumentError unless self.class.is_valid?(combination)
			@combination = combination
		end

		def self.is_valid?(arr)
			return arr.is_a?(Array) && arr.size == 4 && arr.all? { |x| x.is_a?(Integer) }
		end
	end

	private
	# This method helps display the board (game's current status) to the user. It displays as:
	# 
	# Round 1
	# 1 3 2 6
	# C I I -
	#
	# C = Correct
	# I = Incorrectly placed, but correct number
	# - = Wrong
	#
	# ==== Arguments
	#
	# * +round+ - The number of the round which's information will be displayed.
	# * +score+ - The score for the round.
	# * +feedback+ - The feedback for the round.
	def display_helper(round, score = ["-", "-", "-", "-"], feedback = ["-", "-", "-", "-"])
		puts "\nRound #{round}\n#{score[0]} #{score[1]} #{score[2]} #{score[3]}" \
		     "\n#{feedback[0]} #{feedback[1]} #{feedback[2]} #{feedback[3]}"
	end

	# This method gives feedback for any @field and stores it in @feedback.
	# Any codes in @field that haven't been given feedback yet will be given feedback.
	#
	# ==== Returns
	#
	# * +boolean+ - True if feedback has been correctly updated, false if feedback can't be given.
	def give_feedback
		return false if @field.empty?
		(@feedback.size).upto(@field.size - 1) do |x|
			temp_secret_code = @secret_code.combination.dup
			combination = @field[x].combination.dup
			feedback = []
			y = 0
			z = 3
			while y <= z
				if combination[y] == temp_secret_code[y]
					feedback.push("C")
					temp_secret_code.delete_at(y)
					combination.delete_at(y)
					z -= 1
				else y += 1
				end
			end
			(0..(combination.size - 1)).each do |y|
				if temp_secret_code.include?(combination[y])
					feedback.push("I")
					temp_secret_code.delete_at(temp_secret_code.index(combination[y]))
				end
			end
			while feedback.size < 4
				feedback.push("-")
			end
			@feedback.push(feedback)
		end
	end
end
