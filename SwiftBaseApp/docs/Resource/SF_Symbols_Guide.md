# SF Symbols 图标指南

## 概述

SF Symbols 是苹果公司为 iOS、macOS、watchOS 和 tvOS 设计的图标库，提供了超过 5,000 个可配置的符号。这些图标与系统字体完美集成，支持多种重量、尺寸和颜色变体。

## 基本使用

### SwiftUI 中使用

```swift
import SwiftUI

struct IconExampleView: View {
    var body: some View {
        VStack(spacing: 20) {
            // 基本用法
            Image(systemName: "heart")

            // 设置颜色和大小
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
                .font(.largeTitle)

            // 使用字体配置
            Image(systemName: "star")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.yellow)
        }
    }
}
```

### UIKit 中使用

```swift
import UIKit

// 创建 SF Symbol 图像
let heartImage = UIImage(systemName: "heart")
let filledHeartImage = UIImage(systemName: "heart.fill")

// 配置图像
let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
let configuredImage = UIImage(systemName: "star", withConfiguration: configuration)
```

## 常用图标分类

### 1. 通信和联系

| 图标名称          | 显示 | 用途     |
| ----------------- | ---- | -------- |
| `phone`           | 📞   | 电话     |
| `phone.fill`      | 📞   | 填充电话 |
| `message`         | 💬   | 短信     |
| `message.fill`    | 💬   | 填充短信 |
| `envelope`        | ✉️   | 邮件     |
| `envelope.fill`   | ✉️   | 填充邮件 |
| `paperplane`      | ✈️   | 发送     |
| `paperplane.fill` | ✈️   | 填充发送 |

### 2. 导航和方向

| 图标名称        | 显示 | 用途   |
| --------------- | ---- | ------ |
| `chevron.left`  | ◀    | 左箭头 |
| `chevron.right` | ▶    | 右箭头 |
| `chevron.up`    | 🔼   | 上箭头 |
| `chevron.down`  | 🔽   | 下箭头 |
| `arrow.left`    | ←    | 返回   |
| `arrow.right`   | →    | 前进   |
| `arrow.up`      | ↑    | 向上   |
| `arrow.down`    | ↓    | 向下   |

### 3. 界面控制

| 图标名称              | 显示 | 用途      |
| --------------------- | ---- | --------- |
| `plus`                | ➕   | 添加      |
| `minus`               | ➖   | 减少      |
| `multiply`            | ✖️   | 关闭/删除 |
| `checkmark`           | ✅   | 确认      |
| `xmark`               | ❌   | 取消      |
| `gear`                | ⚙️   | 设置      |
| `slider.horizontal.3` | 🎚️   | 调整      |

### 4. 多媒体

| 图标名称       | 显示 | 用途       |
| -------------- | ---- | ---------- |
| `play`         | ▶️   | 播放       |
| `play.fill`    | ▶️   | 填充播放   |
| `pause`        | ⏸️   | 暂停       |
| `pause.fill`   | ⏸️   | 填充暂停   |
| `stop`         | ⏹️   | 停止       |
| `stop.fill`    | ⏹️   | 填充停止   |
| `speaker`      | 🔊   | 扬声器     |
| `speaker.fill` | 🔊   | 填充扬声器 |
| `camera`       | 📷   | 摄像头     |
| `camera.fill`  | 📷   | 填充摄像头 |
| `video`        | 📹   | 视频       |
| `video.fill`   | 📹   | 填充视频   |

### 5. 文档和文件

| 图标名称        | 显示 | 用途         |
| --------------- | ---- | ------------ |
| `doc`           | 📄   | 文档         |
| `doc.fill`      | 📄   | 填充文档     |
| `doc.text`      | 📃   | 文本文档     |
| `doc.text.fill` | 📃   | 填充文本文档 |
| `folder`        | 📁   | 文件夹       |
| `folder.fill`   | 📁   | 填充文件夹   |
| `trash`         | 🗑️   | 垃圾桶       |
| `trash.fill`    | 🗑️   | 填充垃圾桶   |

### 6. 社交和互动

