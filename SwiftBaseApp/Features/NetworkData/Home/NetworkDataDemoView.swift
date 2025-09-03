import SwiftUI

struct NetworkDataDemoView: View {
    // MARK: - Properties
    @State private var selectedTab = 0
    
    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedTab) {
            URLSessionDemoView()
                .tabItem {
                    Label("URLSession", systemImage: "network")
                }
                .tag(0)
            
            AsyncAwaitDemoView()
                .tabItem {
                    Label("Async/Await", systemImage: "clock.arrow.circlepath")
                }
                .tag(1)
            
            JSONHandlingDemoView()
                .tabItem {
                    Label("JSON处理", systemImage: "doc.text")
                }
                .tag(2)
            
            NetworkLayerDemoView()
                .tabItem {
                    Label("网络层", systemImage: "rectangle.3.group")
                }
                .tag(3)
        }
        .navigationTitle("网络数据示例")
    }
}

// MARK: - URLSession Demo
struct URLSessionDemoView: View {
    var body: some View {
        Text("URLSession Demo")
            .navigationTitle("URLSession")
    }
}

// MARK: - Async/Await Demo
struct AsyncAwaitDemoView: View {
    var body: some View {
        Text("Async/Await Demo")
            .navigationTitle("Async/Await")
    }
}

// MARK: - JSON Handling Demo
struct JSONHandlingDemoView: View {
    var body: some View {
        Text("JSON Handling Demo")
            .navigationTitle("JSON处理")
    }
}

// MARK: - Network Layer Demo
struct NetworkLayerDemoView: View {
    var body: some View {
        Text("Network Layer Demo")
            .navigationTitle("网络层")
    }
}

#Preview {
    NavigationStack {
        NetworkDataDemoView()
    }
}
