package main

import (
	"fmt"
	"io/ioutil"
	"math"
	"strconv"
	"strings"
)

// Part 1
func findLargestFiniteArea(coords []string) int {
	sc := parseCoords(coords)
	w, h := getGridDimensions(sc)

	// Ensure that the grid is padded by 1 on each side to simulate infinity
	w += 2
	h += 2

	// Assume (naively) that all coordinates will consume finite area
	finite := map[int][]int{}
	for i, c := range sc {
		finite[i] = c
	}

	acc := map[int]int{}
	for i, _ := range sc {
		acc[i] = 0
	}

	// For each square in the grid, find the provided coordinate that is closest
	for i := 0; i < w; i++ {
		for j := 0; j < h; j++ {
			ci, err := findClosestCoord(i, j, sc)
			if err != nil {
				continue
			}

			acc[ci] += 1

			if i == 0 || j == 0 || i == w-1 || j == h-1 {
				delete(finite, ci)
			}
		}
	}

	maxarea := 0
	for i, _ := range finite {
		if acc[i] > maxarea {
			maxarea = acc[i]
		}
	}

	return maxarea
}

func parseCoords(coords []string) [][]int {
	ic := [][]int{}

	for _, c := range coords {
		point := strings.Split(c, ", ")
		x, _ := strconv.Atoi(point[0])
		y, _ := strconv.Atoi(point[1])
		ic = append(ic, []int{x, y})
	}

	return ic
}

func getGridDimensions(coords [][]int) (w, h int) {
	xmax, ymax := 0, 0

	for _, c := range coords {
		if c[0] > xmax {
			xmax = c[0]
		}

		if c[1] > ymax {
			ymax = c[1]
		}
	}

	return xmax, ymax
}

// Use Manhattan distance to find coordinate closest to point x,y
func findClosestCoord(x, y int, coords [][]int) (int, error) {
	closest := 0
	mindistance := math.Inf(1)
	equidistant := false

	for i, c := range coords {
		distance := calcManhattanDistance(x, y, c)

		if distance == mindistance {
			equidistant = true
		}

		if distance < mindistance {
			mindistance = distance
			closest = i
			equidistant = false
		}
	}

	if equidistant {
		return 0, fmt.Errorf("Two coordinates are equidistant")
	}

	return closest, nil
}

func calcManhattanDistance(x, y int, c []int) float64 {
	xdiff := float64(x - c[0])
	ydiff := float64(y - c[1])

	return math.Abs(xdiff) + math.Abs(ydiff)
}

// Part 2
func findSizeOfSatisfyingRegion(coords []string, budget int) int {
	sc := parseCoords(coords)
	w, h := getGridDimensions(sc)
	size := 0

	for i := 1; i <= w; i++ {
		for j := 1; j <= h; j++ {
			distance := 0

			for _, c := range sc {
				distance += int(calcManhattanDistance(i, j, c))
				if distance > budget {
					break
				}
			}

			if distance < budget {
				size += 1
			}
		}
	}

	return size
}

func main() {
	fmt.Println("Day 6")

	dat, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	lines := strings.TrimSpace(string(dat))
	coords := strings.Split(lines, "\n")

	a1 := findLargestFiniteArea(coords)
	a2 := findSizeOfSatisfyingRegion(coords, 10000)

	fmt.Println("P1:", a1)
	fmt.Println("P2:", a2)
}
