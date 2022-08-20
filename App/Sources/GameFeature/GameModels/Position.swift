public struct Position: Equatable {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        assert(0 <= x && x < gridSize)
        assert(0 <= y && y < gridSize)
        
        self.x = x
        self.y = y
    }
}

let gridSize = 16
