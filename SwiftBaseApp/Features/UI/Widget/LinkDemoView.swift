import SwiftUI

// MARK: - 主视图
// MARK: - URL 处理工具
@MainActor
class URLManager {
  static let shared = URLManager()
  
  private var urlCache: [String: URL] = [:]
  
  private init() {}
  
  func getURL(_ urlString: String) async -> URL? {
    if let cachedURL = urlCache[urlString] {
      return cachedURL
    }
    
    guard let url = URL(string: urlString) else {
      return nil
    }
    
    // 在主线程检查 URL 是否可以打开
    let canOpen = await MainActor.run {
      UIApplication.shared.canOpenURL(url)
    }
    
    guard canOpen else {
      return nil
    }
    
    urlCache[urlString] = url
    return url
  }
}

struct LinkDemoView: View {
  var body: some View {
    ShowcaseList {
      // MARK: - 基础链接
      ShowcaseSection("基础链接") {
        ShowcaseItem(title: "基本网页链接", backgroundColor: Color.blue.opacity(0.1)) {
          VStack(spacing: 20) {
            Link("访问 Apple", destination: URL(string: "https://www.apple.com")!)
          }.padding()
        }
        
        ShowcaseItem(title: "电话链接", backgroundColor: Color.blue.opacity(0.1)) {
          VStack(spacing: 20) {
            Link("联系我们", destination: URL(string: "tel:+1234567890")!)
          }.padding()
        }
        
        ShowcaseItem(title: "邮件链接", backgroundColor: Color.blue.opacity(0.1)) {
          VStack(spacing: 20) {
            Link("发送邮件", destination: URL(string: "mailto:example@example.com")!)
          }.padding()
        }
        
        ShowcaseItem(title: "App Store 链接", backgroundColor: Color.blue.opacity(0.1)) {
          VStack(spacing: 20) {
            Link("下载 App", destination: URL(string: "itms-apps://itunes.apple.com/app/id123456789")!)
          }.padding()
        }
      }
      
      // MARK: - 样式示例
      ShowcaseSection("样式示例") {
        ShowcaseItem(title: "基本样式", backgroundColor: Color.green.opacity(0.1)) {
          VStack(spacing: 20) {
            Link("默认样式", destination: URL(string: "https://www.example.com")!)
          }.padding()
        }
        
        ShowcaseItem(title: "自定义样式", backgroundColor: Color.green.opacity(0.1)) {
          VStack(spacing: 20) {
            Link("自定义样式", destination: URL(string: "https://www.example.com")!)
              .foregroundColor(.blue)
              .font(.headline)
              .padding()
              .background(.blue.opacity(0.1))
              .cornerRadius(8)
          }.padding()
        }
        
        ShowcaseItem(title: "带图标", backgroundColor: Color.green.opacity(0.1)) {
          VStack(spacing: 20) {
            HStack {
              Image(systemName: "link")
              Link("带图标链接", destination: URL(string: "https://www.example.com")!)
            }
          }.padding()
        }
        
        ShowcaseItem(title: "边框样式", backgroundColor: Color.green.opacity(0.1)) {
          VStack(spacing: 20) {
            Link("边框样式", destination: URL(string: "https://www.example.com")!)
              .padding()
              .overlay(
                RoundedRectangle(cornerRadius: 8)
                  .stroke(.blue, lineWidth: 1)
              )
          }.padding()
        }
      }
      
      // MARK: - 高级示例
      ShowcaseSection("高级示例") {
        ShowcaseItem(title: "状态管理", backgroundColor: Color.orange.opacity(0.1)) {
          VStack(spacing: 20) {
            AdvancedLinkWithState()
          }.padding()
        }
        
        ShowcaseItem(title: "卡片式链接", backgroundColor: Color.orange.opacity(0.1)) {
          VStack(spacing: 20) {
            Link(destination: URL(string: "https://www.example.com")!) {
              HStack {
                Image(systemName: "app.gift.fill")
                  .resizable()
                  .frame(width: 40, height: 40)
                  .foregroundColor(.blue)
                VStack(alignment: .leading) {
                  Text("应用推荐")
                    .font(.headline)
                  Text("查看更多精彩应用")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                  .foregroundColor(.secondary)
              }
              .padding()
              .background(Color(.systemBackground))
              .cornerRadius(12)
              .shadow(radius: 2)
            }
          }.padding()
        }
      }
      
      // MARK: - 内置样式
      ShowcaseSection("内置样式") {
        ShowcaseItem(title: "按钮样式", backgroundColor: Color.purple.opacity(0.1)) {
          VStack(spacing: 20) {
            Link("按钮样式", destination: URL(string: "https://www.example.com")!)
              .buttonStyle(.bordered)
          }.padding()
        }
        
        ShowcaseItem(title: "普通样式", backgroundColor: Color.purple.opacity(0.1)) {
          VStack(spacing: 20) {
            Link("普通样式", destination: URL(string: "https://www.example.com")!)
              .buttonStyle(.plain)
          }.padding()
        }
        
        ShowcaseItem(title: "突出样式", backgroundColor: Color.purple.opacity(0.1)) {
          VStack(spacing: 20) {
            Link("突出样式", destination: URL(string: "https://www.example.com")!)
              .buttonStyle(.borderedProminent)
          }.padding()
        }
      }
      
      // MARK: - 动画效果
      ShowcaseSection("动画效果") {
        ShowcaseItem(title: "悬停效果", backgroundColor: Color.pink.opacity(0.1)) {
          VStack(spacing: 20) {
            HoverableLink()
          }.padding()
        }
        
        ShowcaseItem(title: "长按手势", backgroundColor: Color.pink.opacity(0.1)) {
          VStack(spacing: 20) {
            LongPressLink()
          }.padding()
        }
      }
      
      // MARK: - 社交媒体
      ShowcaseSection("社交媒体") {
        ShowcaseItem(title: "Twitter", backgroundColor: Color.cyan.opacity(0.1)) {
          VStack(spacing: 20) {
            SocialMediaLink(
              platform: "Twitter",
              username: "example",
              url: URL(string: "https://twitter.com/example")!
            )
          }.padding()
        }
        
        ShowcaseItem(title: "GitHub", backgroundColor: Color.cyan.opacity(0.1)) {
          VStack(spacing: 20) {
            SocialMediaLink(
              platform: "GitHub",
              username: "example",
              url: URL(string: "https://github.com/example")!
            )
          }.padding()
        }
      }
      
      // MARK: - 应用推荐
      ShowcaseSection("应用推荐") {
        ShowcaseItem(title: "App Store", backgroundColor: Color.mint.opacity(0.1)) {
          VStack(spacing: 20) {
            AppRecommendationLink(
              appID: "123456789",
              appName: "示例应用",
              description: "这是一个示例应用描述",
              iconName: "app.gift.fill"
            )
          }.padding()
        }
      }
      
      // MARK: - 异步加载
      ShowcaseSection("异步加载") {
        ShowcaseItem(title: "异步链接", backgroundColor: Color.indigo.opacity(0.1)) {
          VStack(spacing: 20) {
            AsyncLoadingLink(urlString: "https://www.example.com")
          }.padding()
        }
      }
      
      // MARK: - 主题适配
      ShowcaseSection("主题适配") {
        ShowcaseItem(title: "深色模式", backgroundColor: Color.teal.opacity(0.1)) {
          VStack(spacing: 20) {
            ThemeAdaptiveLink()
          }.padding()
        }
      }
      
      // MARK: - 辅助功能
      ShowcaseSection("辅助功能") {
        ShowcaseItem(title: "无障碍支持", backgroundColor: Color.brown.opacity(0.1)) {
          VStack(spacing: 20) {
            Link("辅助功能", destination: URL(string: "https://www.example.com")!)
              .accessibilityLabel("访问帮助页面")
              .accessibilityHint("点击将在浏览器中打开帮助页面")
              .accessibilityAddTraits(.isLink)
          }.padding()
        }
        
        ShowcaseItem(title: "动态字体", backgroundColor: Color.brown.opacity(0.1)) {
          VStack(spacing: 20) {
            Link("动态字体", destination: URL(string: "https://www.example.com")!)
              .font(.body)
              .dynamicTypeSize(...DynamicTypeSize.accessibility3)
          }.padding()
        }
        
        ShowcaseItem(title: "本地化", backgroundColor: Color.brown.opacity(0.1)) {
          VStack(spacing: 20) {
            Link(LocalizedStringKey("link.support"),
                 destination: URL(string: "https://www.example.com")!)
            .environment(\.locale, Locale(identifier: "zh_CN"))
          }.padding()
        }
      }
      
      // MARK: - 联系方式
      ShowcaseSection("联系方式") {
        ShowcaseItem(title: "电话", backgroundColor: Color.gray.opacity(0.1)) {
          VStack(spacing: 20) {
            ContactLink(type: .phone, value: "+1234567890")
          }.padding()
        }
        
        ShowcaseItem(title: "邮件", backgroundColor: Color.gray.opacity(0.1)) {
          VStack(spacing: 20) {
            ContactLink(type: .email, value: "example@example.com")
          }.padding()
        }
        
        ShowcaseItem(title: "网站", backgroundColor: Color.gray.opacity(0.1)) {
          VStack(spacing: 20) {
            ContactLink(type: .website, value: "https://www.example.com")
          }.padding()
        }
      }
    }
    .navigationTitle("链接控件 Demo")
  }
}

// MARK: - 辅助视图
struct AdvancedLinkWithState: View {
  @State private var isVisited = false
  
