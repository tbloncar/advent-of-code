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
		coords, dims := extractCoordinatesAndDimensions(claim)

		x, _ := strconv.Atoi(coords[0])
		y, _ := strconv.Atoi(coords[1])
		w, _ := strconv.Atoi(dims[0])
		h, _ := strconv.Atoi(dims[1])

		for i := 0; i < w; i++ {
			for j := 0; j < h; j++ {
				xc := x + i
				yc := y + j

				key := fmt.Sprintf("%dx%d", xc, yc)

				if _, ok := fabric[key]; ok {
					overlapping[key] = true
				}

				fabric[key] = true
			}
		}
	}

	return len(overlapping)
}

func extractCoordinatesAndDimensions(claim string) ([]string, []string) {
	a := strings.Split(claim, "@ ")[1]
	b := strings.Split(a, ": ")

	return strings.Split(b[0], ","), strings.Split(b[1], "x")
}

// Part 2
func findNonOverlappingClaim(claims []string) string {
	fabric := map[string][]string{}

	for _, claim := range claims {
		coords, dims := extractCoordinatesAndDimensions(claim)

		x, _ := strconv.Atoi(coords[0])
		y, _ := strconv.Atoi(coords[1])
		w, _ := strconv.Atoi(dims[0])
		h, _ := strconv.Atoi(dims[1])

		for i := 0; i < w; i++ {
			for j := 0; j < h; j++ {
				xc := x + i
				yc := y + j

				key := fmt.Sprintf("%dx%d", xc, yc)

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
		coords, dims := extractCoordinatesAndDimensions(claim)

		x, _ := strconv.Atoi(coords[0])
		y, _ := strconv.Atoi(coords[1])
		w, _ := strconv.Atoi(dims[0])
		h, _ := strconv.Atoi(dims[1])

		for i := 0; i < w; i++ {
			for j := 0; j < h; j++ {
				xc := x + i
				yc := y + j

				key := fmt.Sprintf("%dx%d", xc, yc)

				if len(fabric[key]) > 1 {
					continue OverlapCheck
				}
			}
		}

		return strings.Split(claim, " ")[0]
	}

	return ""
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
