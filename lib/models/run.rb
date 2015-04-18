require "./board"
require "./ai"
require "./game"

#board = Board.new(Board::Code.new([1, 2, 3, 4]))
#12.times { board.move(Board::Code.new([2, 3, 4, 5])) }
#board.display
#ai = AI.new("AI")
#board = Board.new(Board::Code.new(ai.create_code))
#oard.move(Board::Code.new([6, 3, 5, 5]))
#oard.move(Board::Code.new([1, 5, 3, 3]))
#board.move(Board::Code.new([5, 1, 4, 4]))
#board.move(Board::Code.new([1, 1, 2, 2]))
#board.move(Board::Code.new([1, 1, 2, 2]))
#board.move(Board::Code.new(ai.create_code))
#board.move(Board::Code.new(ai.create_code))
#board.move(Board::Code.new(ai.break_code(board.field, board.feedback)))
#board.move(Board::Code.new(ai.break_code(board.field, board.feedback)))
#board.move(Board::Code.new(ai.break_code(board.field, board.feedback)))

#board.move(Board::Code.new(ai.break_code(board.field, board.feedback)))
#board.move(Board::Code.new(ai.break_code(board.field, board.feedback)))
#board.move(Board::Code.new(ai.break_code(board.field, board.feedback)))
#board.field.each do |x| puts x.combination.to_s end
#puts board.feedback.to_s

game = Game.new
game.play