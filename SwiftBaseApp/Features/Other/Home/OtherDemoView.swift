import SwiftUI

struct OtherDemoView: View {
  @StateObject private var viewModel = OtherViewModel()
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(Array(viewModel.otherItems.keys).sorted, id: \.self) { type in
          if let items = viewModel.otherItems[type] {
            Section {
              ForEach(items) { item in
                NavigationLink {
                  viewModel.destinationView(for: item)
                } label: {
                  HStack(spacing: 16) {
                    Image(systemName: iconName(for: item))
                      .font(.title2)
                      .foregroundColor(.accentColor)
                      .frame(width: 32)
                    
                    VStack(alignment: .leading, spacing: 4) {
                      Text(item.title)
                        .font(.body)
                        .foregroundColor(.primary)
                      Text(item.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    }
                  }
                  .padding(.vertical, 8)
                }
              }
            } header: {
              HStack {
                Text(type.title)
                  .font(.headline)
                  .foregroundColor(.primary)
                  .textCase(nil)
                Spacer()
                Text("共 \(items.count) 项")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
              .padding(.vertical, 8)
            }
          }
        }
      }
      .listStyle(.insetGrouped)
      .navigationTitle("其他功能")
      .navigationBarTitleDisplayMode(.large)
    }
  }
  
  private func iconName(for item: OtherItem) -> String {
    switch item.type {
    case .tools:
      switch item.title {
      case "代码生成器": return "doc.badge.plus"
      case "调试工具": return "ladybug"
      case "配置管理": return "gearshape"
      default: return "wrench.and.screwdriver"
      }
    case .utilities:
      switch item.title {
      case "日期工具": return "calendar"
      case "字符串工具": return "textformat"
      case "加密工具": return "lock.shield"
      default: return "toolbox"
      }
    case .examples:
      switch item.title {
      case "动画示例": return "sparkles"
      case "手势示例": return "hand.tap"
      case "自定义组件": return "square.3.layers.3d"
      case "修饰符指南": return "slider.horizontal.3"
      default: return "star"
      }
    case .advanced:
      switch item.title {
      case "性能优化": return "speedometer"
      case "内存管理": return "memorychip"
      case "测试策略": return "checkmark.shield"
      default: return "star.circle"
      }
    }
  }
}

#Preview {
  OtherDemoView()
}
