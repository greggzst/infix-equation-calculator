puts "Type an equation, hit return and it will be calculated for you:"
input_array = gets.chomp.split('')

#prep_fun does preparation like linking numbers that contain more digits
def prep_fun(user_input)
	infix_array = []
	parenthesis = 0 #to check if parenthesis are right
	str = ""
	user_input.each do |x| #goes through all numbers and does magic
		case x
		when '+','-','*','/'
			infix_array << str unless str.to_s.strip.empty? #unless there's number in string do not add it to output
			infix_array << x
			str = ""
		when '('
			infix_array << x
			parenthesis += 1
		when ')'
			infix_array << str unless str.to_s.strip.empty? #unless there's number in string do not add it to output
			infix_array << x
			str = ""
			parenthesis -= 1
		else
			str += x #add digit to string
		end
	end

	infix_array << str unless str.to_s.strip.empty? #unless there's number in string do not add it to output
	infix_array if parenthesis == 0 #if parenthesis are right return output else return nil
end

#function that converts infix to posfix
def infix_to_postfix(infix)
	postfix = []
	stack = []

	infix.each do |x|
		case x
		when '+','-','*','/','('
			if stack.empty? || priority(x) > priority(stack[stack.length-1]) #check priority of top operator
				stack.push(x)
			else
				operation = stack.pop
				while !stack.empty? && priority(x) <= priority(operation) #pop operator from the stack if its priority is greater than
					postfix << operation
					operation = stack.pop
				end
				postfix << operation
				stack.push(x)
			end
		when ')'
			operation = stack.pop
			while operation != '('
				postfix << operation
				operation = stack.pop
			end
		else
			postfix << x
		end
	end

	until stack.empty? #until stack is not empty add its elements to output
		postfix << stack.pop
	end
	postfix
end

#return priority depending on operator
def priority(opr)
	case opr
	when '('
		0
	when '+','-',')'
		1
	when '*','/'
		2
	end
end

#calculate posfix 
def calculate_postix(postfix)
	stack = []
	postfix.each do |x|
		case x
		when '+','-','*','/'
			a = stack.pop.to_i
			b = stack.pop.to_i

			calc(x,a,b,stack)		
		else
			stack.push(x.to_i)
		end
	end
	stack.pop.to_i	
end

#runs calculations on numbers depending on operator
def calc(x,a,b,stack)
	case x
	when '+'
		stack.push(b+a)
	when '-'
		stack.push(b-a)
	when '*'
		stack.push(b*a)
	when '/'
		stack.push(b/a)
	end
end
infix = prep_fun(input_array)
#puts infix.inspect #control printout of infix prep
postfix = infix_to_postfix(infix)
#puts postfix.inspect #control printout of postfix
result = calculate_postix(postfix)
puts "The answer is #{result}" 
