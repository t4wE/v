/*
Упражнение 6 +++

Напишите программу для решения линейного уравнения ax+b=0, заданное своими коэффициентами a и b (a не равно 0). +++++++
Введите a: 3
Введите b: -12
x = 4


ax = -b
x = -b / a
*/
import os

fn main() {
	mut a := 0
	for {
		a = os.input('Enter a:').int()
		if a == 0 {
			println('a shouldnt be equal to zero')
		} else {
			break
		}
	}
	b := os.input('Enter b:').int()
	x := -b / a
	println(x)
}
