package main

import "fmt"

func main() {
	println("hello, world\n")
	doSomething()
	/* lookup() */
}

func doSomething() {
    var foo int
    hello := "Hello World"

    println("foo", foo)
    foo = 6
    println("foo", foo)
    bar := 8
    println(bar, foo)
    fmt.Println(hello[1])
    fmt.Println("len", len(hello))
    for x,y := range hello {
        fmt.Println(x,y)
    }

    fmt.Println((true&& false) || (false&&true) || !(false&&false))

    x := 5; x += 1
    fmt.Println("x", x)

    for i := 1; i <= 10; i++ {
        if i % 2 == 0 {
            fmt.Println(i, "even")
        } else { }
    }



}

func lookup(phonebook map[string]string) {
    for key, val := range phonebook {
        println("thing", key, val)
    }

    slc := []string{"foo","bar"}
    for i, val := range slc {
        println(i, val)
    }

}

// A struct corresponding to the TimeStamp protocol buffer.
// The tag strings define the protocol buffer field numbers.
type Time struct {
	microsec  uint64 "field 1"
	serverIP6 uint64 "field 2"
	process   string "field 3"
}

/* // An empty struct. */
/* struct {} */

/* // A struct with 6 fields. */
/* struct { */
/* 	x, y int */
/* 	u float32 */
/* 	_ float32  // padding */
/* 	A *[]int */
/* 	F func() */
/* } */

