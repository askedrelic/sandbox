// Matt Behrens <askedrelic@gmail.com>
// 2013/04/08 16:57:42 

package main

import "strconv"
// import "fmt"

func IterativeFizz(max int) {
    for i:= 1; i <= max; i++ {
        if (i % 3 == 0 && i % 5 == 0) {
            println("fizzbuzz")
        } else if (i % 3 == 0) {
            println("fizz")
        } else if (i % 5 == 0) {
            println("buzz")
        } else {
            println(i)
        }
    }
}

func RecursiveFizz(max int, vals []string) {
    if max == 0 {
        return
    }

    val := ""
    if (max % 15 == 0) {
        val = "fizzbuzz"
    } else if (max % 3 == 0) {
        val = "fizz"
    } else if (max % 5 == 0) {
        val = "buzz"
    } else {
        val = strconv.Itoa(max)
    }
    vals[max-1] =  val

    RecursiveFizz(max - 1, vals)
}

// Writeaprogramthatprintsthenumbersfrom1 to 100. But for multiples of three
// print "Fizz" in- stead of the number and for the multiples of five print
// "Buzz". For numbers which are multiples of both three and five print
// "FizzBuzz".
func main() {
    IterativeFizz(30)
    println();
    vals := make([]string, 30)
    RecursiveFizz(30, vals)

    for x := 0; x < len(vals); x++ {
        println(vals[x])
    }
}
