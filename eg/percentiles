#!/lang/b
use b


Main()
	num x[] = { 86, 28, 8, 1, 76, 29 }
	int n = array_size(x)

	sort_num_array(x)

	for(which_percentile, 0.0, 100.0+epsilon, 5.0)
		int steps = n-1
		num steps_for_percentile = steps * which_percentile / 100.0

		int whole_steps = Floor(steps_for_percentile)
		num part_step = steps_for_percentile - whole_steps

		num percentile_value

		if whole_steps == steps
			percentile_value = x[n-1]
		 else
			num x0 = x[whole_steps]
			num x1 = x[whole_steps+1]

			num distance = x1-x0
			percentile_value = x0 + distance * part_step

		Sayf("%0.2f percentile: %f", which_percentile, percentile_value)

