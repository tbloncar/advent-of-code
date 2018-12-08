package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

// Part 1
func trackFrequency(frequencies []string) (f int, err error) {
	for _, frequency := range frequencies {
		i, err := strconv.Atoi(frequency)
		if err != nil {
			return 0, err
		}

		f += i
	}

	return f, nil
}

// Part 2
func findFrequencyReachedTwice(frequencies []string) (f int, err error) {
	reached := map[int]bool{0: true}

	for true {
		for _, frequency := range frequencies {
			i, err := strconv.Atoi(frequency)
			if err != nil {
				return 0, err
			}

			f += i
			if _, ok := reached[f]; ok {
				return f, nil
			}

			reached[f] = true
		}
	}

	return 0, fmt.Errorf("Impossible")
}

func main() {
	fmt.Println("Day 1")

	dat, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	lines := strings.TrimSpace(string(dat))
	freqs := strings.Split(lines, "\n")

	f1, err := trackFrequency(freqs)
	if err != nil {
		panic(err)
	}

	f2, err := findFrequencyReachedTwice(freqs)
	if err != nil {
		panic(err)
	}

	fmt.Println("P1:", f1)
	fmt.Println("P2:", f2)
}
