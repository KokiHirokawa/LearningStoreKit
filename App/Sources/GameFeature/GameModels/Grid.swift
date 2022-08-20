typealias Grids = [[Grid]]

struct Grid {
    let movableDirections: Set<Direction>
    let isGoal: Bool
}

extension Grid {
    var canMoveUp: Bool {
        movableDirections.contains(.up)
    }
    
    var canMoveLeft: Bool {
        movableDirections.contains(.left)
    }
    
    var canMoveDown: Bool {
        movableDirections.contains(.down)
    }
    
    var canMoveRight: Bool {
        movableDirections.contains(.right)
    }
}

extension Grid {
    static let normal = Grid(
        movableDirections: [.up, .left, .down, .right],
        isGoal: false
    )
}
