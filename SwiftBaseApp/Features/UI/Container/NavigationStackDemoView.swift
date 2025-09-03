import SwiftUI

// MARK: - 示例数据模型
struct Destination: Hashable {
  let id = UUID()
  let title: String
  let description: String
  let color: Color
}

// MARK: - 主视图
struct NavigationStackDemoView: View {
  // MARK: - 状态属性
  @State private var path = NavigationPath()
  @State private var selectedTab = 0
  @State private var showDetail = false
  @State private var destinations: [Destination] = [
    Destination(title: "首页", description: "这是首页内容", color: .blue),
    Destination(title: "详情", description: "这是详情页面", color: .green),
    Destination(title: "设置", description: "这是设置页面", color: .purple)
  ]
  
  var body: some View {
    ShowcaseList {
      // MARK: - 基础导航
      ShowcaseSection("基础导航") {
        ShowcaseItem(title: "这是一个简单导航") {
          NavigationStack {
            // VStack(spacing: 12) {
            NavigationLink("进入详情页面") {
              Text("详情页面内容")
                .navigationTitle("详情")
            }
            .buttonStyle(.borderedProminent)
            
            // Text("点击上方按钮导航")
            //     .font(.caption)
            //     .foregroundStyle(.secondary)
            // }
            // .navigationTitle("首页")
          }
          .frame(height: 400)
        }
        ShowcaseItem(title: "编程式导航") {
          // VStack(spacing: 16) {
          //     Text("使用状态控制导航")
          //         .font(.headline)
          //         .frame(maxWidth: .infinity, alignment: .center)
          
          NavigationStack {
            VStack(spacing: 12) {
              Button("显示详情") {
                showDetail = true
              }
              .buttonStyle(.borderedProminent)
              
              Text("使用状态变量控制导航")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .navigationDestination(isPresented: $showDetail) {
              Text("通过状态变量显示的详情页")
                .navigationTitle("详情")
            }
            // .navigationTitle("首页")
          }
          .frame(height: 400)
          // }
        }
      }
      
      // MARK: - 数据传递
      ShowcaseSection("数据传递") {
        ShowcaseItem(title: "传递简单数据") {
          // VStack(spacing: 16) {
          // Text("传递参数示例")
          //     .font(.headline)
          //     .frame(maxWidth: .infinity, alignment: .center)
          
          NavigationStack {
            List(destinations, id: \.id) { destination in
              NavigationLink(destination.title) {
                DetailView(destination: destination)
              }
            }
            // .navigationTitle("目的地列表")
          }
          .frame(height: 400)
          // }
        }
        
        ShowcaseItem(title: "复杂数据传递") {
          // VStack(spacing: 16) {
          // Text("传递复杂数据结构")
          //     .font(.headline)
          //     .frame(maxWidth: .infinity, alignment: .center)
          
          NavigationStack(path: $path) {
            List {
              ForEach(destinations, id: \.id) { destination in
                Button(destination.title) {
                  path.append(destination)
                }
              }
            }
            .navigationDestination(for: Destination.self) { destination in
              DetailView(destination: destination)
            }
            // .navigationTitle("路径导航")
          }
          .frame(height: 400)
          // }
        }
      }
      
      // MARK: - 导航路径管理
      ShowcaseSection("导航路径管理") {
        ShowcaseItem(title: "路径操作") {
          // VStack(spacing: 16) {
          // Text("导航路径控制")
          //     .font(.headline)
          //     .frame(maxWidth: .infinity, alignment: .center)
          
          NavigationStack(path: $path) {
            VStack(spacing: 12) {
              Button("添加路径") {
                path.append(destinations[0])
              }
              .buttonStyle(.borderedProminent)
              
              Button("清空路径") {
                path.removeLast(path.count)
              }
              .buttonStyle(.bordered)
              
              Text("当前路径深度: \(path.count)")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .navigationDestination(for: Destination.self) { destination in
              DetailView(destination: destination)
            }
            // .navigationTitle("路径管理")
          }
          .frame(height: 400)
          // }
        }
      }
      
      // MARK: - 自定义过渡动画
      ShowcaseSection("自定义过渡动画") {
        ShowcaseItem(title: "转场效果") {
          // VStack(spacing: 16) {
          // Text("自定义动画效果")
          //     .font(.headline)
          //     .frame(maxWidth: .infinity, alignment: .center)
          
          NavigationStack {
            // VStack(spacing: 12) {
            NavigationLink {
              Text("带动画的详情页")
                .transition(.move(edge: .trailing))
                .navigationTitle("动画详情")
            } label: {
              Text("查看动画效果")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            // }
            // .navigationTitle("动画示例")
          }
          .frame(height: 400)
          // }
        }
      }
      
      // MARK: - 导航栏定制
      ShowcaseSection("导航栏定制") {
        ShowcaseItem(title: "导航栏样式") {
          // VStack(spacing: 16) {
          // Text("自定义导航栏")
          //     .font(.headline)
          //     .frame(maxWidth: .infinity, alignment: .center)
          
          NavigationStack {
            Text("自定义导航栏示例")
              .navigationTitle("自定义导航栏")
              .navigationBarTitleDisplayMode(.inline)
              .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                  Button(action: {}) {
                    Image(systemName: "gear")
                  }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                  Button(action: {}) {
                    Image(systemName: "person.circle")
                  }
                }
              }
          }
          .frame(height: 400)
          // }
        }
      }
      
      // MARK: - 深层链接支持
      ShowcaseSection("深层链接支持") {
        ShowcaseItem(title: "深层链接") {
          // VStack(spacing: 16) {
          // Text("深层链接示例")
          //     .font(.headline)
          //     .frame(maxWidth: .infinity, alignment: .center)
          
          NavigationStack(path: $path) {
            VStack(spacing: 12) {
              Button("模拟深层链接") {
                // 模拟深层链接跳转
                path = NavigationPath([
                  destinations[0],
                  destinations[1],
                  destinations[2]
                ])
              }
              .buttonStyle(.borderedProminent)
              
              Text("点击按钮模拟深层链接跳转")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .navigationDestination(for: Destination.self) { destination in
              DetailView(destination: destination)
            }
            // .navigationTitle("深层链接")
          }
          .frame(height: 400)
          // }
        }
      }
      
      // MARK: - 性能优化
      ShowcaseSection("性能优化") {
        ShowcaseItem(title: "视图复用") {
          // VStack(spacing: 16) {
          // Text("性能优化示例")
          //     .font(.headline)
          //     .frame(maxWidth: .infinity, alignment: .center)
          
          NavigationStack {
            List {
              ForEach(0..<100) { index in
                NavigationLink("项目 \(index)") {
                  Text("详情 \(index)")
                    .navigationTitle("详情 \(index)")
                }
              }
            }
            // .navigationTitle("长列表")
          }
          .frame(height: 400)
          // }
        }
      }
    }
    .navigationTitle("NavigationStack 示例")
  }
}

// MARK: - 详情视图
struct DetailView: View {
  let destination: Destination
  
  var body: some View {
    VStack(spacing: 16) {
      Text(destination.description)
        .font(.headline)
      
      RoundedRectangle(cornerRadius: 10)
        .fill(destination.color)
        .frame(width: 100, height: 100)
    }
    .navigationTitle(destination.title)
    .padding()
  }
}

// MARK: - 预览
#Preview {
  NavigationView {
    NavigationStackDemoView()
  }
}
