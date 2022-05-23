import os

fn main() {
	number := os.input('Enter your 2 digit number: ')
	println('Your number is: $number')
	n1:= number.int() / 10 
	n2:= number.int() % 10
	println(n1)
	println(n2)
}