package main

// import "os"

func main() {
    x := []int{
        48,96,86,68,
        57,82,63,70,
        37,34,83,27,
        19,97, 9,17,
    }

    var min int = 100;

    for val,key := range x  {
        println(val, key)
        if key < min {
            min = key
        }
    }
    println("min",min)

}
