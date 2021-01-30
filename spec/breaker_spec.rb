require './lib/breaker'

describe Breaker do
  describe '#generate_permutations' do
    before(:example) { @breaker = Breaker.new(true) }
    it 'Returns an array of correct length' do
      expect(
        @breaker.generate_permutations([1, 2, 3, 4, 5, 6], 4).count,
      ).to eql(1296)
      expect(@breaker.generate_permutations(%w[B W X], 4).count).to eql(81)
    end
  end
  describe '#select_possible_codes' do
    before(:example) { @breaker = Breaker.new(true) }
    it 'Eliminates invalid codes' do
      codes = @breaker.generate_permutations([1, 2, 3, 4, 5, 6], 4)
      expect(
        @breaker
          .select_possible_codes(codes, [1, 1, 2, 2], %w[B W X X])
          .include?([2, 3, 4, 5]),
      ).to be false
    end
    it 'Retains valid codes' do
      codes = @breaker.generate_permutations([1, 2, 3, 4, 5, 6], 4)
      expect(
        @breaker
          .select_possible_codes(codes, [3, 4, 6, 5], %w[B B W X])
          .include?([3, 6, 2, 5]),
      ).to be true
    end
    it 'Works for empty hints' do
      codes = @breaker.generate_permutations([1, 2, 3, 4, 5, 6], 4)
      expect(
        @breaker
          .select_possible_codes(codes, [2, 2, 5, 4], %w[X X X X])
          .include?([3, 4, 6, 5]),
      ).to be false
    end
    it 'Works for correct guesses' do
      codes = @breaker.generate_permutations([1, 2, 3, 4, 5, 6], 4)
      expect(
        @breaker.select_possible_codes(codes, [1, 3, 3, 6], %w[B B B B]),
      ).to eql([[1, 3, 3, 6]])
    end
  end
  describe '#calculate_min_reduction' do
    before(:example) { @breaker = Breaker.new(true) }
    it 'Calculates minimum reduction' do
    end
  end
end