  var body: some View {
    Link(destination: URL(string: "https://www.example.com")!) {
      HStack {
        Text("访问链接")
        Image(systemName: isVisited ? "checkmark.circle.fill" : "arrow.right.circle")
      }
      .foregroundColor(isVisited ? .secondary : .blue)
    }
    .simultaneousGesture(TapGesture().onEnded {
      isVisited = true
    })
  }
}

// MARK: - 联系方式链接组件
struct ContactLink: View {
  let type: ContactType
  let value: String
  
  enum ContactType {
    case phone, email, website
    
    var scheme: String {
      switch self {
      case .phone: return "tel:"
      case .email: return "mailto:"
      case .website: return ""
      }
    }
    
    var icon: String {
      switch self {
      case .phone: return "phone.fill"
      case .email: return "envelope.fill"
      case .website: return "globe"
      }
    }
  }
  
  var body: some View {
    if let url = URL(string: type.scheme + value) {
      Link(destination: url) {
        HStack {
          Image(systemName: type.icon)
            .foregroundColor(.blue)
          Text(value)
          Spacer()
          Image(systemName: "arrow.up.right.square")
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
      }
    }
  }
}

// MARK: - 预览
// MARK: - 悬停链接
struct HoverableLink: View {
  @State private var isHovered = false
  
