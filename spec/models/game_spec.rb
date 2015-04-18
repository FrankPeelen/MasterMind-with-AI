require "../spec_helper"
require "../../lib/models/game"
require "../../lib/models/player"
require "../../lib/models/ai"
require "../../lib/models/board"
require "stringio"

describe Game do
	subject(:game) { Game.new }
	let(:player_guesses) { [1, 2, 3, 4] }
	let(:creator) { double(:name => "Frank", :break_code => player_guesses) }
	let(:breaker) { double(:name => "AI", :create_code => [1, 2, 3, 4]) }
	before { Game.any_instance.stub(:create_player).and_return(creator)
					 Game.any_instance.stub(:create_ai).and_return(breaker)
					 Board.any_instance.stub(:puts)
					 Game.any_instance.stub(:puts)
					}

	describe "#new" do
		it { expect(game.instance_variable_get(:@breaker).name).to eq("Frank") }
		it { expect(game.instance_variable_get(:@creator).name).to eq("AI") }
		it { expect(game.instance_variable_get(:@board).secret_code.combination).to eq([1, 2, 3, 4]) }
	end

	describe "#play" do
		it "game over after play finishes" do
			game.play
			expect(game.game_over).to be_true
		end
	end

	describe "#game_over?" do
		let(:result) { game.game_over }
		let!(:setup) { game.instance_variable_set(:@board, double(:feedback => last_feedback, :field => field)) }

		context "no" do
			let(:field) { double(:length => 1) }
			let(:last_feedback) { [["C", "C", "I", "I"]] }
			it { expect(result).to eq(nil) }
		end

		context "yes" do
			context "Player wins" do
				let(:field) { double(:length => 1) }
				let(:last_feedback) { [["C", "C", "C", "C"]] }
				it { expect(result.name).to eq("Frank") }
			end

			context "AI wins" do
				let(:field) { double(:length => 12) }
				let(:last_feedback) { [["-", "-", "-", "-"]] }
				it { expect(result.name).to eq("AI") }
			end
		end
	end
end