| 图标名称              | 显示 | 用途      |
| --------------------- | ---- | --------- |
| `heart`               | ❤️   | 喜欢      |
| `heart.fill`          | ❤️   | 填充喜欢  |
| `star`                | ⭐   | 星星/收藏 |
| `star.fill`           | ⭐   | 填充星星  |
| `hand.thumbsup`       | 👍   | 点赞      |
| `hand.thumbsup.fill`  | 👍   | 填充点赞  |
| `share`               | 📤   | 分享      |
| `square.and.arrow.up` | 📤   | 导出/分享 |

### 7. 系统和设备

| 图标名称                            | 显示 | 用途        |
| ----------------------------------- | ---- | ----------- |
| `iphone`                            | 📱   | iPhone      |
| `ipad`                              | 📱   | iPad        |
| `macbook`                           | 💻   | MacBook     |
| `applewatch`                        | ⌚   | Apple Watch |
| `airpods`                           | 🎧   | AirPods     |
| `battery`                           | 🔋   | 电池        |
| `wifi`                              | 📶   | WiFi        |
| `antenna.radiowaves.left.and.right` | 📶   | 信号        |

### 8. 天气和时间

| 图标名称     | 显示 | 用途     |
| ------------ | ---- | -------- |
| `sun.max`    | ☀️   | 晴天     |
| `cloud`      | ☁️   | 多云     |
| `cloud.rain` | 🌧️   | 雨天     |
| `snow`       | ❄️   | 雪天     |
| `clock`      | 🕐   | 时钟     |
| `clock.fill` | 🕐   | 填充时钟 |
| `calendar`   | 📅   | 日历     |
| `timer`      | ⏲️   | 计时器   |

### 9. 购物和商务

| 图标名称            | 显示 | 用途       |
| ------------------- | ---- | ---------- |
| `cart`              | 🛒   | 购物车     |
| `cart.fill`         | 🛒   | 填充购物车 |
| `creditcard`        | 💳   | 信用卡     |
| `creditcard.fill`   | 💳   | 填充信用卡 |
| `bag`               | 🛍️   | 购物袋     |
| `bag.fill`          | 🛍️   | 填充购物袋 |
| `dollarsign.circle` | 💰   | 美元符号   |

### 10. 健康和运动

| 图标名称            | 显示 | 用途        |
| ------------------- | ---- | ----------- |
| `figure.walk`       | 🚶   | 走路        |
| `figure.run`        | 🏃   | 跑步        |
| `heart.text.square` | ❤️   | 健康        |
| `bed.double`        | 🛏️   | 睡眠        |
| `drop`              | 💧   | 水滴        |
| `flame`             | 🔥   | 火焰/卡路里 |

## 图标配置选项

### 1. 权重 (Weight)

```swift
Image(systemName: "heart")
    .font(.system(size: 30, weight: .ultraLight))  // 超细
    .font(.system(size: 30, weight: .thin))        // 细
    .font(.system(size: 30, weight: .light))       // 轻
    .font(.system(size: 30, weight: .regular))     // 常规
    .font(.system(size: 30, weight: .medium))      // 中等
    .font(.system(size: 30, weight: .semibold))    // 半粗
    .font(.system(size: 30, weight: .bold))        // 粗体
    .font(.system(size: 30, weight: .heavy))       // 重
    .font(.system(size: 30, weight: .black))       // 超重
```

### 2. 大小 (Size)

```swift
Image(systemName: "star")
    .font(.caption2)     // 最小
    .font(.caption)      // 标题
    .font(.footnote)     // 脚注
    .font(.callout)      // 引用
    .font(.subheadline)  // 副标题
    .font(.headline)     // 标题
    .font(.body)         // 正文
    .font(.title3)       // 标题3
    .font(.title2)       // 标题2
    .font(.title)        // 标题1
    .font(.largeTitle)   // 大标题
```

### 3. 颜色配置

```swift
Image(systemName: "heart")
    .foregroundColor(.red)                    // 单色
    .symbolRenderingMode(.multicolor)         // 多色模式
    .symbolRenderingMode(.hierarchical)       // 层次模式
    .symbolRenderingMode(.palette)            // 调色板模式
```

### 4. 符号变体

```swift
// 填充变体
Image(systemName: "heart.fill")

// 圆圈变体
Image(systemName: "heart.circle")
Image(systemName: "heart.circle.fill")

// 方形变体
Image(systemName: "heart.square")
Image(systemName: "heart.square.fill")
```

