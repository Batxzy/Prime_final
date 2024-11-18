import SwiftUI


//MARK: - NavigationManager remote control
class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    
    @Published var currentRoute: AppRoute?
    @Published var isActive = false
    
    func navigate(to route: AppRoute) {
        currentRoute = route
        isActive = true
    }
    
    func goBack() {
        isActive = false
        currentRoute = nil
    }
}