// functionsAndClosures.go

package main

import (
    "fmt"
    "strings"
)

func main() {
    test_makeAdder()
    test_makeIncrementer()
    test_mapstr()
}

//
// Returns a closure (a function with an associated environment of variables)
// that adds n to a given int. In other words, it makes a function that adds n
// to a number.
//
func makeAdder(n int) func(int) int {
    return func(a int) int {
        return a + n
    }
}

func test_makeAdder() {
    add5 := makeAdder(5)
    n := 1
    fmt.Printf("n=%v\n", n)
    fmt.Printf("n=%v\n", add5(n))
}


//
// An incrementer is a value that supports these two operations after it is
// created:
//
// - Add 1 (increment)
// - Return the current value
//
// makeIncrementer returns two closures, once for each of these operations.
// Both closes share the same variable n.
func makeIncrementer() (func(), func() int) {
    // n is the value to be incremented
    n := 0
    inc := func() {
        n++
    }
    get := func() int {
        return n
    }
    return inc, get
}

func test_makeIncrementer() {
    inc_a, get_a := makeIncrementer()
    inc_b, get_b := makeIncrementer()
    for i := 1; i <= 5; i++ {
        inc_a() // a is incremented once
        inc_b() // b is incremented twice
        inc_b()
    }
    fmt.Printf("get_a(): %v\n", get_a())
    fmt.Printf("get_b(): %v\n", get_b())
}


//
// mapstr makes a new slice of strings by applying a string function to every
// element of a slice of some other strings.
//
func mapstr(lst []string, f func(string) string) []string {
    result := make([]string, len(lst))
    for i, s := range lst {
        result[i] = f(s)
    }
    return result
}

func test_mapstr() {
    words := []string{"one", "two", "three"}
    fmt.Println(words)

    // strings.Title returns a new string with the first letter of each word
    // capitalized
    capWords := mapstr(words, strings.Title)
    fmt.Println(capWords)
}
