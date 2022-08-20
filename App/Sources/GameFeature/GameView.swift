import ComposableArchitecture
import SwiftUI

struct GameViewState: Equatable {
    let boardGame: BoardGame
    
    init(state: GameState) {
        self.boardGame = state.boardGame
    }
}

public struct GameView: View {
    
    @ObservedObject var viewStore: ViewStore<GameViewState, GameAction>
    
    public init(store: Store<GameState, GameAction>) {
        self.viewStore = ViewStore(store.scope(state: GameViewState.init))
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    ForEach(viewStore.boardGame.board.rows, id: \.id) { row in
                        HStack(spacing: 0) {
                            ForEach(row.grids, id: \.id) { grid in
                                let size = min(geometry.size.width, geometry.size.height) / CGFloat(gridSize)
                                
                                if grid.isGoal {
                                    Rectangle()
                                        .border(.gray)
                                        .frame(width: size, height: size)
                                        .foregroundColor(.gray)
                                } else {
                                    Rectangle()
                                        .border(.gray)
                                        .frame(width: size, height: size)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
}

let mockBoard = BoardGame(
    board: .init(rows: [
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal()
        ]),
        .init(grids: [
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .normal(),
            .init(movableDirections: [], isGoal: true)
        ])
    ]),
    piece: .init(position: .init(x: 0, y: 0))
)

enum GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(
            store: .init(
                initialState: .init(boardGame: mockBoard),
                reducer: gameReducer,
                environment: .init()
            )
        )
    }
}
