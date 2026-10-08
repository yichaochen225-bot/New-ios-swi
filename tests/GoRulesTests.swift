import Foundation

var assertions = 0
func check(_ value: @autoclosure () -> Bool, _ message: String) {
    assertions += 1
    if !value() { fputs("FAILED: \(message)\n", stderr); exit(1) }
}
func point(_ row: Int, _ col: Int) -> GoPoint { GoPoint(row: row, col: col) }
func move(_ game: inout GoGame, _ row: Int, _ col: Int) {
    check(game.play(at: point(row,col)) == .played, "move at \(row),\(col) should succeed")
}
do {
    var g = GoGame(size: 9)
    check(g.size == 9 && g.toMove == .black, "game setup")
    move(&g, 4, 4)
    check(g.toMove == .white && g.stone(at: point(4,4)) == .black, "alternate colors")
    check(g.play(at: point(4,4)) == .invalid("这里已有棋子"), "occupied point blocked")
    check(g.moveCount == 1, "invalid move cannot change counter")
    check(g.undo(), "undo allowed")
    check(g.moveCount == 0 && g.board.allSatisfy { $0 == nil }, "undo restores board")
}
do {
    var g = GoGame()
    // Black encircles one white stone in the corner.
    move(&g, 0, 1) // black
    move(&g, 0, 0) // white
    move(&g, 1, 0) // black, captures white
    check(g.stone(at: point(0,0)) == nil && g.capturesBlack == 1, "capture corner stone")
    check(g.undo(), "undo capture")
    check(g.capturesBlack == 0 && g.stone(at: point(0,0)) == .white, "undo capture state")
}
do {
    var g = GoGame()
    g.board[g.index(point(0,1))] = .black
    g.board[g.index(point(1,0))] = .black
    g.board[g.index(point(1,2))] = .black
    g.board[g.index(point(2,1))] = .black
    g.toMove = .white
    check(g.play(at: point(1,1)) == .invalid("禁入点：不能自杀落子"), "suicide forbidden")
    check(g.board[g.index(point(1,1))] == nil && g.toMove == .white, "invalid suicide has no effect")
}
do {
    var g = GoGame()
    for p in [point(0,1),point(1,0),point(2,1)] { g.board[g.index(p)] = .black }
    for p in [point(1,1),point(0,2),point(2,2),point(1,3)] { g.board[g.index(p)] = .white }
    g.toMove = .black
    let original = g.board
    move(&g,1,2)
    check(g.stone(at: point(1,1)) == nil, "ko capture")
    check(g.play(at: point(1,1)) == .invalid("劫争：不能立即提回"), "simple ko rule")
    check(g.board != original, "ko board remains after invalid recapture")
}
do {
    var g = GoGame()
    g.pass()
    check(g.phase == .playing && g.passes == 1 && g.toMove == .white, "first pass")
    g.pass()
    check(g.phase == .reviewing && g.passes == 2, "two passes open scoring")
    g.resume()
    check(g.phase == .playing && g.passes == 0, "resume play")
    g.pass()
    g.pass()
    g.confirmScore()
    check(g.phase == .finished, "confirm scoring")
    check(g.score().white == 6.5 && g.score().black == 0.0, "komi on empty board")
    check(g.undo() && g.phase == .playing, "undo after finishing returns to previous turn")
}
do {
    var g = GoGame(size: 9)
    for r in 0..<9 {
        for c in 0..<9 { g.board[g.index(point(r,c))] = .black }
    }
    g.board[g.index(point(4,4))] = nil
    let s = g.score()
    check(s.black == 81 && s.white == 6.5, "area scoring counts enclosed territory")
    g.phase = .reviewing
    g.toggleDeadGroup(at: point(0,0))
    check(g.markedDead.count == 80, "dead group marking")
    let dead = g.score()
    check(dead.black == 0 && dead.white == 6.5, "unowned empty territory does not score")
    g.toggleDeadGroup(at: point(0,0))
    check(g.markedDead.isEmpty, "restore dead group")
}
do {
    var g = GoGame(size: 13)
    g.resign()
    check(g.phase == .resigned && g.resignationWinner == .white, "resignation awards opposing player")
    check(g.undo() && g.phase == .playing, "undo resignation")
    let serialized = try! JSONEncoder().encode(g)
    let decoded = try! JSONDecoder().decode(GoGame.self, from: serialized)
    check(decoded.size == 13 && decoded.phase == .playing, "Codable round trip")
    check(GoGame(size: 19).board.count == 361, "19x19 board")
}
print("Go engine: \(assertions) assertions passed.")
