import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    // FirebaseApp.configure()

    return true
  }
}

@main
struct OrderMateApp: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var userManager = UserViewModel.shared // user Info 받아오기
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
                    .environmentObject(userManager) // user Info 받아오기
            }
        }
    }
}
