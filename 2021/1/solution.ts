function parseDepths(depths: string): number[] {
  return depths.split("\n").map(depth => parseInt(depth, 10));
}

// Part 1
function countDepthIncreases(depths: number[]): number {
  return depths.reduce((acc: number, depth: number, index: number) => {
    return acc + (index !== 0 && depth > depths[index - 1] ? 1 : 0);
  }, 0)
}

// Part 2
function countWindowDepthIncreases(depths: number[]): number {
  const windowSize: number = 3;
  let previousWindowDepth: number = 0;

  return depths.reduce((acc: number, depth: number, index: number) => {
    if (index < windowSize) {
      previousWindowDepth += depth;
      return acc;
    }

    let currentWindowDepth: number = 0;
    for(let i = 0; i < windowSize; i++) {
      currentWindowDepth += depths[index - i];
    }

    if (currentWindowDepth > previousWindowDepth) {
      acc += 1;
    }

    // Set the previous window depth to the currentWindowDepth so that we don't have to
    // compute it on every loop
    previousWindowDepth = currentWindowDepth;
    
    return acc;
  }, 0)
}

function solution(input: string) {
  // Parse depths
  const depths = parseDepths(input);
  const increases = countDepthIncreases(depths);

  console.log(`Depths: ${depths.length}`);

  console.log(`Part 1 increases: ${countDepthIncreases(depths)}`)
  console.log(`Part 2 increases: ${countWindowDepthIncreases(depths)}`)
}

const fs = require('fs');

fs.readFile('./input.txt', 'utf8' , (err: Error, data: string) => {
  if (err) {
    console.error(err);
    return;
  }
  solution(data);
})

