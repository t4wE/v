mut numbers := []int{cap: 1001}

println(numbers.len) // 0
numbers << 3435
println(numbers)
println(numbers.len)
// Now appending elements won't reallocate
for i in 0 .. 1000 {
	numbers << i
	
}
println(numbers)