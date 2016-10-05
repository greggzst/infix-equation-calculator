input_array = gets.chomp.split('')
infix_array = []

def prep_fun
	str = ""
	input_array.each do |x|
		case x
		when '+','-','*','/'
			infix_array << str
			ainfix_array << x
			str = ""
		else
			str += x
		end
	end
end

