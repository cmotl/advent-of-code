from itertools import tee
start=271973
stop=785961

possible_passcodes = range(start, stop)

def pairwise(iterable):
	a, b = tee(iterable)
	next(b, None)
	return zip(a, b)
	
def all_digits_increasing(digits):
	pairs = [(x,y) for x,y in pairwise(digits)]
	increasing_or_same = lambda x: x[0] <= x[1]
	return len(list(filter(increasing_or_same, pairs))) == 5	
	
def at_least_two_repeated_digits(digits):
	for x,y in pairwise(digits):
		if x == y:
			return True
		
	return False	
	
def valid_passcode(passcode):
	digits = [int(x) for x in str(passcode)]
	return all_digits_increasing(digits) and at_least_two_repeated_digits(digits)


assert(valid_passcode(111111) == True)
assert(valid_passcode(223450) == False)
assert(valid_passcode(123789) == False)



#valid_passcodes = list(filter(valid_passcode, possible_passcodes))
#print(len(valid_passcodes))



# part 2
from itertools import groupby

def only_two_repeated_digits(digits):
	duplicates = [sum(1 for _ in group) for _, group in groupby(digits)]
	for x in duplicates:
		if x == 2:
			return True
			
	return False


def valid_passcode_2(passcode):
	digits = [int(x) for x in str(passcode)]
	return all_digits_increasing(digits) and only_two_repeated_digits(digits)


assert(valid_passcode_2(112233) == True)
assert(valid_passcode_2(123444) == False)
assert(valid_passcode_2(111122) == True)

valid_passcodes2 = list(filter(valid_passcode_2, possible_passcodes))
print(len(valid_passcodes2))