## 动态图标

### 1. 动画支持

```swift
struct AnimatedIconView: View {
    @State private var isAnimating = false

    var body: some View {
        Image(systemName: "heart.fill")
            .foregroundColor(.red)
            .scaleEffect(isAnimating ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}
```

### 2. 状态切换

```swift
struct ToggleIconView: View {
    @State private var isLiked = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isLiked.toggle()
            }
        }) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : .gray)
                .font(.title)
        }
    }
}
```

## 实际应用示例

### 1. 导航栏

```swift
struct NavigationExample: View {
    var body: some View {
        NavigationView {
            Text("Content")
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {}) {
                            Image(systemName: "line.horizontal.3")
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
    }
}
```

### 2. 标签栏

```swift
struct TabBarExample: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("首页")
                }

            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("搜索")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("我的")
                }
        }
    }
}
```

### 3. 列表项

```swift
struct ListItemExample: View {
    var body: some View {
        List {
            HStack {
                Image(systemName: "doc.text")
                    .foregroundColor(.blue)
                    .frame(width: 30)

                VStack(alignment: .leading) {
                    Text("文档标题")
                        .font(.headline)
                    Text("文档描述")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding(.vertical, 4)
        }
    }
}
```

## 最佳实践

### 1. 图标选择

- **保持一致性**：在整个应用中使用相同风格的图标
- **语义明确**：选择能清晰表达功能的图标
- **文化适应**：考虑不同地区用户的理解习惯

### 2. 尺寸规范

- **最小尺寸**：确保图标在最小尺寸下仍然清晰可辨
- **缩放比例**：与文本大小保持协调
- **触摸区域**：确保可交互图标有足够的触摸区域（至少 44x44 pt）

### 3. 颜色使用

- **品牌色彩**：使用符合应用主题的颜色
- **对比度**：确保图标与背景有足够的对比度
- **无障碍**：考虑色盲用户的需求

### 4. 动画效果

- **适度使用**：避免过度动画影响用户体验
- **性能考虑**：复杂动画可能影响性能
- **用户偏好**：尊用用户的动画偏好设置

## 版本兼容性

### iOS 版本支持

- **iOS 13+**：SF Symbols 1.0 (1,500+ 图标)
- **iOS 14+**：SF Symbols 2.0 (3,000+ 图标)
- **iOS 15+**：SF Symbols 3.0 (4,000+ 图标)
- **iOS 16+**：SF Symbols 4.0 (5,000+ 图标)

### 向后兼容

```swift
// 检查图标可用性
func createIcon(systemName: String, fallback: String) -> Image {
    if #available(iOS 14.0, *) {
        return Image(systemName: systemName)
    } else {
        return Image(systemName: fallback)
    }
}
```

## 工具和资源

### 1. SF Symbols 应用

苹果提供了 SF Symbols 桌面应用，可以：

- 浏览所有可用图标
- 预览不同权重和尺寸
- 复制图标名称
- 导出自定义图标

### 2. 在线资源

- [SF Symbols 官方页面](https://developer.apple.com/sf-symbols/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SF Symbols 图标搜索网站](https://sfsymbols.com/)

### 3. 开发工具

```swift
// 调试工具：打印所有可用图标
func printAvailableSymbols() {
    // 注意：这只是示例，实际开发中需要使用相应的 API
    print("Available SF Symbols in current iOS version")
}
```

## 常见问题

### Q: 如何知道某个图标是否在当前 iOS 版本中可用？

A: 可以使用 `UIImage(systemName:)` 返回值检查，如果返回 `nil` 则图标不可用。

```swift
if UIImage(systemName: "heart.circle.fill") != nil {
    // 图标可用
} else {
    // 使用备用图标
}
```

### Q: 自定义图标如何与 SF Symbols 集成？

A: 可以创建符合 SF Symbols 设计规范的自定义符号，并导入到项目中。

### Q: 如何处理动态类型？

A: SF Symbols 会自动适应动态类型设置：

```swift
Image(systemName: "heart")
    .font(.body) // 会根据用户的动态类型设置自动调整
```

---

_本文档基于 iOS 16+ 和 SF Symbols 4.0 编写，部分功能在较早版本中可能不可用。_
