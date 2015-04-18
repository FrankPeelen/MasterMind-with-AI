require "../spec_helper"
require "../../lib/models/board"
require 'active_support/core_ext/kernel/reporting'

describe Board do
	let(:initial_code) { [1, 2, 3, 4] }
	subject(:board) { Board.new(Board::Code.new(initial_code)) }
	let(:enter_code) { [2, 3, 4, 4] }

	describe "#new" do
		its(:secret_code) { should be_a(Board::Code) }
		its("secret_code.combination") { should eq(initial_code) }
		its("field.size") { should eq(0) }
		its("feedback.size") { should eq(0) }
	end

	describe "#display" do
		it "empty field" do
			STDOUT.should_receive(:puts).with("\nMastermind Field").once
			STDOUT.should_receive(:puts).with("\nRound 1\n- - - -\n- - - -").once
			board.display
		end

		it "full field" do
			board.instance_variable_set(:@field, [Board::Code.new([2, 3, 4, 4]),
																						Board::Code.new([2, 3, 1, 4]),
																						Board::Code.new([2, 3, 1, 1]),
																						Board::Code.new([1, 1, 1, 1]),
																						Board::Code.new([2, 6, 6, 4]),
																						Board::Code.new([2, 3, 5, 4]),
																						Board::Code.new([2, 6, 5, 4]),
																						Board::Code.new([2, 3, 6, 4]),
																						Board::Code.new([2, 2, 2, 4]),
																						Board::Code.new([2, 3, 6, 6]),
																						Board::Code.new([2, 4, 4, 4]),
																						Board::Code.new([2, 1, 1, 4])])
			board.instance_variable_set(:@feedback, [["C", "I", "I", "-"],
																						["C", "I", "I", "I"],
																						["C", "I", "I", "-"],
																						["C", "-", "-", "-"],
																						["C", "I", "-", "-"],
																						["C", "I", "I", "-"],
																						["C", "I", "-", "-"],
																						["C", "I", "I", "-"],
																						["C", "C", "-", "-"],
																						["I", "I", "-", "-"],
																						["C", "I", "-", "-"],
																						["C", "I", "I", "-"]])
			STDOUT.should_receive(:puts).with("\nMastermind Field").once
			STDOUT.should_receive(:puts).with("\nRound 1\n2 3 4 4\nC I I -").once
			STDOUT.should_receive(:puts).with("\nRound 2\n2 3 1 4\nC I I I").once
			STDOUT.should_receive(:puts).with("\nRound 3\n2 3 1 1\nC I I -").once
			STDOUT.should_receive(:puts).with("\nRound 4\n1 1 1 1\nC - - -").once
			STDOUT.should_receive(:puts).with("\nRound 5\n2 6 6 4\nC I - -").once
			STDOUT.should_receive(:puts).with("\nRound 6\n2 3 5 4\nC I I -").once
			STDOUT.should_receive(:puts).with("\nRound 7\n2 6 5 4\nC I - -").once
			STDOUT.should_receive(:puts).with("\nRound 8\n2 3 6 4\nC I I -").once
			STDOUT.should_receive(:puts).with("\nRound 9\n2 2 2 4\nC C - -").once
			STDOUT.should_receive(:puts).with("\nRound 10\n2 3 6 6\nI I - -").once
			STDOUT.should_receive(:puts).with("\nRound 11\n2 4 4 4\nC I - -").once
			STDOUT.should_receive(:puts).with("\nRound 12\n2 1 1 4\nC I I -").once
			board.display
	  end
	end

	describe "#move" do
		context "valid move" do
			let!(:result) { board.move(Board::Code.new(enter_code)) }

			it { expect(result).to be_true }
			its("field.last.combination") { should eq(enter_code) }

			it "should call feedback" do
				expect(board).to receive(:give_feedback).once
				board.move(Board::Code.new(enter_code))
			end
		end

		context "argument is not a Board::Code" do
			let(:enter_code) { [1] }
			let(:result) { board.move(enter_code) }

			it { expect{ result }.to raise_error }
		end

		context "board is full" do
			let!(:setup) { 12.times { board.move(Board::Code.new(enter_code)) } }
			let(:result) { board.move(Board::Code.new(enter_code)) }

			it { expect(result).to be_false }
		end
	end

	describe "Code" do
		subject(:code) { Board::Code }
		describe "#new" do
			it { expect(code.new(initial_code).combination).to eq(initial_code) }
		end

		describe ".is_valid?" do
			# Argument is not an array
			it { expect(code.is_valid?(1)).to be_false }
			# Argument array is too long
			it { expect(code.is_valid?([1, 2, 3, 4, 5])).to be_false }
			# Argument array contains something else than an integer
			it { expect(code.is_valid?([1, 2, 'HEY', 4])).to be_false }
		end
	end

	describe "#give_feedback" do
		context "field is empty" do
			let(:feedback) { board.send(:give_feedback) }

			it { expect(feedback).to be_false }
		end

		context "field contains entries" do
			let!(:setup) { board.move(Board::Code.new(enter_code)) }

			context "C & I & -" do
				let!(:feedback) { board.send(:give_feedback) }

				it { expect(feedback).to be_true }
				its("feedback.last") { should eq(["C", "I", "I", "-"]) }
			end

			context "only -" do
				let(:enter_code) { [4, 4, 4, 6] }
				let!(:feedback) { board.send(:give_feedback) }

				it { expect(feedback).to be_true }
				its("feedback.last") { should eq(["I", "-", "-", "-"]) }
			end

			context "only C" do
				let(:enter_code) { [1, 2, 3, 4] }
				let!(:feedback) { board.send(:give_feedback) }

				it { expect(feedback).to be_true }
				its("feedback.last") { should eq(["C", "C", "C", "C"]) }
			end
		end
	end
end
