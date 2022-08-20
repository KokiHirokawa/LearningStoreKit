public struct Piece: Equatable {
    let position: Position
}

extension Piece {
    func move(direction: Direction, on board: Board) -> Piece {
        switch direction {
        case .up:
            return moveUp(on: board)
        case .left:
            return moveLeft(on: board)
        case .down:
            return moveDown(on: board)
        case .right:
            return moveRight(on: board)
        }
    }
    
    func isReachedGoal(on board: Board) -> Bool {
        let grid = board[position.y][position.x]
        return grid.isGoal
    }
}

extension Piece {
    private func moveUp(on board: Board) -> Piece {
        let canMoveUp: (Int) -> Bool = { y in
            let grid = board[y][position.x]
            return y > 0 && grid.canMoveUp
        }
        
        var y = position.y
        while (canMoveUp(y)) {
            y -= 1
        }
        
        let newPosition = Position(x: position.x, y: y)
        return .init(position: newPosition)
    }
    
    private func moveLeft(on board: Board) -> Piece {
        let canMoveLeft: (Int) -> Bool = { x in
            let grid = board[position.y][x]
            return x > 0 && grid.canMoveLeft
        }
        
        var x = position.x
        while (canMoveLeft(x)) {
            x -= 1
        }
        
        let newPosition = Position(x: x, y: position.y)
        return .init(position: newPosition)
    }
    
    private func moveDown(on board: Board) -> Piece {
        let canMoveDown: (Int) -> Bool = { y in
            let grid = board[y][position.x]
            return y < gridSize - 1 && grid.canMoveDown
        }
        
        var y = position.y
        while (canMoveDown(y)) {
            y += 1
        }
        
        let newPosition = Position(x: position.x, y: y)
        return .init(position: newPosition)
    }
    
    private func moveRight(on board: Board) -> Piece {
        let canMoveRight: (Int) -> Bool = { x in
            let grid = board[position.y][x]
            return x < gridSize - 1 && grid.canMoveRight
        }
        
        var x = position.x
        while (canMoveRight(x)) {
            x += 1
        }
        
        let newPosition = Position(x: x, y: position.y)
        return .init(position: newPosition)
    }
}
