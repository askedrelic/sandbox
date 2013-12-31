// Example code based on Google I/O 2012 concurrency presentation.
// http://www.youtube.com/watch?v=f6kdp27TYZs

package main

import (
    "fmt"
    "math/rand"
    "time"
)

func main() {
    go boring("boring!")
    fmt.Println("I'm listening.")
    time.Sleep(2 * time.Second)
    fmt.Println("Bored, I'm leaving")
}
func boring(msg string) {
    for i := 0; ; i++ {
        fmt.Println(msg, i)
        time.Sleep(time.Duration(rand.Intn(1e3)) * time.Millisecond)
    }
}
