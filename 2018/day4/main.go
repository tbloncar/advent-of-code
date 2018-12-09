package main

import (
	"fmt"
	"io/ioutil"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

const (
	actionBegins = "begins"
	actionSleeps = "sleeps"
	actionAwakes = "awakes"
)

// Part 1
func checksum(entries []string) int {
	guard, maxSleep, maxMinute := "", 0, 0

	for g, schedule := range buildGuardSleepSchedule(entries) {
		totalSleep, targetMinuteCount, targetMinute := 0, 0, 0

		for min, count := range schedule {
			totalSleep += count

			if count > targetMinuteCount {
				targetMinute, targetMinuteCount = min, count
			}
		}

		if totalSleep > maxSleep {
			guard, maxSleep, maxMinute = g, totalSleep, targetMinute
		}
	}

	return guardNumber(guard) * maxMinute
}

func getTimeActionGuard(entry string) (time, action, guard string) {
	a := strings.Split(entry, "] ")
	b := strings.Split(a[1], " ")
	s := regexp.MustCompile("\\d{2}:").Split(a[0], -1)
	time = s[1]

	if b[0] == "Guard" {
		action = actionBegins
		guard = b[1]
	} else if b[0] == "falls" {
		action = actionSleeps
	} else {
		action = actionAwakes
	}

	return time, action, guard
}

func buildGuardSleepSchedule(entries []string) map[string]map[int]int {
	sort.Strings(entries)

	asleep := map[string]map[int]int{}

	var currentGuard string
	var minSleep int
	var minWakes int

	for _, entry := range entries {
		time, action, guard := getTimeActionGuard(entry)

		if action == actionBegins {
			currentGuard = guard
		} else if action == actionSleeps {
			if _, ok := asleep[currentGuard]; !ok {
				asleep[currentGuard] = map[int]int{}
			}

			minSleep, _ = strconv.Atoi(time)
		} else if action == actionAwakes {
			minWakes, _ = strconv.Atoi(time)

			for minSleep < minWakes {
				asleep[currentGuard][minSleep] += 1
				minSleep += 1
			}
		}
	}

	return asleep
}

func guardNumber(guard string) (n int) {
	n, _ = strconv.Atoi(strings.Split(guard, "#")[1])
	return
}

// Part 2
func checksum2(entries []string) int {
	guard, maxCount, maxMinute := "", 0, 0

	for g, schedule := range buildGuardSleepSchedule(entries) {
		for min, count := range schedule {
			if count > maxCount {
				maxMinute, maxCount, guard = min, count, g
			}
		}
	}

	return guardNumber(guard) * maxMinute
}

func main() {
	fmt.Println("Day 4")

	dat, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	lines := strings.TrimSpace(string(dat))
	entries := strings.Split(lines, "\n")

	a1 := checksum(entries)
	a2 := checksum2(entries)

	fmt.Println("P1:", a1)
	fmt.Println("P2:", a2)
}
