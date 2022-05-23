/*
Упражнение 10 +++

Даны три числа. Найти сумму двух наибольших из них.

Введите 1-ое число: 1
Введите 2-ое число: 6
Введите 3-е число: 15

Сумма двух больших равна 21
*/
import os

fn main() {
	n1 := os.input('Enter your first number: ').int()
	n2 := os.input('Enter your second number: ').int()
	n3 := os.input('Enter your third number: ').int()
	a := n1 + n2
	b := n1 + n3
	c := n2 + n3
	if n1 > n2 {
		if n2 > n3 {
			println('Sum of 2 highest is : $a')
		} else {
			println('Sum of 2 highest is : $b')
		}
	} else if n2 > n1 {
		if n1 > n3 {
			println('Sum of 2 highest is : $a')
		} else {
			println('Sum of 2 highest is : $c')
		}
	} else {
		println('Sum of 2 highest is : $c')
	}
}
