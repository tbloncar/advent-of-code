package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

// Part 1
func findOverlap(claims []string) int {
	overlapping := map[string]bool{}
	fabric := map[string]bool{}

	for _, claim := range claims {
		x, y, w, h := extractCoordinatesAndDimensions(claim)

		for i := 0; i < w; i++ {
			for j := 0; j < h; j++ {
				key := keyForCoordinate(x+i, y+j)

				if _, ok := fabric[key]; ok {
					overlapping[key] = true
				}

				fabric[key] = true
			}
		}
	}

	return len(overlapping)
}

func extractCoordinatesAndDimensions(claim string) (x, y, w, h int) {
	a := strings.Split(claim, "@ ")[1]
	b := strings.Split(a, ": ")

	coords, dims := strings.Split(b[0], ","), strings.Split(b[1], "x")

	x, _ = strconv.Atoi(coords[0])
	y, _ = strconv.Atoi(coords[1])
	w, _ = strconv.Atoi(dims[0])
	h, _ = strconv.Atoi(dims[1])

	return
}

// Part 2
func findNonOverlappingClaim(claims []string) string {
	fabric := map[string][]string{}

	for _, claim := range claims {
		x, y, w, h := extractCoordinatesAndDimensions(claim)

		for i := 0; i < w; i++ {
			for j := 0; j < h; j++ {
				key := keyForCoordinate(x+i, y+j)

				if _, ok := fabric[key]; ok {
					fabric[key] = append(fabric[key], claim)
				} else {
					fabric[key] = []string{claim}
				}
			}
		}
	}

OverlapCheck:
	for _, claim := range claims {
		x, y, w, h := extractCoordinatesAndDimensions(claim)

		for i := 0; i < w; i++ {
			for j := 0; j < h; j++ {
				key := keyForCoordinate(x+i, y+j)
				if len(fabric[key]) > 1 {
					continue OverlapCheck
				}
			}
		}

		return claim
	}

	return "No claim found"
}

func keyForCoordinate(x, y int) string {
	return fmt.Sprintf("%dx%d", x, y)
}

func main() {
	fmt.Println("Day 3")

	dat, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	lines := strings.TrimSpace(string(dat))
	claims := strings.Split(lines, "\n")

	a1 := findOverlap(claims)
	a2 := findNonOverlappingClaim(claims)

	fmt.Println("P1:", a1)
	fmt.Println("P2:", a2)
}
