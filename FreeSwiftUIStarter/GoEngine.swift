import Foundation

enum GoStone: Int, Codable, Equatable, Hashable {
    case black = 1
    case white = 2

    var opponent: GoStone { self == .black ? .white : .black }
    var name: String { self == .black ? "黑方" : "白方" }
}

struct GoPoint: Hashable, Codable {
    let row: Int
    let col: Int
}

enum GoPhase: String, Codable {
    case playing, reviewing, finished, resigned
}

struct GoScore: Equatable {
    let black: Double
    let white: Double
    var winner: GoStone { black > white ? .black : .white }
    var difference: Double { abs(black - white) }
}

enum GoMoveResult: Equatable {
    case played
    case invalid(String)
}

struct GoGame: Codable {
    struct Snapshot: Codable {
        var board: [GoStone?]
        var toMove: GoStone
        var capturesBlack: Int
        var capturesWhite: Int
        var passes: Int
        var moveCount: Int
        var lastMove: GoPoint?
        var koForbiddenBoard: [GoStone?]?
        var phase: GoPhase
        var resignationWinner: GoStone?
        var lastAction: String
    }

    let size: Int
    var board: [GoStone?]
    var toMove: GoStone = .black
    var capturesBlack = 0
    var capturesWhite = 0
    var passes = 0
    var moveCount = 0
    var lastMove: GoPoint?
    var koForbiddenBoard: [GoStone?]?
    var phase: GoPhase = .playing
    var resignationWinner: GoStone?
    var lastAction = "黑方先行，点击交叉点落子"
    var markedDead: Set<Int> = []
    var history: [Snapshot] = []
    let komi: Double = 6.5

    init(size: Int = 9) {
        self.size = [9, 13, 19].contains(size) ? size : 9
        self.board = Array(repeating: nil, count: self.size * self.size)
    }

    func index(_ p: GoPoint) -> Int { p.row * size + p.col }

    func valid(_ p: GoPoint) -> Bool {
        (0..<size).contains(p.row) && (0..<size).contains(p.col)
    }

    func stone(at p: GoPoint) -> GoStone? {
        guard valid(p) else { return nil }
        return board[index(p)]
    }

    func adjacent(_ p: GoPoint) -> [GoPoint] {
        [
            GoPoint(row: p.row - 1, col: p.col),
            GoPoint(row: p.row + 1, col: p.col),
            GoPoint(row: p.row, col: p.col - 1),
            GoPoint(row: p.row, col: p.col + 1)
        ].filter(valid)
    }

    private func group(at start: GoPoint, in state: [GoStone?]) -> (stones: Set<Int>, liberties: Set<Int>) {
        let color = state[index(start)]
        guard color != nil else { return ([], []) }
        var visited: Set<Int> = [index(start)]
        var liberties: Set<Int> = []
        var stack = [start]
        while let current = stack.popLast() {
            for next in adjacent(current) {
                let i = index(next)
                if state[i] == nil {
                    liberties.insert(i)
                } else if state[i] == color && visited.insert(i).inserted {
                    stack.append(next)
                }
            }
        }
        return (visited, liberties)
    }

    private func snapshot() -> Snapshot {
        Snapshot(board: board, toMove: toMove,
                 capturesBlack: capturesBlack, capturesWhite: capturesWhite,
                 passes: passes, moveCount: moveCount, lastMove: lastMove,
                 koForbiddenBoard: koForbiddenBoard, phase: phase,
                 resignationWinner: resignationWinner, lastAction: lastAction)
    }

