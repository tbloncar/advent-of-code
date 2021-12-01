import java.io.File
import java.io.InputStream

val inputStream: InputStream = File("input.txt").inputStream()
val inputString = inputStream.bufferedReader().use { it.readText() }

fun parseDepths(depths: String): List<Int> {
  return depths.split("\n").map { it.toInt() }
}

// Part 1
fun countDepthIncreases(depths: List<Int>): Int {
  return depths.foldIndexed(0, { index, acc, depth -> acc + (if (index != 0 && depth > depths[index - 1]) 1 else 0) });
}

// Part 2
fun countWindowDepthIncreases(depths: List<Int>): Int {
  val windowSize: Int = 3;
  var previousWindowDepth: Int = 0;

  return depths.foldIndexed(0, fun(index, acc, depth): Int {
    var count = acc;

    if (index < windowSize) {
      previousWindowDepth += depth;
      return count;
    }

    var currentWindowDepth: Int = 0;
    for(i in 0..(windowSize - 1)) {
      currentWindowDepth += depths[index - i];
    }

    if (currentWindowDepth > previousWindowDepth) {
      count += 1;
    }

    // Set the previous window depth to the currentWindowDepth so that we don't have to
    // compute it on every loop
    previousWindowDepth = currentWindowDepth;
    
    return count;
  })
}


val depths = parseDepths(inputString)

println("Depths: ${depths.size}");
println("Part 1 increases: ${countDepthIncreases(depths)}")
println("Part 2 increases: ${countWindowDepthIncreases(depths)}")