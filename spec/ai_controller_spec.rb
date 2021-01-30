require './lib/ai_controller'

describe AIController do
  describe '#generate_permutations' do
    before(:example) { @ai_controller = AIController.new }
    it 'Returns an array of correct length' do
      expect(
        @ai_controller.generate_permutations([1, 2, 3, 4, 5, 6], 4).count,
      ).to eql(1296)
      expect(@ai_controller.generate_permutations(%w[B W X], 4).count).to eql(
        81,
      )
    end
  end
  describe '#select_possible_codes' do
    before(:example) { @ai_controller = AIController.new }
    it 'Eliminates invalid codes' do
      codes = @ai_controller.generate_permutations([1, 2, 3, 4, 5, 6], 4)
      expect(
        @ai_controller
          .select_possible_codes(codes, [1, 1, 2, 2], %w[B W X X])
          .include?([2, 3, 4, 5]),
      ).to be false
    end
    it 'Retains valid codes' do
      codes = @ai_controller.generate_permutations([1, 2, 3, 4, 5, 6], 4)
      expect(
        @ai_controller
          .select_possible_codes(codes, [3, 4, 6, 5], %w[B B W X])
          .include?([3, 6, 2, 5]),
      ).to be true
    end
    it 'Works for empty hints' do
      codes = @ai_controller.generate_permutations([1, 2, 3, 4, 5, 6], 4)
      expect(
        @ai_controller
          .select_possible_codes(codes, [2, 2, 5, 4], %w[X X X X])
          .include?([3, 4, 6, 5]),
      ).to be false
    end
    it 'Works for correct guesses' do
      codes = @ai_controller.generate_permutations([1, 2, 3, 4, 5, 6], 4)
      expect(
        @ai_controller.select_possible_codes(codes, [1, 3, 3, 6], %w[B B B B]),
      ).to eql([[1, 3, 3, 6]])
    end
  end
  describe '#calculate_min_reduction' do
    before(:example) { @ai_controller = AIController.new }
    xit 'Calculates minimum reduction' do
    end
  end
  describe '#generate_code' do
    before(:example) { @ai_controller = AIController.new }
    it 'Returns an array' do
      expect(@ai_controller.generate_code.is_a?(Array)).to be(true)
    end
    it 'Returns a code of length 4' do
      expect(@ai_controller.generate_code.length).to eql(4)
    end
    it 'All array elements are integers' do
      expect(@ai_controller.generate_code.all? { |i| i.is_a?(Integer) }).to be(
        true,
      )
    end
    it 'All array elements are from 1 to 6 inclusive' do
      expect(@ai_controller.generate_code.all? { |i| i >= 1 && i <= 6 }).to be(
        true,
      )
    end
  end
  describe 'hint' do
    before(:example) { @ai_controller = AIController.new }
    it 'Identifies partially correct guesses' do
      code = [1, 2, 3, 4]
      expect(@ai_controller.hint([1, 2, 4, 5], code)).to eql(%w[B B W X])
    end
    it 'Identifies correct guesses' do
      code = [2, 3, 5, 4]
      expect(@ai_controller.hint([2, 3, 5, 4], code)).to eql(%w[B B B B])
    end
    it 'Identifies incorrect guesses' do
      code = [1, 2, 1, 2]
      expect(@ai_controller.hint([3, 4, 5, 6], code)).to eql(%w[X X X X])
    end
    it 'Works for repetitive codes' do
      code = [1, 2, 1, 1]
      expect(@ai_controller.hint([1, 1, 2, 2], code)).to eql(%w[B W W X])
    end
  end
end
