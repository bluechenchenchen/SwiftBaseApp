import SwiftUI

// MARK: - 数据模型
struct LazyItem: Identifiable, Equatable {
  let id = UUID()
  let title: String
  let color: Color
  
  static func == (lhs: LazyItem, rhs: LazyItem) -> Bool {
    lhs.id == rhs.id
  }
}

struct LazyCategory: Identifiable {
  let id = UUID()
  let title: String
  let items: [LazyItem]
}

// MARK: - 主视图
struct LazyHStackDemoView: View {
  // MARK: - 状态属性
  @State private var selectedItem: LazyItem?
  @State private var selectedImage: String?
  @State private var isLoading = false
  @State private var showAll = false
  
  // MARK: - 示例数据
  let basicItems = (1...20).map { LazyItem(title: "项目 \($0)", color: .random) }
  let cardItems = (1...10).map { LazyItem(title: "卡片 \($0)", color: .random) }
  let interactiveItems = (1...10).map { LazyItem(title: "项目 \($0)", color: .random) }
  let images = ["star.fill", "heart.fill", "bell.fill", "person.fill", "gear"]
  let categories = [
    LazyCategory(title: "类别1", items: (1...5).map { LazyItem(title: "项目1-\($0)", color: .blue) }),
    LazyCategory(title: "类别2", items: (1...5).map { LazyItem(title: "项目2-\($0)", color: .green) }),
    LazyCategory(title: "类别3", items: (1...5).map { LazyItem(title: "项目3-\($0)", color: .orange) })
  ]
  
  var body: some View {
    ShowcaseList {
      // MARK: - 基础示例
      ShowcaseSection("基础示例") {
        // 1. 基本用法
        ShowcaseItem(title: "基本用法") {
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
              ForEach(basicItems) { item in
                Text(item.title)
                  .padding()
                  .background(item.color.opacity(0.2))
                  .cornerRadius(8)
              }
            }
            .padding(.horizontal)
          }
        }
        
        // 2. 间距控制
        ShowcaseItem(title: "间距控制") {
          VStack {
            Text("无间距")
              .font(.caption)
              .foregroundStyle(.secondary)
            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(spacing: 0) {
                ForEach(0..<10) { index in
                  Text("\(index)")
                    .frame(width: 40, height: 40)
                    .background(Color.random.opacity(0.2))
                }
              }
            }
            
            Text("固定间距")
              .font(.caption)
              .foregroundStyle(.secondary)
              .padding(.top, 8)
            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(spacing: 20) {
                ForEach(0..<10) { index in
                  Text("\(index)")
                    .frame(width: 40, height: 40)
                    .background(Color.random.opacity(0.2))
                }
              }
              .padding(.horizontal)
            }
          }
        }
        
        // 3. 对齐方式
        ShowcaseItem(title: "对齐方式") {
          VStack {
            Text("顶部对齐")
              .font(.caption)
              .foregroundStyle(.secondary)
            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(alignment: .top, spacing: 10) {
                ForEach(0..<5) { index in
                  RoundedRectangle(cornerRadius: 8)
                    .fill(Color.random.opacity(0.2))
                    .frame(width: 60, height: CGFloat(40 + index * 20))
                }
              }
              .padding(.horizontal)
            }
            
            Text("底部对齐")
              .font(.caption)
              .foregroundStyle(.secondary)
              .padding(.top, 8)
            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(alignment: .bottom, spacing: 10) {
                ForEach(0..<5) { index in
                  RoundedRectangle(cornerRadius: 8)
                    .fill(Color.random.opacity(0.2))
                    .frame(width: 60, height: CGFloat(40 + index * 20))
                }
              }
              .padding(.horizontal)
            }
          }
        }
      }
      
      // MARK: - 交互示例
      ShowcaseSection("交互示例") {
        // 1. 选择效果
        ShowcaseItem(title: "选择效果") {
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
              ForEach(interactiveItems) { item in
                Text(item.title)
                  .padding()
                  .background(
                    selectedItem?.id == item.id ?
                    item.color.opacity(0.4) :
                      item.color.opacity(0.2)
                  )
                  .cornerRadius(8)
                  .scaleEffect(selectedItem?.id == item.id ? 1.1 : 1.0)
                  .animation(.spring(), value: selectedItem)
                  .onTapGesture {
                    withAnimation {
                      selectedItem = item
                    }
                  }
              }
            }
            .padding()
          }
        }
        
        // 2. 加载动画
        ShowcaseItem(title: "加载动画") {
          VStack {
            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(spacing: 15) {
                ForEach(0..<10) { index in
                  Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay {
                      if isLoading {
                        ProgressView()
                      }
                    }
                }
              }
              .padding()
            }
            
            Button(isLoading ? "停止加载" : "开始加载") {
              isLoading.toggle()
            }
            .buttonStyle(.bordered)
          }
        }
        
        // 3. 展开/收起
        ShowcaseItem(title: "展开/收起") {
          VStack {
            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(spacing: 15) {
                ForEach(0..<(showAll ? 10 : 3)) { index in
                  Text("项目 \(index + 1)")
                    .padding()
                    .background(Color.random.opacity(0.2))
                    .cornerRadius(8)
                }
              }
              .padding()
            }
            
            Button(showAll ? "收起" : "显示全部") {
              withAnimation {
                showAll.toggle()
              }
            }
            .buttonStyle(.bordered)
          }
        }
      }
      
      // MARK: - 卡片示例
      ShowcaseSection("卡片示例") {
        ShowcaseItem(title: "卡片列表") {
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
              ForEach(cardItems) { item in
                VStack {
                  Circle()
                    .fill(item.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                  Text(item.title)
                    .font(.headline)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 3)
              }
            }
            .padding()
          }
        }
      }
      
      // MARK: - 图片画廊
      ShowcaseSection("图片画廊") {
        ShowcaseItem(title: "系统图标") {
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
              ForEach(images, id: \.self) { image in
                Image(systemName: image)
                  .font(.system(size: 40))
                  .frame(width: 100, height: 100)
                  .background(
                    selectedImage == image ?
                      .blue.opacity(0.2) :
                        .gray.opacity(0.1)
                  )
                  .cornerRadius(12)
                  .onTapGesture {
                    withAnimation {
                      selectedImage = image
                    }
                  }
              }
            }
            .padding()
          }
        }
      }
      
      // MARK: - 分类示例
      ShowcaseSection("分类示例") {
        ShowcaseItem(title: "分类列表") {
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: 15) {
              ForEach(categories) { category in
                VStack(alignment: .leading) {
                  Text(category.title)
                    .font(.headline)
                  
                  ForEach(category.items) { item in
                    Text(item.title)
                      .padding(.vertical, 4)
                  }
                }
                .padding()
                .frame(width: 150)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 3)
              }
            }
            .padding()
          }
        }
      }
      
      
    }
    .navigationTitle("延迟水平布局示例")
  }
}

// MARK: - 辅助扩展
extension Color {
  static var random: Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1)
    )
  }
}

// MARK: - 预览
#Preview {
  NavigationView {
    LazyHStackDemoView()
  }
}
