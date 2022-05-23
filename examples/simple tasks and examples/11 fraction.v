/*
Упражнение 11 ---

Для данного дробного x найти значение следующей функции f, принимающей дробные значения:

f(x)=       -x, if x <=0
            x2, if 0<x<2
            4, if x=>2

Введите x: 1,2

f(1,2) = 1,44
*/
import os

x := os.input('Enter your float number:').f64()
x1 := -x
x2 := x * x

if x < 0 {
	println('f($x)= $x1')
} else if x > 0 {
	if x < 2 {
		println('f($x) = $x2')
	} else {
		println('f($x) = 4')
	}
}
