import SwiftUI

struct GroupDemoView: View {
  // MARK: - 状态属性
  @State private var showExtra = false
  @State private var username = ""
  @State private var password = ""
  @State private var notifications = false
  @State private var location = false
  @State private var selectedTab = 0
  
  let items = ["苹果", "香蕉", "橙子"]
  
  // MARK: - 视图主体
  var body: some View {
    ShowcaseList {
      // MARK: - 基础用法
      ShowcaseSection("基础用法") {
        ShowcaseItem(title: "基本分组") {
          basicUsageExample
        }
      }
      
      // MARK: - 条件渲染
      ShowcaseSection("条件渲染") {
        ShowcaseItem(title: "条件内容展示") {
          conditionalRenderingExample
        }
      }
      
      // MARK: - 列表示例
      ShowcaseSection("列表示例") {
        ShowcaseItem(title: "ForEach 用法") {
          forEachExample
        }
      }
      
      // MARK: - 表单示例
      ShowcaseSection("表单示例") {
        ShowcaseItem(title: "表单布局") {
          formExample
        }
      }
      
      // MARK: - 性能优化
      ShowcaseSection("性能优化") {
        ShowcaseItem(title: "性能优化示例") {
          performanceExample
        }
      }
    }
    .navigationTitle("Group 示例")
  }
  
  // MARK: - 基础用法示例
  private var basicUsageExample: some View {
    VStack(spacing: 20) {
      Group {
        Text("第一行文本")
        Text("第二行文本")
        Text("第三行文本")
      }
      .font(.headline)
      .padding(.vertical, 5)
      
      Group {
        Text("Group 可以对多个视图进行统一样式设置")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
    }
  }
  
  // MARK: - 条件渲染示例
  private var conditionalRenderingExample: some View {
    VStack(spacing: 20) {
      Group {
        if showExtra {
          VStack(spacing: 10) {
            Text("额外的内容 1")
              .foregroundStyle(.blue)
            Text("额外的内容 2")
              .foregroundStyle(.blue)
          }
        } else {
          Text("基本内容")
            .foregroundStyle(.blue)
        }
      }
      .frame(height: 100)
      .padding()
      .background(Color.blue.opacity(0.1))
      .cornerRadius(10)
      
      Button("切换显示") {
        withAnimation(.spring()) {
          showExtra.toggle()
        }
      }
      .buttonStyle(.bordered)
    }
  }
  
  // MARK: - ForEach 示例
  private var forEachExample: some View {
    VStack(spacing: 15) {
      ForEach(items, id: \.self) { item in
        Group {
          VStack(spacing: 8) {
            Text(item)
              .font(.headline)
            Divider()
            Text("描述: \(item)的描述")
              .font(.subheadline)
              .foregroundStyle(.secondary)
          }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
      }
    }
  }
  
  // MARK: - 表单示例
  private var formExample: some View {
    VStack(spacing: 20) {
      // 用户信息分组
      Group {
        VStack(alignment: .leading, spacing: 15) {
          Text("账户信息")
            .font(.headline)
          
          Group {
            TextField("用户名", text: $username)
              .textContentType(.username)
            
            SecureField("密码", text: $password)
              .textContentType(.password)
            
            TextField("电子邮件", text: .constant(""))
              .textContentType(.emailAddress)
              .keyboardType(.emailAddress)
          }
          .textFieldStyle(.roundedBorder)
        }
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(10)
      
      // 通知设置分组
      Group {
        VStack(alignment: .leading, spacing: 15) {
          Text("通知设置")
            .font(.headline)
          
          Toggle("接收通知", isOn: $notifications)
          
          if notifications {
            Group {
              Toggle("接收推送通知", isOn: .constant(true))
              Toggle("接收邮件通知", isOn: .constant(false))
              Toggle("接收短信通知", isOn: .constant(true))
            }
          }
        }
      }
      .padding()
      .background(Color.blue.opacity(0.1))
      .cornerRadius(10)
      
      // 隐私设置分组
      Group {
        VStack(alignment: .leading, spacing: 15) {
          Text("隐私设置")
            .font(.headline)
          
          Toggle("允许定位", isOn: $location)
          
          if location {
            Group {
              Toggle("后台定位", isOn: .constant(false))
              Toggle("精确定位", isOn: .constant(true))
            }
          }
          
          Group {
            Toggle("允许访问相册", isOn: .constant(true))
            Toggle("允许访问相机", isOn: .constant(true))
          }
        }
      }
      .padding()
      .background(Color.green.opacity(0.1))
      .cornerRadius(10)
      
      // 操作按钮分组
      Group {
        VStack(spacing: 10) {
          Button(action: {
            // 保存设置
          }) {
            Text("保存设置")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.borderedProminent)
          
          Button(action: {
            username = ""
            password = ""
            notifications = false
            location = false
          }) {
            Text("重置设置")
              .foregroundStyle(.red)
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.bordered)
        }
      }
      .padding()
    }
  }
  
  // MARK: - 性能优化示例
  private var performanceExample: some View {
    VStack(spacing: 20) {
      // 示例1：使用 Group 优化条件渲染
      Group {
        VStack {
          if selectedTab == 0 {
            VStack(spacing: 15) {
              Image(systemName: "star.fill")
                .font(.largeTitle)
                .foregroundStyle(.yellow)
              
              Text("优化的条件渲染")
                .font(.headline)
              
              Text("使用 Group 包装条件内容，优化渲染性能")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
              
              Button("切换内容") {
                withAnimation(.spring()) {
                  selectedTab = 1
                }
              }
              .buttonStyle(.bordered)
            }
          } else {
            VStack(spacing: 15) {
              Image(systemName: "moon.fill")
                .font(.largeTitle)
                .foregroundStyle(.purple)
              
              Text("替代内容")
                .font(.headline)
              
              Text("Group 帮助管理视图的状态和转场")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
              
              Button("返回") {
                withAnimation(.spring()) {
                  selectedTab = 0
                }
              }
              .buttonStyle(.bordered)
            }
          }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
      }
      
      // 示例2：使用 Group 优化列表性能
      Group {
        VStack(spacing: 10) {
          Text("优化的列表示例")
            .font(.headline)
          
          ForEach(0..<5) { index in
            Group {
              HStack {
                VStack(alignment: .leading) {
                  Text("项目 \(index)")
                    .font(.headline)
                  Text("使用 Group 优化列表项性能")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                  .foregroundStyle(.gray)
              }
              .padding()
              .background(Color.white)
              .cornerRadius(8)
              .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 2)
            }
            
            if index % 2 == 0 {
              Group {
                HStack {
                  Text("推广内容")
                    .foregroundStyle(.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
              }
            }
          }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(15)
      }
    }
  }
}

// MARK: - Preview
struct GroupDemoView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      GroupDemoView()
    }
  }
}
