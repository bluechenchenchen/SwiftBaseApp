<!--
 * @Author: blue
 * @Date: 2025-08-26 09:25:42
 * @FilePath: /iPhoneBaseApp/docs/demoView模版.md
-->

## 颜色

### 基础颜色

蓝色: `.blue`  
绿色: `.green`
红色: `.red`
紫色: `.purple`
橙色: `.orange`
粉色: `.pink`
棕色: `.brown`
青色: `.cyan`
靛蓝: `.indigo`
黄色: `.yellow`
薄荷绿: `.mint`
蓝绿: `.teal`

### 语义颜色

次要色: `.secondary`
强调色: `.accentColor`
主要色: `.primary`

### 系统颜色

黑色: `.black`
白色: `.white`
灰色: `.gray`
透明: `.clear`

### 设置背景色

```swift
.background(Color.purple.opacity(0.1))
```

### 颜色透明度

```swift
Color.blue.opacity(0.5)  // 50%透明度
Color.red.opacity(0.8)   // 80%透明度
```

### 随机颜色

```swift
extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
```

### 系统背景色

```swift
Color(.systemBackground)           // 系统背景色
Color(.systemGroupedBackground)   // 分组背景色
Color(.systemGray)                // 系统灰色
Color(.systemGray2)               // 系统灰色2
Color(.systemGray3)               // 系统灰色3
Color(.systemGray4)               // 系统灰色4
Color(.systemGray5)               // 系统灰色5
Color(.systemGray6)               // 系统灰色6
```

## List 组件 Padding 调整

### 1. 调整单个 List Item 的 Padding

```swift
// 使用 listRowInsets 调整单个项目的内边距
Text("自定义内边距的项目")
    .listRowInsets(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))

// 调整特定项目的背景色
Text("自定义背景的项目")
    .listRowBackground(Color.blue.opacity(0.1))

// 调整项目间距
Text("增加间距的项目")
    .listRowSpacing(20)

// 隐藏分隔线
Text("无分隔线的项目")
    .listRowSeparator(.hidden)

// 自定义分隔线颜色
Text("红色分隔线的项目")
    .listRowSeparatorTint(.red)
```

### 2. 调整整个 List 的 Padding

```swift
List {
    // List 内容
}
.listStyle(.plain)  // 设置列表样式
.listRowSpacing(10) // 设置所有行的间距
```

### 3. 调整 Section 的 Padding

```swift
List {
    Section("分组标题") {
        Text("分组内容1")
        Text("分组内容2")
    }
    .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
}
```

### 4. 完整的 List Padding 调整示例

```swift
struct ListPaddingDemoView: View {
    var body: some View {
        List {
            // 基础项目
            Text("基础项目")
                .padding(.vertical, 8)

            // 自定义内边距的项目
            Text("自定义内边距")
                .listRowInsets(EdgeInsets(top: 15, leading: 30, bottom: 15, trailing: 30))
                .listRowBackground(Color.green.opacity(0.1))

            // 增加间距的项目
            Text("增加间距")
                .listRowSpacing(25)
                .listRowBackground(Color.blue.opacity(0.1))

            // 无分隔线的项目
            Text("无分隔线")
                .listRowSeparator(.hidden)
                .listRowBackground(Color.orange.opacity(0.1))

            // 自定义分隔线
            Text("红色分隔线")
                .listRowSeparatorTint(.red)
                .listRowBackground(Color.purple.opacity(0.1))
        }
        .listStyle(.insetGrouped)
        .listRowSpacing(5) // 设置默认行间距
    }
}
```

### 5. 常用的 Padding 值

```swift
// 紧凑间距
.listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))

// 标准间距
.listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))

// 宽松间距
.listRowInsets(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))

// 大间距
.listRowInsets(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
```

### 6. 在 ShowcaseItem 中使用 Padding

```swift
ShowcaseItem(title: "自定义Padding示例") {
    VStack(spacing: 16) {
        Text("内容1")
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)

        Text("内容2")
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(8)
    }
}
.listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
.listRowBackground(Color.gray.opacity(0.05))
```

```swift
struct TextDemoView: View {
  var body: some View {
    ShowcaseList {
       // MARK: - 基础文本
       ShowcaseSection("基础文本") {
         ShowcaseItem(title: "普通文本") {
          // 这里放具体的内容，比如：
            VStack(spacing: 20) {
             Group {
               Text("左对齐")
                   .font(.headline)
               Text("这是一段较长的文本，用来演示左对齐效果。这是第二行文本，可以更好地看到对齐效果。")
                   .frame(maxWidth: .infinity)
                   .padding()
                   .background(Color.blue.opacity(0.1))
                   .cornerRadius(10)
                   .multilineTextAlignment(.leading)
           }

           Group {
               Text("居中对齐")
                   .font(.headline)
               Text("这是一段较长的文本，用来演示居中对齐效果。这是第二行文本，可以更好地看到对齐效果。")
                   .frame(maxWidth: .infinity)
                   .padding()
                   .background(Color.purple.opacity(0.1))
                   .cornerRadius(10)
                   .multilineTextAlignment(.center)
           }
           }


          Text("这里是一段对ShowcaseItem内容的补充说明，有即显示")
             .font(.caption)
             .foregroundStyle(.secondary)
          }

         ShowcaseItem(title: "日期格式化") {
             VStack(spacing: 16) {
                 Text("日期格式化样式")
                     .font(.headline)
                     .frame(maxWidth: .infinity, alignment: .center)

                 VStack(spacing: 12) {
                     Group {
                         HStack {
                             Text("日期格式")
                                 .font(.subheadline)
                                 .foregroundStyle(.secondary)
                             Spacer()
                             Text(selectedDate, style: .date)
                                 .font(.body)
                         }

                         HStack {
                             Text("时间格式")
                                 .font(.subheadline)
                                 .foregroundStyle(.secondary)
                             Spacer()
                             Text(selectedDate, style: .time)
                                 .font(.body)
                         }

                         HStack {
                             Text("相对格式")
                                 .font(.subheadline)
                                 .foregroundStyle(.secondary)
                             Spacer()
                             Text(selectedDate, style: .relative)
                                 .font(.body)
                         }

                         HStack {
                             Text("计时格式")
                                 .font(.subheadline)
                                 .foregroundStyle(.secondary)
                             Spacer()
                             Text(selectedDate, style: .timer)
                                 .font(.body)
                         }
                     }
                     .padding()
                     .background(Color.purple.opacity(0.1))
                     .cornerRadius(10)
                 }
             }
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

        // .....
      }.navigationTitle("xxx示例")
    }

}
```
