require './lib/maker'

describe Maker do
  describe '#generate_code' do
    before(:example) { @maker = Maker.new }
    it 'Returns an array' do
      expect(@maker.generate_code.is_a?(Array)).to be(true)
    end
    it 'Returns a code of length 4' do
      expect(@maker.generate_code.length).to eql(4)
    end
    it 'All array elements are integers' do
      expect(@maker.generate_code.all? { |i| i.is_a?(Integer) }).to be(true)
    end
    it 'All array elements are from 1 to 6 inclusive' do
      expect(@maker.generate_code.all? { |i| i >= 1 && i <= 6 }).to be(true)
    end
  end

  describe 'hint' do
    before(:example) { @maker = Maker.new }
    it 'Identifies partially correct guesses' do
      guess = [1, 2, 3, 4]
      expect(@maker.hint([1, 2, 4, 5], guess)).to eql(%w[B B W])
    end
    it 'Identifies correct guesses' do
      guess = [2, 3, 5, 4]
      expect(@maker.hint([2, 3, 5, 4], guess)).to eql(%w[B B B B])
    end
    it 'Identifies incorrect guesses' do
      guess = [1, 2, 1, 2]
      expect(@maker.hint([3, 4, 5, 6], guess)).to eql([])
    end
    it 'Works for repetitive codes' do
      guess = [1, 2, 1, 1]
      expect(@maker.hint([1, 1, 2, 2], guess)).to eql(%w[B W W])
    end
  end
end
