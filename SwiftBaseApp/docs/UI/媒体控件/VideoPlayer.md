# VideoPlayer 视频播放控件

## 1. 基本介绍

### 控件概述

VideoPlayer 是 SwiftUI 提供的视频播放控件，用于在应用中播放视频内容。它支持本地和远程视频源，并提供基本的播放控制功能。

### 使用场景

- 播放本地视频文件
- 播放网络视频流
- 视频教程应用
- 媒体播放器
- 视频预览

### 主要特性

- 支持多种视频格式
- 自动播放控制
- 全屏播放支持
- 自定义控制界面
- 播放状态监控
- AirPlay 支持

## 2. 基础用法

### 基本示例

```swift
import SwiftUI
import AVKit

struct BasicVideoPlayer: View {
    var body: some View {
        VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: "video", withExtension: "mp4")!))
            .frame(height: 300)
    }
}
```

### 常用属性

- `player`: AVPlayer 实例，用于控制视频播放
- `videoOverlay`: 自定义覆盖视图
- `controlsStyle`: 控制器样式

## 3. 样式和自定义

### 内置样式

- 默认控制器样式
- 自动隐藏控制器
- 全屏模式样式

### 自定义修饰符

- frame 尺寸设置
- 圆角和阴影效果
- 边框样式

### 主题适配

- 深色模式支持
- 动态类型适配
- 自定义控制器主题

## 4. 高级特性

### 组合使用

- 与其他 SwiftUI 视图组合
- 在列表中使用
- 与导航视图结合

### 动画效果

- 播放过渡动画
- 控制器显示/隐藏动画
- 全屏切换动画

### 状态管理

- 播放状态监控
- 缓冲状态处理
- 错误处理

## 5. 性能优化

### 最佳实践

- 预加载视频
- 资源管理
- 内存优化

### 常见陷阱

- 内存泄漏防范
- 播放状态同步
- 生命周期管理

### 优化技巧

- 按需加载
- 缓存管理
- 后台播放处理

## 6. 辅助功能

### 无障碍支持

- VoiceOver 支持
- 字幕支持
- 辅助功能标签

### 本地化

- 控制器文本本地化
- 方向适配
- 区域设置支持

### 动态类型

- 控制器大小适配
- 字幕大小调整
- 界面缩放处理

## 7. 示例代码

### 基础示例

```swift
import SwiftUI
import AVKit

struct SimpleVideoPlayer: View {
    private let player = AVPlayer(url: URL(string: "https://example.com/video.mp4")!)

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
}
```

### 进阶示例

```swift
struct CustomVideoPlayer: View {
    @State private var isPlaying = false
    private let player: AVPlayer

    init(url: URL) {
        player = AVPlayer(url: url)
    }

    var body: some View {
        VideoPlayer(player: player)
            .overlay(
                Button(action: {
                    isPlaying.toggle()
                    if isPlaying {
                        player.play()
                    } else {
                        player.pause()
                    }
                }) {
                    Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            )
    }
}
```

### 完整 Demo

请参考 VideoPlayerDemoView.swift 中的完整示例代码。

## 8. 注意事项

### 常见问题

1. 视频加载失败处理
2. 网络状态变化处理
3. 后台播放配置
4. 内存管理问题

### 兼容性考虑

- iOS 版本要求
- 设备性能要求
- 网络环境适配
- 格式支持情况

### 使用建议

1. 合理管理视频资源
2. 注意内存占用
3. 处理播放状态
4. 优化用户体验

## 9. 完整运行 Demo

### 源代码

完整的示例代码位于项目的 Features/Media/VideoPlayerDemoView.swift 文件中。

### 运行说明

1. 克隆项目代码
2. 打开 Xcode 项目
3. 运行示例程序
4. 导航到 VideoPlayer 示例页面

### 功能说明

- 基础视频播放
- 自定义控制器
- 全屏播放支持
- 播放状态控制
- 错误处理演示
- 性能优化示例
