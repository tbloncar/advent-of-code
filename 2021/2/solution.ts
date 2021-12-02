type Instruction = { direction: string, units: number };

function parseInstructions(input: string): Array<Instruction> {
    return input.split("\n").map((line: string): Instruction => {
        const [direction, units] = line.split(" ");
        return { direction, units: parseInt(units, 10) };
    });
}

function computeEndPositions(instructions: Array<Instruction>): Array<number> {
    let [horizontalPosition, depth] = [0, 0];

    instructions.forEach((instruction: Instruction) => {
        switch(instruction.direction) {
            case 'forward':
                horizontalPosition += instruction.units;
                break;
            case 'down':
                depth += instruction.units;
                break;
            case 'up':
                depth -= instruction.units;
                break;
        }
    });

    return [horizontalPosition, depth];
}

function computeEndPositionsWithAim(instructions: Array<Instruction>): Array<number> {
    let [horizontalPosition, depth, aim] = [0, 0, 0];

    instructions.forEach((instruction: Instruction) => {
        switch(instruction.direction) {
            case 'forward':
                horizontalPosition += instruction.units;
                depth += aim * instruction.units;
                break;
            case 'down':
                aim += instruction.units;
                break;
            case 'up':
                aim -= instruction.units;
                break;
        }
    });

    return [horizontalPosition, depth];
}

function solution(input: string) {
  const instructions = parseInstructions(input.trim());
  console.log(`Instructions: ${instructions.length}`);

  const [endHorizontalPosition, endDepth] = computeEndPositions(instructions);
  console.log(`End horizontal position: ${endHorizontalPosition}`)
  console.log(`End depth: ${endDepth}`)

  console.log(`Part 1 answer: ${endHorizontalPosition * endDepth}`)

  const [endHorizontalPosition2, endDepth2] = computeEndPositionsWithAim(instructions);
  console.log(`End horizontal position: ${endHorizontalPosition2}`)
  console.log(`End depth: ${endDepth2}`)

  console.log(`Part 2 answer: ${endHorizontalPosition2 * endDepth2}`)
}

const fs = require('fs');

fs.readFile('./input.txt', 'utf8' , (err: Error, data: string) => {
  if (err) {
    console.error(err);
    return;
  }
  solution(data);
})
