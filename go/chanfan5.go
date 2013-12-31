// Example code based on Google I/O 2012 concurrency presentation.
// http://www.youtube.com/watch?v=f6kdp27TYZs

package main

import (
    "fmt"
    "math/rand"
    "time"
)

func main() {
    c := boring("joe")
    for {
        select {
        case s := <-c:
            fmt.Println(s)
        case <-time.After(1 * time.Second):
            fmt.Println("too slow")
            return
        }
    }
    fmt.Println("Bored, I'm leaving")
}

func boring(msg string) <-chan string { // return receive-only channel of strings
    c := make(chan string)
    go func() {
        for i := 0; ; i++ {
            c <- fmt.Sprintf("%s %d", msg, i)
            sleepTime := time.Duration(100+rand.Intn(1e3)) * time.Millisecond
            fmt.Println(sleepTime)
            time.Sleep(sleepTime)
        }
    }()
    return c //return channel to caller
}
