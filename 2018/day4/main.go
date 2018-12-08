package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

// Part 1
func part1(claims []string) {
}

// Part 2
func part2(claims []string) {
}

func main() {
	fmt.Println("Day 4")

	dat, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	lines := strings.TrimSpace(string(dat))
	claims := strings.Split(lines, "\n")

	a1 := part1(claims)
	a2 := part2(claims)

	fmt.Println("P1:", a1)
	fmt.Println("P2:", a2)
}
