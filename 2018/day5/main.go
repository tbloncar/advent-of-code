package main

import (
	"fmt"
	"io/ioutil"
	"math"
	"strings"
)

// Part 1
func chainReaction(polymer string) string {
	units := strings.Split(polymer, "")
	reaction := false

	for i, unit := range units {
		if i != len(units)-1 {
			if hasReaction(unit, units[i+1]) {
				units[i], units[i+1] = "", ""
				reaction = true
			}
		}
	}

	new := strings.Join(units, "")
	if reaction {
		return chainReaction(new)
	}

	return new
}

func hasReaction(u1, u2 string) bool {
	u1u := strings.ToUpper(u1)
	u2u := strings.ToUpper(u2)

	if u1u != u2u {
		return false
	}

	u1l := strings.ToLower(u1)
	u2l := strings.ToLower(u2)

	return (u1l == u1 && u2u == u2) || (u1u == u1 && u2l == u2)
}

// Part 2
func removeUnitTypeToFindShortest(polymer string) string {
	units := strings.Split(polymer, "")
	types := map[string]string{}

	// Find distinct unit types
	for _, unit := range units {
		types[strings.ToLower(unit)] = strings.ToUpper(unit)
	}

	shortestP := ""
	shortestL := math.Inf(1)

	for tl, tu := range types {
		p1 := strings.Replace(polymer, tl, "", -1)
		p2 := strings.Replace(p1, tu, "", -1)

		reactedP := chainReaction(p2)
		reactedL := float64(len(reactedP))

		if reactedL < shortestL {
			shortestP = reactedP
			shortestL = float64(reactedL)
		}
	}

	return shortestP
}

func main() {
	fmt.Println("Day 5")

	dat, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	polymer := strings.TrimSpace(string(dat))

	a1 := len(chainReaction(polymer))
	a2 := len(removeUnitTypeToFindShortest(polymer))

	fmt.Println("P1:", a1)
	fmt.Println("P2:", a2)
}
