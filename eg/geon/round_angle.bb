export m

# round_angle
# an IEEE-754 double has 53 bit mantissa
# let's allow 3 bits for the integer part (8 > 2*pi)
# and let's chop off 3 bits to allow for imprecision
# that leaves 47 fractional bits to keep
const num round_angle_constant = 140737488355328.0
const num angle_epsilon = 1.0/round_angle_constant
num round_angle(num a)
	return round(a * round_angle_constant) / round_angle_constant

const num pi_times_2_rounded = round_angle(2*pi)
