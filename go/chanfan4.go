// Example code based on Google I/O 2012 concurrency presentation.
// http://www.youtube.com/watch?v=f6kdp27TYZs

package main

import (
    "fmt"
    "math/rand"
    "time"
)

func main() {
    c := fanIn(boring("joe"), boring("ann"))
    for i := 0; i < 20; i++ {
        fmt.Println(<-c)
    }
    fmt.Println("Bored, I'm leaving")
}

func boring(msg string) <-chan string { // return receive-only channel of strings
    c := make(chan string)
    go func() {
        for i := 0; ; i++ {
            c <- fmt.Sprintf("%s %d", msg, i)
            time.Sleep(time.Duration(rand.Intn(1e3)) * time.Millisecond)
        }
    }()
    return c //return channel to caller
}

/* multiplexer, 2 into 1 channel, async */
func fanIn(input1, input2 <-chan string) <-chan string {
    c := make(chan string)
    go func() {
        for {
            select {
            case s := <-input1:
                c <- s
            case s := <-input2:
                c <- s
            }
        }
    }()
    return c
}
