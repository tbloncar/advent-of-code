import java.io.File
import java.io.InputStream

val inputStream: InputStream = File("input.txt").inputStream()
val inputString = inputStream.bufferedReader().use { it.readText() }

class Position(val number: Int, var marked: Boolean = false) {}

class Board {
    var id: Int
    var positions: List<List<Position>>

    constructor(id: Int, board: String) {
        this.id = id;
        this.positions = board.split("\n").map(fun(line): List<Position> {
            return line.trim().split(Regex("\\s+")).map { Position(it.toInt()) };
        })
    }

    fun mark(number: Int) {
        for (i in this.positions.indices) {
            for (j in this.positions.indices) {
                if (this.positions[i][j].number == number) {
                    this.positions[i][j].marked = true;
                }
            }
        }
    }

    fun hasBingo(): Boolean {
        // Check rows for bingo
        for (row in this.positions) {
            var hasBingo: Boolean = true
            for (position in row) {
                if (!position.marked) {
                    hasBingo = false;
                    break;
                }
            }
            if (hasBingo) {
                return true;
            }
        }

        // Check columns for bingo
        for (i in this.positions.indices) {
            var hasBingo: Boolean = true
            for (j in this.positions.indices) {
                if (!positions[j][i].marked) {
                    hasBingo = false;
                    break;
                }
            }
            if (hasBingo) {
                return true;
            }
        }

        return false;
    }

    fun sumUnmarkedPositions(): Int {
        var sum: Int = 0;
        for (row in this.positions) {
            for (position in row) {
                if (!position.marked) {
                    sum += position.number
                }
            }
        }
        return sum;
    }
}

class Game(var boards: List<Board>, val numbers: List<Int>) {}

fun parseBingoGame(input: String): Game {
    val numbersAndBoards: List<String> = input.split("\n\n");
    val numbers: List<Int> = numbersAndBoards[0].split(",").map { it.toInt() }
    val boards: List<Board> = numbersAndBoards.subList(1, numbersAndBoards.size).mapIndexed { index, board -> Board(index, board) };

    return Game(boards, numbers);
}

val game = parseBingoGame(inputString.trim());

println("Game with ${game.boards.size} boards and ${game.numbers.size} numbers");

var winningBoard: Board? = null;
var winningNumber: Int = 1;


// Part 1
for (number in game.numbers) {
    for (board in game.boards) {
        board.mark(number)

        if (board.hasBingo()) {
            winningBoard = board;
            winningNumber = number;
            break;
        }
    }
    if (winningBoard != null) {
        break;
    }
}

if (winningBoard != null) {
    println("Winning board: ${winningBoard?.id}");
    println("Winning number: ${winningNumber}");

    var score: Int? = winningBoard?.let { it.sumUnmarkedPositions() * winningNumber };
    println("Score: ${score}");
} else {
    println("No winning board");
}

// Part 2
val game2 = parseBingoGame(inputString.trim());
var boards: MutableList<Board> = game2.boards.toMutableList();

var lastBoard: Board? = null;
var lastNumber: Int = 1;

for (number in game.numbers) {
    var boardsToRemove: MutableList<Board> = mutableListOf<Board>();
    for (board in boards) {
        board.mark(number)

        if (board.hasBingo()) {
            boardsToRemove.add(board);
        }
    }

    for (board in boardsToRemove) {
        boards.remove(board);
    }

    if (boards.size == 0) {
        lastBoard = boardsToRemove[boardsToRemove.size - 1];
        lastNumber = number;
        break;
    }
}

if (lastBoard != null) {
    println("Last board: ${lastBoard?.id}");
    println("Last number: ${lastNumber}");

    var score2: Int? = lastBoard?.let { it.sumUnmarkedPositions() * lastNumber };
    println("Score: ${score2}");
} else {
    println("No last board")
}