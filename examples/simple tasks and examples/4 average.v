/*
Упражнение 4 +++

Напишите программу для нахождения среднего арифметического (половины суммы) и среднего геометрического (корня произведения) двух чисел.
Введите первое число: 12
Введите второе число: 3
Среднее арифметическое 12 и 3: 7,5
Среднее геометрическое 12 и 3: 6
*/
import os
import math

fn main() {
	first_number := os.input('Enter your first number: ').int()
	second_number := os.input('Enter your second number: ').int()
	av := (first_number + second_number) / 2
	avg := math.sqrt(first_number * second_number)

	println('Your average is: $av')
	println('Your average geometrical is: $avg')
}
