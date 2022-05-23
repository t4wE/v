
fn is_prime(x int) bool {
    for i in 2 .. x / 2 + 1 {
        if x % i == 0 {
            return false
       }
    }
    return true
}

fn is_prime2(x int) bool {for i in 2 .. x / 2 + 1 {if x % i == 0 {return false}}return true}
fn is_prime3(x int) bool {for i in 2 .. x / 2 + 1 {if x % i == 0 {return false} else {return true}}}

for i in 2 .. 1000 {
    if is_prime3(i) {
        println(i)
    }
}

