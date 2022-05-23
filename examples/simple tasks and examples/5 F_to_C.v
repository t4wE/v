/*
Упражнение 5 +++

Дана температура по Фаренгейту. Напишите программу, которая переведёт её в температуру по Цельсию (С = 5/9*(F-32)).
Введите температуру по Фаренгейту: 212
Эта же температура по Цельсию: 100
*/

import os

fn main() {
	fahr := os.input('Enter your Fahrenheit temperature:').int()
	cel:= (fahr - 32 )*5 / 9
	println('Celcium temperature is: $cel')
}