require "../spec_helper"
require "../../lib/models/ai"
require "../../lib/models/board"

describe AI do
	let(:name) { "AI" }
	subject(:ai) { AI.new(name) }

	describe "#create_code" do
		let(:correct_code?) { Board::Code.is_valid?(created_code) }
		let(:created_code) { ai.create_code }

		it { expect(correct_code?).to be_true }
	end
end
