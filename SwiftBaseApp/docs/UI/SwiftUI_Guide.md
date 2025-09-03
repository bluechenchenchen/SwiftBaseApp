# SwiftUI 零基础入门指南

## 目录

- [什么是 SwiftUI？](#什么是-swiftui)
- [开发环境准备](#开发环境准备)
- [第一个 SwiftUI 应用](#第一个-swiftui-应用)
- [基础组件](#基础组件)
- [布局系统](#布局系统)
- [状态管理](#状态管理)
- [导航系统](#导航系统)
- [进阶主题](#进阶主题)

## 什么是 SwiftUI？

### 简介

SwiftUI 是苹果公司在 2019 年推出的新一代 UI 框架，用于构建 iOS、macOS、watchOS 和 tvOS 应用程序的用户界面。

### 为什么选择 SwiftUI？

1. **更简单的语法**

   - 声明式编程风格
   - 代码更少，更直观
   - 实时预览功能

2. **跨平台支持**

   - 一套代码运行在多个苹果平台
   - 统一的开发体验

3. **现代化特性**
   - 自动深色模式支持
   - 动态字体支持
   - 内置动画系统

## 开发环境准备

### 必要条件

1. **硬件要求**

   - Mac 电脑（必需）
   - 运行 macOS Monterey 或更新版本

2. **软件要求**
   - Xcode 13 或更新版本（从 App Store 下载）
   - iOS 15.0+ 模拟器或实机

### 创建第一个项目

1. 打开 Xcode
2. 选择 "Create a new Xcode project"
3. 选择 "App" 模板
4. 选择 "SwiftUI" 作为界面
5. 填写项目信息：
   - Product Name: 项目名称
   - Organization Identifier: 组织标识符
   - Interface: SwiftUI
   - Language: Swift

## 第一个 SwiftUI 应用

### 1. 基本结构

```swift
// 1. 导入 SwiftUI 框架
import SwiftUI

// 2. 创建视图结构体
struct ContentView: View {
    // 3. 实现必需的 body 属性
    var body: some View {
        // 4. 返回视图内容
        Text("Hello, World!")
    }
}

// 5. 创建预览
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

### 2. 视图基础概念

```swift
struct BasicView: View {
    // @State 用于声明可变状态
    @State private var name = "SwiftUI"

    var body: some View {
        // VStack 垂直排列多个视图
        VStack {
            // Text 显示文本
            Text("你好，\(name)！")
                // 修饰符：改变文本样式
                .font(.title)        // 设置字体
                .foregroundColor(.blue)  // 设置颜色
                .padding()          // 添加内边距

            // Button 创建按钮
            Button("点击我") {
                // 按钮点击事件
                name = "新名字"
            }
        }
    }
}
```

## 基础组件

### 1. 文本组件（Text）

```swift
// 基本文本
Text("Hello, World!")

// 样式修饰
Text("标题文本")
    .font(.title)          // 字体大小
    .bold()               // 加粗
    .italic()             // 斜体
    .foregroundColor(.blue) // 文字颜色
    .padding()            // 内边距

// 多行文本
Text("""
第一行
第二行
第三行
""")

// 文本组合
Text("Hello")
    + Text(", ")
    + Text("World!")
    .foregroundColor(.blue)
```

### 2. 图片组件（Image）

```swift
// 从资源加载图片
Image("图片名称")
    .resizable()           // 允许调整大小
    .aspectRatio(contentMode: .fit)  // 保持比例
    .frame(width: 200, height: 200)  // 设置尺寸

// 系统图标
Image(systemName: "star.fill")
    .font(.largeTitle)
    .foregroundColor(.yellow)

// 网络图片（需要额外配置）
AsyncImage(url: URL(string: "https://example.com/image.jpg")) { image in
    image
        .resizable()
        .aspectRatio(contentMode: .fit)
} placeholder: {
    ProgressView()
}
```

### 3. 按钮组件（Button）

```swift
// 基本按钮
Button("点击我") {
    print("按钮被点击")
}

// 自定义样式按钮
Button(action: {
    print("按钮被点击")
}) {
    HStack {
        Image(systemName: "star.fill")
        Text("收藏")
    }
    .padding()
    .background(Color.blue)
    .foregroundColor(.white)
    .cornerRadius(10)
}

// 不同样式的按钮
Button("删除", role: .destructive) {
    // 删除操作
}

Button("取消", role: .cancel) {
    // 取消操作
}
```

### 4. 输入组件

```swift
// 文本输入框
@State private var username = ""
TextField("请输入用户名", text: $username)
    .textFieldStyle(RoundedBorderTextFieldStyle())
    .padding()

// 密码输入框
@State private var password = ""
SecureField("请输入密码", text: $password)
    .textFieldStyle(RoundedBorderTextFieldStyle())
    .padding()

// 开关
@State private var isOn = false
Toggle("开启通知", isOn: $isOn)
    .padding()

// 滑块
@State private var value = 50.0
Slider(value: $value, in: 0...100)
    .padding()
```

## 布局系统

### 1. 基础布局

```swift
// 1. 垂直堆栈（VStack）
VStack(alignment: .leading, spacing: 10) {
    Text("第一行")
    Text("第二行")
    Text("第三行")
}

// 2. 水平堆栈（HStack）
HStack(spacing: 20) {
    Text("左边")
    Text("中间")
    Text("右边")
}

// 3. 深度堆栈（ZStack）- 用于层叠效果
ZStack {
    Color.blue        // 背景
    Text("前景文字")   // 前景
}

// 4. 组合使用
VStack {
    Text("标题").font(.title)

    HStack {
        Image(systemName: "star.fill")
        Text("评分")
    }

    ZStack {
        Color.gray.opacity(0.2)
        Text("内容区域")
    }
}
```

### 2. 常用布局修饰符

```swift
Text("示例文本")
    // 尺寸
    .frame(width: 200, height: 100)  // 固定尺寸
    .frame(maxWidth: .infinity)      // 最大宽度

    // 间距
    .padding()                       // 所有方向添加间距
    .padding(.horizontal, 20)        // 水平方向间距

    // 对齐
    .frame(maxWidth: .infinity, alignment: .leading)  // 左对齐

    // 背景和边框
    .background(Color.blue)          // 背景色
    .cornerRadius(10)                // 圆角
    .border(Color.black, width: 1)   // 边框
```

### 3. 响应式布局

```swift
// 根据设备方向调整布局
@Environment(\.horizontalSizeClass) var sizeClass

var body: some View {
    if sizeClass == .compact {
        // 竖屏布局
        VStack {
            Image("header")
            Text("内容")
        }
    } else {
        // 横屏布局
        HStack {
            Image("header")
            Text("内容")
        }
    }
}
```

## 状态管理

### 1. 基础状态（@State）

```swift
struct CounterView: View {
    // @State 用于简单的视图内状态管理
    @State private var count = 0

    var body: some View {
        VStack {
            Text("计数: \(count)")

            Button("增加") {
                count += 1
            }

            Button("减少") {
                count -= 1
            }
        }
    }
}
```

### 2. 绑定（@Binding）

```swift
// 子视图
struct ToggleButton: View {
    // @Binding 用于接收父视图的状态
    @Binding var isOn: Bool

    var body: some View {
        Button(isOn ? "开" : "关") {
            isOn.toggle()
        }
    }
}

// 父视图
struct ParentView: View {
    @State private var isOn = false

    var body: some View {
        VStack {
            Text(isOn ? "开启" : "关闭")
            // 使用 $ 符号传递绑定
            ToggleButton(isOn: $isOn)
        }
    }
}
```

### 3. 观察对象（@StateObject 和 @ObservedObject）

```swift
// 数据模型
class UserSettings: ObservableObject {
    // @Published 标记需要观察的属性
    @Published var username = ""
    @Published var isLoggedIn = false
}

// 使用观察对象的视图
struct SettingsView: View {
    // @StateObject 用于视图拥有的对象
    @StateObject private var settings = UserSettings()

    var body: some View {
        VStack {
            TextField("用户名", text: $settings.username)

            Toggle("登录状态", isOn: $settings.isLoggedIn)

            Text("当前用户: \(settings.username)")
            Text("登录状态: \(settings.isLoggedIn ? "已登录" : "未登录")")
        }
        .padding()
    }
}
```

## 导航系统

### 1. 基础导航

```swift
// 导航视图
NavigationView {
    List {
        NavigationLink("去详情页") {
            DetailView()
        }

        NavigationLink("去设置页") {
            SettingsView()
        }
    }
    .navigationTitle("首页")
    .navigationBarTitleDisplayMode(.large)
}

// 详情页面
struct DetailView: View {
    var body: some View {
        Text("详情页面内容")
            .navigationTitle("详情")
    }
}
```

### 2. 标签页导航

```swift
TabView {
    HomeView()
        .tabItem {
            Image(systemName: "house.fill")
            Text("首页")
        }

    ProfileView()
        .tabItem {
            Image(systemName: "person.fill")
            Text("我的")
        }

    SettingsView()
        .tabItem {
            Image(systemName: "gear")
            Text("设置")
        }
}
```

## 列表和集合

### 1. 基础列表

```swift
// 简单列表
List {
    Text("项目 1")
    Text("项目 2")
    Text("项目 3")
}

// 动态列表
struct Item: Identifiable {
    let id = UUID()
    let title: String
}

struct ListView: View {
    let items = [
        Item(title: "第一项"),
        Item(title: "第二项"),
        Item(title: "第三项")
    ]

    var body: some View {
        List(items) { item in
            Text(item.title)
        }
    }
}
```

### 2. 分组列表

```swift
List {
    Section(header: Text("第一组")) {
        Text("项目 1.1")
        Text("项目 1.2")
    }

    Section(header: Text("第二组")) {
        Text("项目 2.1")
        Text("项目 2.2")
    }
}
```

## 常见任务示例

### 1. 登录表单

```swift
struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isShowingAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("登录")
                .font(.largeTitle)
                .padding()

            TextField("用户名", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("密码", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("登录") {
                // 登录逻辑
                if username.isEmpty || password.isEmpty {
                    isShowingAlert = true
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .alert("提示", isPresented: $isShowingAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text("用户名和密码不能为空")
        }
    }
}
```

### 2. 图片列表

```swift
struct ImageItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct ImageListView: View {
    let items = [
        ImageItem(title: "图片1", imageName: "photo1"),
        ImageItem(title: "图片2", imageName: "photo2"),
        ImageItem(title: "图片3", imageName: "photo3")
    ]

    var body: some View {
        List(items) { item in
            HStack {
                Image(item.imageName)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)

                Text(item.title)
                    .padding(.leading)

                Spacer()
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("图片列表")
    }
}
```

## 推荐学习资源

### 1. 官方资源

- [SwiftUI 教程](https://developer.apple.com/tutorials/swiftui)
- [SwiftUI 文档](https://developer.apple.com/documentation/swiftui)

### 2. 中文教程

- [SwiftUI 中文手册](https://swiftui.bootcss.com)
- [SwiftGG 翻译组](https://swift.gg)

### 3. 视频教程

- [Stanford CS193p](https://cs193p.sites.stanford.edu)
- [Hacking with Swift](https://www.hackingwithswift.com/swiftui)

### 4. 实践网站

- [SwiftUI Lab](https://swiftui-lab.com)
- [Swift by Sundell](https://www.swiftbysundell.com)
