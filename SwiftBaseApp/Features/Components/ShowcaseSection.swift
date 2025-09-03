import SwiftUI

/// 用于展示单个展示项的组件
public struct ShowcaseItem<Content: View>: View {
  let title: String?
  let backgroundColor: Color?
  let content: Content
  
  public init(title: String, backgroundColor: Color? = nil, @ViewBuilder content: () -> Content) {
    self.title = title
    self.backgroundColor = backgroundColor
    self.content = content()
  }
  
  public init(backgroundColor: Color? = nil, @ViewBuilder content: () -> Content) {
    self.title = nil
    self.backgroundColor = backgroundColor
    self.content = content()
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      if let title = title {
        Text(title)
          .font(.caption)
          .foregroundColor(.secondary)
      }
      VStack {
        content
      }.frame(maxWidth:.infinity).padding(.all,2).background(backgroundColor).cornerRadius(10)
      
    }
    .frame(maxWidth:.infinity)
   
    .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
    // .listRowBackground(Color.clear) // 清除背景色
    .buttonStyle(PlainButtonStyle()) // 禁用按钮样式
    // .contentShape(Rectangle()) // 设置点击区域
    // .allowsHitTesting(false) // 禁用整体点击
  }
}

/// 用于展示整个展示区域的组件
public struct ShowcaseSection<Content: View>: View {
  let title: String
  let content: Content
  
  public init(_ title: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.content = content()
  }
  
  public var body: some View {
    Section {
      content
    } header: {
      Text(title).font(.subheadline).foregroundColor(.primary)
    }
  }
}

// 自定义List
public struct ShowcaseList<Content: View>: View {
  let content: Content
  


  public init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  public var body: some View {
    List {
      content
    }.listRowSpacing(10)
  }
}

// MARK: - 预览
struct ShowcaseSection_Previews: PreviewProvider {
  static var previews: some View {
    ShowcaseList {
      ShowcaseSection("示例Section") {
        ShowcaseItem(title: "示例项") {
          Rectangle()
            .fill(.blue)
            .frame(width: 60, height: 60)
        }
        
        ShowcaseItem(title: "带背景色的示例项", backgroundColor: Color.orange.opacity(0.1)) {
          VStack(alignment:.center) {
            Circle()
              .fill(.red)
              .frame(width: 60, height: 60)
            
            
            Text("这里是一段对ShowcaseItem内容的补充说明，有即显示")
              .font(.caption)
              .foregroundStyle(.secondary)
          }.frame(maxWidth:.infinity).padding(.all,10)
        }
        
        ShowcaseItem(backgroundColor: Color.green.opacity(0.1)) {
          VStack(alignment:.center) {
            RoundedRectangle(cornerRadius: 8)
              .fill(.green)
              .frame(width: 60, height: 60)
            
            Text("这是一个没有标题但有背景色的示例项")
              .font(.caption)
              .foregroundStyle(.secondary)
          }.frame(maxWidth: .infinity).padding(.all,10)
        }
        
      }
    }
  }
}
