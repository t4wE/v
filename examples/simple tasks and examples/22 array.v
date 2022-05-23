/*
1. Создать произвольный список
2. Добавить новый элемент типа int на место с индексом
3. Получить элемент по индексу
4. Удалить элемент
5. Найти число повторений элемента списка ????
6. Проверить, есть ли в последовательности дубликаты
7. Получите первый и последний элемент списка
*/
import arrays

mut nums := [1, 2, 3]
 nums << 6

println(nums) // `[1, 2, 3]`
println(nums[3]) // `1`
nums.delete(1)
println(nums) // `2`
println(nums.first())
println(nums.last())
println( nums.any(it == 3))

 for i in nums {
    i++
    if nums = 1 { 
        print ()i
    }
 }
