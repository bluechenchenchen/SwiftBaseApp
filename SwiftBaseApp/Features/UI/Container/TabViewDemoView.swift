import SwiftUI

struct TabViewDemoView: View {
  // MARK: - 状态属性
  @State private var selectedTab = 0
  @State private var showPageStyle = false
  
  // 自定义标签属性
  @State private var customIcon = "2.circle"
  @State private var customTitle = "自定义"
  @State private var badgeCount = 0
  @State private var backgroundColor = Color.blue.opacity(0.2)
  @State private var fontSize: CGFloat = 17
  @State private var iconSize: CGFloat = 20
  
  // MARK: - 主视图
  var body: some View {
    ShowcaseList {
      // MARK: - 基础用法
      ShowcaseSection("基础用法") {
        ShowcaseItem(title: "标准标签栏") {
          VStack {
            if showPageStyle {
              pageStyleExample
            } else {
              tabStyleExample
            }
            
            Toggle("使用分页样式", isOn: $showPageStyle)
              .padding()
          }
          .frame(height: 400)
        }
      }
      
      
      // MARK: - 样式定制
      ShowcaseSection("样式定制") {
        ShowcaseItem(title: "分页样式") {
          pageStyleExample
            .frame(height: 300)
        }
        
        ShowcaseItem(title: "自定义标签") {
          VStack(spacing: 20) {
            List {
              Section("自定义特性") {
                // 1. 自定义图标
                Picker("选择图标", selection: $customIcon) {
                  ForEach(["2.circle", "star.fill", "heart.fill", "person.fill", "gear"], id: \.self) { icon in
                    Label(icon, systemImage: icon)
                  }
                }
                
                // 2. 自定义标题
                HStack {
                  Text("标题：")
                  TextField("输入标题", text: $customTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // 3. 徽章设置
                Stepper("徽章数量: \(badgeCount)", value: $badgeCount, in: 0...99)
              }
              
              Section("样式设置") {
                // 1. 背景色设置
                ColorPicker("背景颜色", selection: $backgroundColor)
                
                // 2. 字体大小设置
                HStack {
                  Text("字体大小: \(Int(fontSize))")
                  Slider(value: $fontSize, in: 12...24, step: 1)
                }
                
                // 3. 图标大小设置
                HStack {
                  Text("图标大小: \(Int(iconSize))")
                  Slider(value: $iconSize, in: 16...32, step: 1)
                }
              }
            }.frame(height:400)
            
            // 预览效果
            TabView {
              Text("示例内容")
                .tabItem {
                  Label(customTitle, systemImage: customIcon)
                    .font(.system(size: iconSize))
                }
                .badge(badgeCount)
            }
            .background(backgroundColor)
            .font(.system(size: fontSize))
          }
          .frame(height: 500)
        }
      }
      
      // MARK: - 高级特性
      ShowcaseSection("高级特性") {
        ShowcaseItem(title: "状态管理") {
          stateManagementExample
        }
        
        ShowcaseItem(title: "动画效果") {
          animationExample
            .frame(height: 300)
        }
        
        ShowcaseItem(title: "组合使用") {
          combinationExample
            .frame(height: 400)
        }
      }
      
      // MARK: - 辅助功能
      ShowcaseSection("辅助功能") {
        ShowcaseItem(title: "无障碍支持") {
          VStack(spacing: 20) {
            Text("VoiceOver 支持")
              .font(.headline)
              .accessibilityLabel("Voice Over 支持示例")
              .accessibilityHint("展示如何添加无障碍支持")
            
            Text("动态字体支持")
              .font(.headline)
              .dynamicTypeSize(...DynamicTypeSize.accessibility5)
            
            Text("本地化支持")
              .font(.headline)
              .environment(\.locale, .init(identifier: "zh-Hans"))
          }
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.blue.opacity(0.1))
          .cornerRadius(10)
        }
      }
    }
    .navigationTitle("TabView 示例")
  }
  
  // MARK: - 辅助视图
  private var tabStyleExample: some View {
    TabView(selection: $selectedTab) {
      // First Tab - Basic
      VStack(spacing: 20) {
        Text("基础标签页")
          .font(.title)
        
        Text("这是一个简单的 TabView 示例，展示了基本的选项卡功能。")
          .multilineTextAlignment(.center)
          .padding()
        
        Button("切换到自定义选项卡") {
          withAnimation {
            selectedTab = 1
          }
        }
      }
      .padding()
      .tabItem {
        Label("基础", systemImage: "1.circle")
      }
      .tag(0)
      
      // Second Tab - Custom
      Text("自定义标签页")
        .font(.title)
        .tabItem {
          Label(customTitle, systemImage: customIcon)
            .font(.system(size: iconSize))
        }
        .tag(1)
        .badge(badgeCount)
      
      // Third Tab - Advanced
      Text("高级标签页")
        .font(.title)
        .tabItem {
          Label("高级", systemImage: "3.circle")
        }
        .tag(2)
    }
  }
  
  private var pageStyleExample: some View {
    TabView {
      ForEach(0..<5) { index in
        RoundedRectangle(cornerRadius: 15)
          .fill(Color.blue.opacity(0.2))
          .overlay(
            Text("Page \(index + 1)")
              .font(.largeTitle)
          )
          .padding()
      }
    }
    .tabViewStyle(.page)
    .indexViewStyle(.page(backgroundDisplayMode: .always))
  }
  
  private var stateManagementExample: some View {
    VStack(spacing: 20) {
      Text("状态管理示例")
        .font(.title)
      
      Text("当前选中的选项卡: \(selectedTab)")
      
      Button("切换到第一个选项卡") {
        withAnimation {
          selectedTab = 0
        }
      }
    }
    .padding()
  }
  
  private var animationExample: some View {
    TabView {
      ForEach(0..<3) { index in
        Text("动画页面 \(index + 1)")
          .font(.largeTitle)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color.blue.opacity(0.2))
          .transition(.slide)
      }
    }
    .tabViewStyle(.page)
    .animation(.easeInOut, value: selectedTab)
  }
  
  private var combinationExample: some View {
    TabView {
      NavigationStack {
        List {
          ForEach(1...5, id: \.self) { item in
            NavigationLink("项目 \(item)") {
              Text("详情 \(item)")
            }
          }
        }
        .navigationTitle("组合示例")
      }
      .tabItem {
        Label("列表", systemImage: "list.bullet")
      }
      
      Text("设置")
        .tabItem {
          Label("设置", systemImage: "gear")
        }
    }
  }
}

// MARK: - 预览
#Preview {
  NavigationStack {
    TabViewDemoView()
  }
}