    mutating func play(at point: GoPoint) -> GoMoveResult {
        guard phase == .playing else { return .invalid("当前不能落子") }
        guard valid(point) else { return .invalid("请点击棋盘交叉点") }
        guard stone(at: point) == nil else { return .invalid("这里已有棋子") }

        let before = board
        var next = board
        next[index(point)] = toMove
        var taken: Set<Int> = []

        for neighbor in adjacent(point) where next[index(neighbor)] == toMove.opponent {
            let enemy = group(at: neighbor, in: next)
            if enemy.liberties.isEmpty {
                taken.formUnion(enemy.stones)
                for position in enemy.stones { next[position] = nil }
            }
        }

        if group(at: point, in: next).liberties.isEmpty {
            return .invalid("禁入点：不能自杀落子")
        }
        if next == koForbiddenBoard {
            return .invalid("劫争：不能立即提回")
        }

        history.append(snapshot())
        board = next
        if toMove == .black { capturesBlack += taken.count }
        else { capturesWhite += taken.count }
        moveCount += 1
        lastMove = point
        lastAction = "\(toMove.name)落子 · \(point.col + 1) 列 \(point.row + 1) 行" +
            (taken.isEmpty ? "" : " · 提子 \(taken.count) 枚")
        koForbiddenBoard = before
        passes = 0
        toMove = toMove.opponent
        return .played
    }

    mutating func pass() {
        guard phase == .playing else { return }
        history.append(snapshot())
        moveCount += 1
        passes += 1
        lastMove = nil
        koForbiddenBoard = nil
        lastAction = "\(toMove.name)虚着"
        toMove = toMove.opponent
        if passes >= 2 {
            phase = .reviewing
            lastAction = "双方连续虚着：请标记死子后计分"
        }
    }

    mutating func resign() {
        guard phase == .playing else { return }
        history.append(snapshot())
        resignationWinner = toMove.opponent
        phase = .resigned
        lastAction = "\(toMove.name)认输 · \(toMove.opponent.name)获胜"
    }

    mutating func toggleDeadGroup(at point: GoPoint) {
        guard phase == .reviewing, let color = stone(at: point) else { return }
        let groupStones = group(at: point, in: board).stones
        let allMarked = groupStones.allSatisfy { markedDead.contains($0) }
        for i in groupStones {
            if allMarked { markedDead.remove(i) }
            else { markedDead.insert(i) }
        }
        lastAction = "\(color.name)棋块\(allMarked ? "恢复" : "标记为死子") · \(groupStones.count) 枚"
    }

    mutating func resume() {
        guard phase == .reviewing else { return }
        markedDead.removeAll()
        passes = 0
        koForbiddenBoard = nil
        phase = .playing
        lastAction = "继续对局 · \(toMove.name)落子"
    }

    mutating func confirmScore() {
        guard phase == .reviewing else { return }
        phase = .finished
        let result = score()
        lastAction = "\(result.winner.name)胜 \(String(format: "%.1f", result.difference)) 目（数子法）"
    }

    mutating func undo() -> Bool {
        guard let last = history.popLast() else { return false }
        board = last.board
        toMove = last.toMove
        capturesBlack = last.capturesBlack
        capturesWhite = last.capturesWhite
        passes = last.passes
        moveCount = last.moveCount
        lastMove = last.lastMove
        koForbiddenBoard = last.koForbiddenBoard
        phase = last.phase
        resignationWinner = last.resignationWinner
        lastAction = "已悔棋 · \(toMove.name)落子"
        markedDead.removeAll()
        return true
    }

    func score() -> GoScore {
        // Chinese-style area scoring: stones on board + fully enclosed empty points.
        // Marked dead groups are considered removed, not counted as living stones.
        var scoringBoard = board
        for i in markedDead { scoringBoard[i] = nil }
        var black = Double(scoringBoard.compactMap { $0 }.filter { $0 == .black }.count)
        var white = Double(scoringBoard.compactMap { $0 }.filter { $0 == .white }.count) + komi
        var seen: Set<Int> = []
        for i in scoringBoard.indices where scoringBoard[i] == nil && !seen.contains(i) {
            var frontier = [i]
            seen.insert(i)
            var territory = 0
            var boundary: Set<GoStone> = []
            while let current = frontier.popLast() {
                territory += 1
                let p = GoPoint(row: current / size, col: current % size)
                for q in adjacent(p) {
                    let j = index(q)
                    if let stone = scoringBoard[j] {
                        boundary.insert(stone)
                    } else if seen.insert(j).inserted {
                        frontier.append(j)
                    }
                }
            }
            if boundary == [.black] { black += Double(territory) }
            if boundary == [.white] { white += Double(territory) }
        }
        return GoScore(black: black, white: white)
    }
}
