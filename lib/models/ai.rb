require_relative  "player"
require_relative  "Board"

class AI < Player
	def create_code
		code = []
		(0..3).each do |x|
			code.push(1 + rand(6))
		end
		code
	end

	# WARNING: THE CODE BELOW HAS NOT BEEN REFACTORED AT ALL. VERY UNCLEAN CODE.
	# Got very lazy here at the end and did not refactor the below code from the AI here.

	def break_code(field, feedback)
		return [1, 1, 2, 2] if field.empty?
		poss = possible_moves(field, feedback)
		puts "\nAI: I have determined the amount of possible moves to be #{poss.size}."
		if poss.size > 40
			puts "AI: Calculating the optimal move would take more than a minute. Making a random guess."
			return poss[0 + rand(poss.size)]
		end
		solve_semi_optimal(field, feedback, poss)
	end

	private
	def solve_semi_optimal(field, feedback, poss)
		puts "AI: Calculating a close to optimal move. This should take no more than about a minute."
		min = [[1, 1, 1, 1], 100**100]
		poss.each do |mov|
			rating = 0
			poss.each do |mov2|
				hypoth_board = Board.new(Board::Code.new(mov2))
				hypoth_board.instance_variable_set(:@field, field.dup)
				hypoth_board.instance_variable_set(:@feedback, feedback.dup)
				hypoth_board.move(Board::Code.new(mov))
				rating += possible_moves(hypoth_board.field, hypoth_board.feedback).size
			end
			if rating < min[1]
				min[0] = mov
				min[1] = rating
			end
		end
		# Result
		puts min.to_s
		min[0]
	end

	# BROKEN!!!!!
	def solve_optimal(field, feedback, poss)
		puts "AI: Calculating the optimal move. This should take no more than about a minute."
		min = [[1, 1, 1, 1], 100**100]
		all_legal_moves.each do |mov|
			rating = 0
			poss.each do |mov2|
				hypoth_board = Board.new(Board::Code.new(mov2))
				hypoth_board.instance_variable_set(:@field, field.dup)
				hypoth_board.instance_variable_set(:@feedback, feedback.dup)
				hypoth_board.move(Board::Code.new(mov))
				rating += possible_moves(hypoth_board.field, hypoth_board.feedback).size
			end
			if rating < min[1]
				min[0] = mov
				min[1] = rating
			end
		end
		# Result
		puts min.to_s
		min[0]
	end

	def possible_moves(field, feedback)
		# Set up an array with all possible moves given a blank field.
		poss_moves = all_legal_moves
		# Substract the moves that are no longer possible given the field in board.
		0.upto(field.length - 1).each do |round|
			c = 0
			i = 0
			feedback[round].each do |fdbck|
				c += 1 if fdbck == "C"
				i += 1 if fdbck == "I"
			end
			poss_moves.select! { |poss_move|
				match = 0
				contain = 0
				not_contain = 0
				counted = []
				for a in 0..3 do
					indices = field[round].combination.size.times.select { |x| field[round].combination[x] == poss_move[a] }
					if poss_move[a] == field[round].combination[a]
						match += 1
						counted.push(a)
					elsif field[round].combination.include?(poss_move[a])
						b = 0
						while b < indices.length
							unless counted.include?(indices[b])
								contain += 1
								counted.push(indices[b])
								b += 4
							end
							b += 1
						end
					end
				end
				match == c &&	contain >= i
			}
		end
		poss_moves
	end

	def all_legal_moves
		legal_moves = []
		one_to_six_loop { |a| one_to_six_loop { |b| one_to_six_loop { |c| one_to_six_loop { |d|
			legal_moves.push([a, b, c, d])
		} } } }
		legal_moves
	end

	def one_to_six_loop
		(1..6).each do
			|x|
			yield(x)
		end
	end
end
