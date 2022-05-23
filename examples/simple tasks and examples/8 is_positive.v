/*
Упражнение 8 +++

Дано целое число. Проверить истинность высказывания: "Это число является положительным".
Введите целое число: -45
Это число не является положительным
*/
import os

fn main() {
	for {
		number := os.input('Enter your number: ').int()
		if number < 0 {
			println('Number should be positive')
		} else {
			break
		}
	}
	println('Number is positive')
}

/*
import os

fn is_prime(x int) bool {
	number := os.input('Enter your number:').int()

        if number > 0 {
            return false
       }

    return true
}
*/
