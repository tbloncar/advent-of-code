package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

// Part 1
func computeChecksum(boxids []string) int {
	exact2Count, exact3Count := 0, 0

	for _, id := range boxids {
		found2, found3 := false, false
		charcount := map[string]int{}

		for _, char := range strings.Split(id, "") {
			if _, ok := charcount[char]; ok {
				charcount[char] += 1
			} else {
				charcount[char] = 1
			}
		}

		for _, count := range charcount {
			if !found2 && count == 2 {
				exact2Count += 1
				found2 = true
			}

			if !found3 && count == 3 {
				exact3Count += 1
				found3 = true
			}
		}
	}

	return exact2Count * exact3Count
}

// Part 2
func findCommonLetters(boxids []string) string {
	chars := len(boxids[0])

	for i := 0; i < chars; i++ {
		letters := map[string]bool{}

		for _, id := range boxids {
			idp := ""
			for j, c := range strings.Split(id, "") {
				if j != i {
					idp += c
				}
			}

			if _, ok := letters[idp]; ok {
				return idp
			}

			letters[idp] = true
		}
	}

	return ""
}

func main() {
	fmt.Println("Day 2")

	dat, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	lines := strings.TrimSpace(string(dat))
	boxids := strings.Split(lines, "\n")

	a1 := computeChecksum(boxids)
	a2 := findCommonLetters(boxids)
	fmt.Println("P1:", a1)
	fmt.Println("P2:", a2)
}
