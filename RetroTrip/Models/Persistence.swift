import SwiftData

final class Persistence {
    @MainActor
    static let shared = Persistence()
    
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    
    @MainActor
    init() {
        self.modelContainer = try! ModelContainer(
//            for: Favorite.self, Cart.self, Order.self
        )
        self.modelContext = modelContainer.mainContext
    }
}
