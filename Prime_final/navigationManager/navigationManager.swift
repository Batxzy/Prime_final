import SwiftUI


// MARK: - NavigationManager remote control
class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    
    @Published var path = NavigationPath()
    @Published var currentRoute: AppRoute?
    
    func navigate(to route: AppRoute) {
        currentRoute = route
        path.append(route)
    }
    
    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
        currentRoute = path.last as? AppRoute
    }

    func popToRoot() {
            path = NavigationPath()  // Better than removeLast(count)
            currentRoute = nil
    }
}