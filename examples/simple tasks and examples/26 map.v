/*
1. Создать произвольный словарь
2. Добавить новый элемент с ключом типа str и значением типа int 
3. Добавить новый элемент с ключом типа кортеж(tuple) и значением типа список(list)
4. Получить элемент по ключу
5. Удалить элемент по ключу
6. Получить список ключей словаря
*/






fn main(){

mut m := map[string]int{} // a map with `string` keys and `int` values

m = {
	'one': 1
	'two': 2
	'three' : 3
	'four' : 4
	'five' : 5
}
m['six'] = 6
m['two'] = 2
m.delete('two')

println(m)

println(m['three'])
println(m.keys())

}