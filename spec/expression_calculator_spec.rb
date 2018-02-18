require_relative '../expression_calculator'

describe ExpressionCalculator do

  context 'expression' do

    it 'calculates simple expression' do
      expr = ExpressionCalculator.new('12-3*7')
      expect(expr.calculate).to eql -9
    end

    it 'calculates simple expression with spaces' do
      expr = ExpressionCalculator.new('12 - 3 * 7')
      expect(expr.calculate).to eql -9
    end

    it 'calculates simple expression with brackets' do
      expr = ExpressionCalculator.new('(12 - 3) * 7 + 5')
      expect(expr.calculate).to eql 68
    end

    it 'calculates simple expression with brackets and exponentiation' do
      expr = ExpressionCalculator.new('(12 - 3) ^ 2')
      expect(expr.calculate).to eql 81
    end

    it 'calculates simple expression with exponentiation' do
      expr = ExpressionCalculator.new('12 - 3 ^ 2')
      expect(expr.calculate).to eql 3
    end

    it 'returns nil when division by 0' do
      expr = ExpressionCalculator.new('(12 - 3) / 0')
      expect(expr.calculate).to eql nil
    end

    it 'raises error when brackets do not match' do
      expect{ ExpressionCalculator.new('(12 - 3) / (13 - 5') }.to raise_error(ExpressionCalculator::ExpresionBracketsError)
    end

  end

end