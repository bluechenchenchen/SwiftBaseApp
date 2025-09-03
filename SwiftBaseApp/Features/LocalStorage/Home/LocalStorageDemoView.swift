import SwiftUI

struct LocalStorageDemoView: View {
    // MARK: - Properties
    @State private var selectedTab = 0
    
    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedTab) {
            UserDefaultsDemoView()
                .tabItem {
                    Label("UserDefaults", systemImage: "gear")
                }
                .tag(0)
            
            CoreDataDemoView()
                .tabItem {
                    Label("CoreData", systemImage: "database")
                }
                .tag(1)
            
            FileManagerDemoView()
                .tabItem {
                    Label("FileManager", systemImage: "folder")
                }
                .tag(2)
            
            KeychainDemoView()
                .tabItem {
                    Label("Keychain", systemImage: "lock")
                }
                .tag(3)
        }
        .navigationTitle("本地存储示例")
    }
}

// MARK: - UserDefaults Demo
struct UserDefaultsDemoView: View {
    var body: some View {
        Text("UserDefaults Demo")
            .navigationTitle("UserDefaults")
    }
}

// MARK: - CoreData Demo
struct CoreDataDemoView: View {
    var body: some View {
        Text("CoreData Demo")
            .navigationTitle("CoreData")
    }
}

// MARK: - FileManager Demo
struct FileManagerDemoView: View {
    var body: some View {
        Text("FileManager Demo")
            .navigationTitle("FileManager")
    }
}

// MARK: - Keychain Demo
struct KeychainDemoView: View {
    var body: some View {
        Text("Keychain Demo")
            .navigationTitle("Keychain")
    }
}

#Preview {
    NavigationStack {
        LocalStorageDemoView()
    }
}
