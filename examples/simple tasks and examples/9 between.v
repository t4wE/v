/*
Упражнение 2

Дано три целых числа. Проверить истинность высказывания: "Второе число находится между первым и третьем по величине".

Введите 1-ое число: 2
Введите 2-ое число: 3
Введите 3-е число: 10

Второе число действительно находится между первым и третьим
*/
import os

fn main() {
	number1 := os.input('Enter your first number: ').int()
	number2 := os.input('Enter your second number: ').int()
	number3 := os.input('Enter your third number: ').int()
	if number3 > number2 {
		if number2 > number1 {
			println('Second number is between first and third')
		} else {
			println('Second number is NOT between first and third')
		}
	} else {
		println('Second number is NOT between first and third')
	}
}
