// Testing channels, see chanfanX.go for more
//
// Ideas from Rob Pikes Google IO 2012 presentation:
// http://www.youtube.com/watch?v=f6kdp27TYZs

package main

import (
    "fmt"
    "math/rand"
    "time"
)

func main() {
    theBoard := make(chan string) // 2 way channel?
    ping := paddle("ping", theBoard)
    pong := paddle("pong", theBoard)
    ping <- "bounce"
}

func paddle(name string, sender <-chan string) {
    // c := make(chan string)
    go func() {
        for i := 0; i < 5; i++ {
            msg := <-sender
            // sender <- "bounce"
            sender <- msg
            fmt.Println("bounce")
            time.Sleep(time.Duration(rand.Intn(1e3)) * time.Millisecond)
        }
    }()
}
