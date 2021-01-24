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
end
