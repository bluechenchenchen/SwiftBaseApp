import SwiftUI

struct SystemIntegrationDemoView: View {
    // MARK: - Properties
    @State private var selectedTab = 0
    
    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedTab) {
            MapKitDemoView()
                .tabItem {
                    Label("地图", systemImage: "map")
                }
                .tag(0)
            
            PhotosDemoView()
                .tabItem {
                    Label("相册", systemImage: "photo")
                }
                .tag(1)
            
            ShareDemoView()
                .tabItem {
                    Label("分享", systemImage: "square.and.arrow.up")
                }
                .tag(2)
            
            AppleSignInDemoView()
                .tabItem {
                    Label("登录", systemImage: "person.crop.circle")
                }
                .tag(3)
            
            WebViewDemoView()
                .tabItem {
                    Label("网页", systemImage: "safari")
                }
                .tag(4)
        }
        .navigationTitle("系统集成示例")
    }
}

// MARK: - MapKit Demo
struct MapKitDemoView: View {
    var body: some View {
        Text("MapKit Demo")
            .navigationTitle("地图")
    }
}

// MARK: - Photos Demo
struct PhotosDemoView: View {
    var body: some View {
        Text("Photos Demo")
            .navigationTitle("相册")
    }
}

// MARK: - Share Demo
struct ShareDemoView: View {
    var body: some View {
        Text("Share Demo")
            .navigationTitle("分享")
    }
}

// MARK: - Apple Sign In Demo
struct AppleSignInDemoView: View {
    var body: some View {
        Text("Apple Sign In Demo")
            .navigationTitle("登录")
    }
}

// MARK: - WebView Demo
struct WebViewDemoView: View {
    var body: some View {
        Text("WebView Demo")
            .navigationTitle("网页")
    }
}

#Preview {
    NavigationStack {
        SystemIntegrationDemoView()
    }
}
