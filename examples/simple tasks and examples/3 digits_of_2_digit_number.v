/*
Упражнение 3 +++

Напишите программу для нахождения первой и второй цифры двузначного числа. Вот пример output’a после выполнения этой программы:
Введите двузначное число: 39
Первая цифра этого числа: 3
Вторая цифра этого числа: 9
*/
import os

fn main() {
	number := os.input('Enter your 2 digit number: ').int()
	if number > 99 {
		println('Number should be 2 digit')
	} else if number < 0 {
		println('Number should be positive')
	} else {
		println('Your number is: $number')
		n1 := number / 10
		n2 := number % 10
		println(n1)
		println(n2)
	}
}
