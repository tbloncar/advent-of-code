import java.io.File
import java.io.InputStream

val inputStream: InputStream = File("input.txt").inputStream()
val inputString = inputStream.bufferedReader().use { it.readText() }

class Instruction(val direction: String, val units: Int) {}

fun parseInstructions(input: String): List<Instruction> {
    return input.split("\n").map(fun(line): Instruction {
        val (direction, units) = line.split(" ");
        return Instruction(direction, units.toInt());
    });
}

fun computeEndPositions(instructions: List<Instruction>): List<Int> {
    var (horizontalPosition, depth) = listOf(0, 0);

    for (instruction in instructions) {
        when (instruction.direction) {
            "forward" -> horizontalPosition += instruction.units
            "down" -> depth += instruction.units
            "up" -> depth -= instruction.units
        }
    }

    return listOf(horizontalPosition, depth);
}

fun computeEndPositionsWithAim(instructions: List<Instruction>): List<Int> {
    var (horizontalPosition, depth, aim) = listOf(0, 0, 0);

    for (instruction in instructions) {
        when (instruction.direction) {
            "forward" -> {
                horizontalPosition += instruction.units;
                depth += aim * instruction.units;
            }
            "down" -> {
                aim += instruction.units;
            }
            "up" -> {
                aim -= instruction.units;
            }
        }
    }

    return listOf(horizontalPosition, depth);
}

val instructions = parseInstructions(inputString.trim());
println("Instructions: ${instructions.size}");

val (endHorizontalPosition, endDepth) = computeEndPositions(instructions);
println("End horizontal position: ${endHorizontalPosition}")
println("End depth: ${endDepth}")

println("Part 1 answer: ${endHorizontalPosition * endDepth}")

val (endHorizontalPosition2, endDepth2) = computeEndPositionsWithAim(instructions);
println("End horizontal position: ${endHorizontalPosition2}")
println("End depth: ${endDepth2}")

println("Part 2 answer: ${endHorizontalPosition2 * endDepth2}")