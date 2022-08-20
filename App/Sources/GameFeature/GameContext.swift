import ComposableArchitecture

public struct GameState {
    public var boardGame: BoardGame
    
    public init(
        boardGame: BoardGame
    ) {
        self.boardGame = boardGame
    }
}

public enum GameAction {}

public struct GameEnvironment {
    public init() {}
}

public let gameReducer = Reducer<GameState, GameAction, GameEnvironment>
    .combine(
        .init()
    )
