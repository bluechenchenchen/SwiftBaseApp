import SwiftUI

// MARK: - 数据模型
struct LazyVItem: Identifiable, Equatable {
  let id = UUID()
  let title: String
  let color: Color
  
  static func == (lhs: LazyVItem, rhs: LazyVItem) -> Bool {
    lhs.id == rhs.id
  }
}

// MARK: - 主视图
struct LazyVStackDemoView: View {
  // MARK: - 状态属性
  @State private var selectedItem: LazyVItem?
  @State private var notifications = true
  @State private var darkMode = false
  @State private var volume = 0.5
  
  // MARK: - 示例数据
  let basicItems = (1...20).map { LazyVItem(title: "项目 \($0)", color: .randomLazy) }
  let cardItems = (1...10).map { LazyVItem(title: "卡片 \($0)", color: .randomLazy) }
  let interactiveItems = (1...10).map { LazyVItem(title: "项目 \($0)", color: .randomLazy) }
  let listItems = (1...10).map { LazyVItem(title: "列表项 \($0)", color: .randomLazy) }
  
  var body: some View {
    ShowcaseList {
      // MARK: - 基础示例
      ShowcaseSection("基础示例") {
        ShowcaseItem(title: "基本用法") {
          ScrollView {
            LazyVStack(spacing: 10) {
              ForEach(basicItems) { item in
                Text(item.title)
                  .padding()
                  .frame(maxWidth: .infinity)
                  .background(item.color.opacity(0.2))
                  .cornerRadius(8)
              }
            }
          }
          .frame(height: 200)
        }
        
        ShowcaseItem(title: "间距控制") {
          VStack(spacing: 10) {
            Text("无间距")
              .font(.caption)
              .foregroundStyle(.secondary)
            ScrollView {
              LazyVStack(spacing: 0) {
                ForEach(0..<5) { index in
                  Text("项目 \(index)")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.randomLazy.opacity(0.2))
                }
              }
            }
            .frame(height: 100)
            
            Text("固定间距")
              .font(.caption)
              .foregroundStyle(.secondary)
            ScrollView {
              LazyVStack(spacing: 20) {
                ForEach(0..<5) { index in
                  Text("项目 \(index)")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.randomLazy.opacity(0.2))
                }
              }
            }
            .frame(height: 150)
          }
        }
        
        ShowcaseItem(title: "对齐方式") {
          VStack(spacing: 10) {
            Text("左对齐")
              .font(.caption)
              .foregroundStyle(.secondary)
            ScrollView {
              LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(0..<3) { index in
                  Text("左对齐文本 \(index)")
                    .padding()
                    .background(Color.randomLazy.opacity(0.2))
                    .cornerRadius(8)
                }
              }
            }
            .frame(height: 150)
            
            Text("右对齐")
              .font(.caption)
              .foregroundStyle(.secondary)
            ScrollView {
              LazyVStack(alignment: .trailing, spacing: 10) {
                ForEach(0..<3) { index in
                  Text("右对齐文本 \(index)")
                    .padding()
                    .background(Color.randomLazy.opacity(0.2))
                    .cornerRadius(8)
                }
              }
            }
            .frame(height: 150)
          }
        }
      }
      
      // MARK: - 卡片示例
      ShowcaseSection("卡片示例") {
        ShowcaseItem(title: "卡片列表") {
          ScrollView {
            LazyVStack(spacing: 15) {
              ForEach(cardItems) { item in
                HStack {
                  Circle()
                    .fill(item.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                  Text(item.title)
                    .font(.headline)
                  Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 3)
              }
            }
            .padding(.horizontal)
          }
          .frame(height: 300)
        }
      }
      
      // MARK: - 交互示例
      ShowcaseSection("交互示例") {
        ShowcaseItem(title: "选择效果") {
          ScrollView {
            LazyVStack(spacing: 15) {
              ForEach(interactiveItems) { item in
                Text(item.title)
                  .padding()
                  .frame(maxWidth: .infinity)
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
            .padding(.horizontal)
          }
          .frame(height: 200)
        }
      }
      
      // MARK: - 列表示例
      ShowcaseSection("列表示例") {
        ShowcaseItem(title: "列表项") {
          ScrollView {
            LazyVStack(spacing: 1) {
              ForEach(listItems) { item in
                HStack {
                  Image(systemName: "circle.fill")
                    .foregroundColor(item.color)
                  Text(item.title)
                  Spacer()
                  Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
              }
            }
          }
          .frame(height: 300)
          .background(Color(.systemGroupedBackground))
        }
      }
      
      // MARK: - 设置示例
      ShowcaseSection("设置示例") {
        ShowcaseItem(title: "设置列表") {
          LazyVStack(spacing: 0) {
            Toggle("通知", isOn: $notifications)
              .padding()
            
            Divider()
            
            Toggle("深色模式", isOn: $darkMode)
              .padding()
            
            Divider()
            
            VStack(alignment: .leading) {
              Text("音量")
              Slider(value: $volume)
            }
            .padding()
          }
          .background(Color(.systemBackground))
          .cornerRadius(12)
        }
      }
    }
    .navigationTitle("延迟垂直布局示例")
  }
}

// MARK: - 辅助扩展
extension Color {
  static var randomLazy: Color {
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
    LazyVStackDemoView()
  }
}
