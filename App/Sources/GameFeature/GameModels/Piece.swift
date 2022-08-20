struct Piece {
    let position: Position
}

extension Piece {
    func move(direction: Direction, on grids: Grids) -> Piece {
        switch direction {
        case .up:
            return moveUp(on: grids)
        case .left:
            return moveLeft(on: grids)
        case .down:
            return moveDown(on: grids)
        case .right:
            return moveRight(on: grids)
        }
    }
    
    func isReachedGoal(on grids: Grids) -> Bool {
        let grid = grids[position.y][position.x]
        return grid.isGoal
    }
}

extension Piece {
    private func moveUp(on grids: Grids) -> Piece {
        let canMoveUp: (Int) -> Bool = { y in
            let grid = grids[y][position.x]
            return y > 0 && grid.canMoveUp
        }
        
        var y = position.y
        while (canMoveUp(y)) {
            y -= 1
        }
        
        let newPosition = Position(x: position.x, y: y)
        return .init(position: newPosition)
    }
    
    private func moveLeft(on grids: Grids) -> Piece {
        let canMoveLeft: (Int) -> Bool = { x in
            let grid = grids[position.y][x]
            return x > 0 && grid.canMoveLeft
        }
        
        var x = position.x
        while (canMoveLeft(x)) {
            x -= 1
        }
        
        let newPosition = Position(x: x, y: position.y)
        return .init(position: newPosition)
    }
    
    private func moveDown(on grids: Grids) -> Piece {
        let canMoveDown: (Int) -> Bool = { y in
            let grid = grids[y][position.x]
            return y < gridSize - 1 && grid.canMoveDown
        }
        
        var y = position.y
        while (canMoveDown(y)) {
            y += 1
        }
        
        let newPosition = Position(x: position.x, y: y)
        return .init(position: newPosition)
    }
    
    private func moveRight(on grids: Grids) -> Piece {
        let canMoveRight: (Int) -> Bool = { x in
            let grid = grids[position.y][x]
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