  var body: some View {
    Link(destination: URL(string: "https://www.example.com")!) {
      Text("悬停效果")
        .padding()
        .background(isHovered ? .blue.opacity(0.2) : .blue.opacity(0.1))
        .foregroundColor(.blue)
        .cornerRadius(8)
        .scaleEffect(isHovered ? 1.05 : 1.0)
    }
    .onHover { hovering in
      withAnimation(.spring()) {
        isHovered = hovering
      }
    }
  }
}

// MARK: - 长按链接
struct LongPressLink: View {
  @State private var isPressed = false
  
  var body: some View {
    Link(destination: URL(string: "https://www.example.com")!) {
      Text("长按查看更多")
        .padding()
        .background(isPressed ? .blue : .blue.opacity(0.1))
        .foregroundColor(isPressed ? .white : .blue)
        .cornerRadius(8)
    }
    .simultaneousGesture(LongPressGesture().onEnded { _ in
      withAnimation {
        isPressed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          isPressed = false
        }
      }
    })
  }
}

// MARK: - 社交媒体链接
struct SocialMediaLink: View {
  let platform: String
  let username: String
  let url: URL
  
  var body: some View {
    Link(destination: url) {
      HStack {
        Image(systemName: platform.lowercased() == "twitter" ? "bird" : "terminal")
          .resizable()
          .frame(width: 24, height: 24)
        Text("@\(username)")
        Spacer()
        Image(systemName: "arrow.up.right.square")
          .foregroundColor(.secondary)
      }
      .padding()
      .background(Color(.systemBackground))
      .cornerRadius(8)
      .shadow(radius: 2)
    }
  }
}

// MARK: - 应用推荐链接
struct AppRecommendationLink: View {
  let appID: String
  let appName: String
  let description: String
  let iconName: String
  
  var body: some View {
    if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)") {
      Link(destination: url) {
        HStack {
          Image(systemName: iconName)
            .resizable()
            .frame(width: 60, height: 60)
            .cornerRadius(12)
          VStack(alignment: .leading) {
            Text(appName)
              .font(.headline)
            Text(description)
              .font(.subheadline)
              .foregroundColor(.secondary)
          }
          Spacer()
          Text("获取")
            .foregroundColor(.blue)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.blue.opacity(0.1))
            .cornerRadius(16)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 3)
      }
    }
  }
}

// MARK: - 异步加载链接
struct AsyncLoadingLink: View {
  let urlString: String
  @State private var url: URL?
  @State private var isLoading = true
  @State private var error: Error?
  
  var body: some View {
    Group {
      if let url = url {
        Link("链接就绪", destination: url)
          .foregroundColor(.blue)
      } else if isLoading {
        ProgressView()
          .progressViewStyle(.circular)
      } else if error != nil {
        Text("链接无效")
          .foregroundColor(.red)
      }
    }
    .onAppear {
      loadURL()
    }
  }
  
  @MainActor
  private func loadURL() {
    isLoading = true
    
    Task {
      do {
        if let url = await URLManager.shared.getURL(urlString) {
          self.url = url
        } else {
          self.error = NSError(domain: "URLError", code: -1, userInfo: nil)
        }
        self.isLoading = false
      }
    }
  }
}

// MARK: - 主题适配链接
struct ThemeAdaptiveLink: View {
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    Link(destination: URL(string: "https://www.example.com")!) {
      HStack {
        Image(systemName: "moon.stars.fill")
          .foregroundColor(colorScheme == .dark ? .yellow : .blue)
        Text("主题适配")
          .foregroundColor(Color(.label))
      }
      .padding()
      .background(Color(.systemBackground))
      .cornerRadius(8)
      .shadow(radius: 2)
    }
  }
}

#Preview {
  NavigationView {
    LinkDemoView()
  }
}
