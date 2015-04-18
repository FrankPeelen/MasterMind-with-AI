require "../spec_helper"
require "../../lib/models/human_player"
require "../../lib/models/board"

describe HumanPlayer do
	let(:name) { "Frank" }
	subject(:human) { HumanPlayer.new(name) }

	describe "#input_code" do
		before { human.stub(:puts) }
		let(:result) { human.input_code }

		context "valid code entered" do
			before { human.stub(:gets).and_return("2", "3", "4", "5") }
			it { expect(result).to eq([2, 3, 4, 5]) }
		end

		context "invalid characters entered also" do
			before { human.stub(:gets).and_return("f", "!", "askjdf", "0", "7", "-3", "3asd", "2", "3", "4", "5") }
			it { expect(result).to eq([2, 3, 4, 5]) }
		end
	end
end
