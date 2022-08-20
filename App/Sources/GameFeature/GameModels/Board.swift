import Foundation

public struct Board: Equatable {
    let rows: [Row]
    
    subscript(index: Int) -> Row {
        rows[index]
    }
}

public struct Row: Equatable, Identifiable {
    public let id = UUID()
    let grids: [Grid]
    
    subscript(index: Int) -> Grid {
        grids[index]
    }
}
