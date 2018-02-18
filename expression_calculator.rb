class ExpressionCalculator
  BRACKETS_REGEX = /[\(\)]/
  EXPRESSION_REGEX = /\d+|[\+\-\/\*\^\(\)]/
  LEFT = 0
  RIGHT = 1


  def initialize(expression)
    @postfix_array = convert_expression_to_postfix(expression)
  end

  def calculate
    stack = []

    @postfix_array.each do |elem|
      if elem =~ /\d/
        stack << elem.to_i
      else
        perform_operation(stack, elem)
      end
    end
    stack.pop
  end

  class ExpresionBracketsError < StandardError
    def initialize
      super("Brackets don't match!")
    end
  end

  private
    def convert_expression_to_postfix(expression)
      raise ExpresionBracketsError.new unless brackets_ok?(expression)

      operators_stack = []
      output = []

      expression_array = expression.scan(EXPRESSION_REGEX)

      expression_array.each do |token|
        case token
        when /\d/
          output << token
        when /[\+\-\/\*\^]/
          while pop_condition(token, operators_stack)
            output << operators_stack.pop
          end
          operators_stack << token
        when /\(/
          operators_stack << token
        when /\)/
          while operators_stack.last != '('
            output << operators_stack.pop
          end
          operators_stack.pop
        end
      end

      until operators_stack.empty?
        output << operators_stack.pop
      end
      output
    end

    def brackets_ok?(expression)
      brackets = expression.scan(BRACKETS_REGEX)
      brackets.count('(') == brackets.count(')')
    end

    def operator_priority(operator)
      case operator
      when '^'
        4
      when '*', '/'
        3
      when '+', '-'
        2
      end
    end

    def operator_associativity(operator)
      case operator
      when '^'
        RIGHT
      when '*', '/', '+', '-'
        LEFT
      end
    end

    def pop_condition(operator, stack)
      !stack.empty? && stack.last != '(' && operator_priority(operator) <= operator_priority(stack.last) &&
        operator_associativity(operator) == LEFT

    end

    def perform_operation(stack, operator)
      a = stack.pop
      b = stack.pop

      case operator
      when '^'
        stack << b ** a
      when '*'
        stack << b * a
      when '/'
        begin
          res = b / a
          stack << res
        rescue ZeroDivisionError
          return nil
        end
      when '+'
        stack << b + a
      when '-'
        stack << b - a
      end
    end
end
