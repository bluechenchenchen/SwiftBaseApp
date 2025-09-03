# SwiftUI Image 控件完整指南

## 1. 基础用法

### 1.1 创建图片

```swift
// 从资源加载图片
Image("imageName")

// 使用系统图标
Image(systemName: "star.fill")

// 从 UIImage 创建
let uiImage = UIImage(named: "photo")
Image(uiImage: uiImage!)

// 从 Data 创建
let imageData = Data() // 图片数据
if let uiImage = UIImage(data: imageData) {
    Image(uiImage: uiImage)
}

// 从 URL 加载（异步）
AsyncImage(url: URL(string: "https://example.com/image.jpg"))
```

### 1.2 调整大小和缩放

```swift
// 允许调整大小
Image("photo")
    .resizable()

// 设置固定尺寸
Image("photo")
    .resizable()
    .frame(width: 100, height: 100)

// 保持宽高比
Image("photo")
    .resizable()
    .aspectRatio(contentMode: .fit)  // 适应
    .aspectRatio(contentMode: .fill) // 填充

// 设置宽高比
Image("photo")
    .resizable()
    .aspectRatio(16/9, contentMode: .fit)

// 缩放到适应
Image("photo")
    .resizable()
    .scaledToFit()

// 缩放到填充
Image("photo")
    .resizable()
    .scaledToFill()
```

## 2. 样式修饰

### 2.1 基础样式

```swift
// 设置前景色
Image(systemName: "star.fill")
    .foregroundStyle(.yellow)

// 设置背景色
Image("photo")
    .background(.blue)

// 设置透明度
Image("photo")
    .opacity(0.5)

// 设置混合模式
Image("photo")
    .blendMode(.multiply)

// 设置亮度/对比度
Image("photo")
    .brightness(0.2)
    .contrast(1.2)

// 设置饱和度
Image("photo")
    .saturation(1.5)

// 设置色调
Image("photo")
    .hueRotation(.degrees(45))
```

### 2.2 形状修饰

```swift
// 圆形裁剪
Image("photo")
    .clipShape(Circle())

// 圆角矩形
Image("photo")
    .cornerRadius(10)

// 自定义形状裁剪
Image("photo")
    .clipShape(
        RoundedRectangle(cornerRadius: 10, style: .continuous)
    )

// 添加边框
Image("photo")
    .border(Color.blue, width: 2)

// 添加描边
Image("photo")
    .overlay(
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 2)
    )

// 添加阴影
Image("photo")
    .shadow(color: .gray, radius: 5, x: 0, y: 2)
```

### 2.3 特殊效果

```swift
// 反转颜色
Image("photo")
    .colorInvert()

// 灰度处理
Image("photo")
    .grayscale(1.0)

// 模糊效果
Image("photo")
    .blur(radius: 5)

// 高斯模糊
Image("photo")
    .blur(radius: 5, opaque: true)

// 蒙版效果
Image("photo")
    .mask(
        LinearGradient(
            gradient: Gradient(colors: [.black, .clear]),
            startPoint: .top,
            endPoint: .bottom
        )
    )
```

## 3. 高级用法

### 3.1 异步图片加载

```swift
// 基本异步加载
AsyncImage(url: URL(string: "https://example.com/image.jpg"))

// 带占位图的异步加载
AsyncImage(url: URL(string: "https://example.com/image.jpg")) { image in
    image
        .resizable()
        .scaledToFit()
} placeholder: {
    ProgressView()
}

// 完整的异步加载处理
AsyncImage(url: URL(string: "https://example.com/image.jpg")) { phase in
    switch phase {
    case .empty:
        ProgressView()
    case .success(let image):
        image
            .resizable()
            .scaledToFit()
    case .failure(let error):
        Image(systemName: "exclamationmark.triangle")
            .foregroundStyle(.red)
    @unknown default:
        EmptyView()
    }
}
```

### 3.2 SF Symbols 使用

```swift
// 基本使用
Image(systemName: "star.fill")

// 设置符号变体
Image(systemName: "star.fill")
    .symbolVariant(.circle)

// 设置渲染模式
Image(systemName: "star.fill")
    .symbolRenderingMode(.multicolor)

// 设置符号大小
Image(systemName: "star.fill")
    .imageScale(.large)

// 自定义符号配置
Image(systemName: "star.fill")
    .font(.system(size: 24, weight: .bold))

// 符号动画
Image(systemName: "star.fill")
    .symbolEffect(.bounce)
```

### 3.3 图片组合

```swift
// 叠加图片
ZStack {
    Image("background")
        .resizable()
        .scaledToFill()
    Image("overlay")
        .resizable()
        .scaledToFit()
        .frame(width: 100)
}

// 使用遮罩
Image("photo")
    .mask(
        Image(systemName: "star.fill")
            .resizable()
    )

// 图片和文字组合
Label("收藏", systemImage: "star.fill")
```

## 4. 性能优化

### 4.1 图片缓存

```swift
// 使用 NSCache 缓存图片
class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}

// 使用缓存的图片加载视图
struct CachedImageView: View {
    let url: URL
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }

    private func loadImage() {
        let cacheKey = url.absoluteString
        if let cachedImage = ImageCache.shared.get(forKey: cacheKey) {
            image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let downloadedImage = UIImage(data: data) {
                ImageCache.shared.set(downloadedImage, forKey: cacheKey)
                DispatchQueue.main.async {
                    image = downloadedImage
                }
            }
        }.resume()
    }
}
```

### 4.2 图片预加载

```swift
struct ImagePreloader {
    static func preloadImages(_ urls: [URL]) {
        urls.forEach { url in
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data,
                   let image = UIImage(data: data) {
                    ImageCache.shared.set(image, forKey: url.absoluteString)
                }
            }.resume()
        }
    }
}
```

## 5. 辅助功能支持

```swift
// 添加图片描述
Image("photo")
    .accessibilityLabel("一张风景照片")

// 添加图片提示
Image("photo")
    .accessibilityHint("双击可以放大查看")

// 隐藏装饰性图片
Image("decoration")
    .accessibilityHidden(true)

// 组合图片的无障碍描述
HStack {
    Image(systemName: "star.fill")
    Text("收藏")
}
.accessibilityElement(children: .combine)
.accessibilityLabel("收藏按钮")
```

## 6. 常见用例

### 6.1 头像视图

```swift
struct AvatarView: View {
    let image: Image
    let size: CGFloat

    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(radius: 5)
    }
}
```

### 6.2 图片卡片

```swift
struct ImageCard: View {
    let image: Image
    let title: String

    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.5)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .padding()
        }
        .background(Color.black)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
```

### 6.3 图片网格

```swift
struct ImageGrid: View {
    let images: [Image]
    let columns: Int

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: columns), spacing: 8) {
            ForEach(0..<images.count, id: \.self) { index in
                images[index]
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
    }
}
```

## 7. 注意事项

1. 图片资源管理

   - 使用适当的图片格式（PNG/JPEG）
   - 提供多种分辨率的图片资源
   - 注意图片大小和内存占用

2. 性能考虑

   - 合理使用图片缓存
   - 避免加载过大的图片
   - 使用异步加载处理网络图片

3. 布局注意事项

   - 正确处理图片缩放模式
   - 注意图片裁剪和溢出
   - 处理好图片加载状态

4. 辅助功能
   - 为重要图片提供描述文本
   - 隐藏装饰性图片
   - 确保足够的对比度

## 8. 完整运行 Demo

将以下代码复制到新的 SwiftUI 项目中即可运行：

```swift
import SwiftUI

// MARK: - 基础图片示例
struct BasicImageExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("1. 基础图片示例").font(.title)

            Group {
                // 系统图标
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.yellow)

                // 本地图片（需要在Assets中添加图片）
                Image("photo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)

                // 异步加载网络图片
                AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
            }
        }
    }
}

// MARK: - 图片样式示例
struct ImageStyleExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("2. 图片样式示例").font(.title)

            HStack(spacing: 20) {
                // 圆形图片
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.blue)

                // 带边框的图片
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                // 带阴影的图片
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.yellow)
                    .shadow(color: .gray, radius: 5, x: 0, y: 2)
            }
        }
    }
}

// MARK: - SF Symbols示例
struct SFSymbolsExampleView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("3. SF Symbols示例").font(.title)

            HStack(spacing: 20) {
                // 基本图标
                Image(systemName: "heart.fill")
                    .foregroundStyle(.red)
                    .font(.title)

                // 变体图标
                Image(systemName: "star.fill")
                    .symbolVariant(.circle)
                    .foregroundStyle(.yellow)
                    .font(.title)

                // 动画图标
                Image(systemName: "bell.fill")
                    .font(.title)
                    .symbolEffect(.bounce, value: isAnimating)
                    .onTapGesture {
                        isAnimating.toggle()
                    }
            }
        }
    }
}

// MARK: - 图片效果示例
struct ImageEffectsExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("4. 图片效果示例").font(.title)

            HStack(spacing: 20) {
                // 模糊效果
                Image(systemName: "cloud.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.blue)
                    .blur(radius: 2)

                // 透明度渐变
                Image(systemName: "moon.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.purple)
                    .opacity(0.7)

                // 颜色叠加
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.orange)
                    .overlay(
                        Circle()
                            .stroke(Color.red, lineWidth: 2)
                    )
            }
        }
    }
}

// MARK: - 图片组合示例
struct ImageCombinationExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("5. 图片组合示例").font(.title)

            HStack(spacing: 20) {
                // 图片和文字组合
                Label("收藏", systemImage: "star.fill")
                    .font(.title2)
                    .foregroundStyle(.yellow)

                // 叠加图片
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 60, height: 60)

                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

// MARK: - 主视图
struct ImageDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                BasicImageExampleView()
                ImageStyleExampleView()
                SFSymbolsExampleView()
                ImageEffectsExampleView()
                ImageCombinationExampleView()

                // 实用组件展示
                VStack(alignment: .leading, spacing: 20) {
                    Text("6. 实用组件示例").font(.title)

                    HStack(spacing: 20) {
                        // 头像示例
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.blue)
                            .background(Circle().fill(Color.blue.opacity(0.2)))

                        // 图片卡片示例
                        VStack {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .frame(width: 100, height: 80)
                                .foregroundStyle(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray)
                                )

                            Text("示例图片")
                                .font(.caption)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Image 控件 Demo")
    }
}

// MARK: - 预览
#Preview {
    NavigationView {
        ImageDemoView()
    }
}
```

### 运行说明

1. 创建新的 SwiftUI 项目
2. 创建新文件，命名为`ImageDemoView.swift`
3. 将上述代码复制到文件中
4. 在项目的入口文件（通常是`XXXApp.swift`）中设置根视图：

```swift
import SwiftUI

@main
struct ImageDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ImageDemoView()
            }
        }
    }
}
```

### Demo 包含功能

1. 基础图片示例

   - 系统图标
   - 本地图片
   - 网络图片

2. 图片样式示例

   - 圆形图片
   - 带边框的图片
   - 带阴影的图片

3. SF Symbols 示例

   - 基本图标
   - 变体图标
   - 动画图标

4. 图片效果示例

   - 模糊效果
   - 透明度渐变
   - 颜色叠加

5. 图片组合示例

   - 图片和文字组合
   - 叠加图片

6. 实用组件示例
   - 头像组件
   - 图片卡片

### 注意事项

1. Demo 包含了 ScrollView，适合在真机上滚动查看所有示例
2. 所有示例都有清晰的分组和标题
3. 包含了交互示例（如动画图标）
4. 适配了深色模式
5. 支持动态字体大小
6. 添加了导航标题和层级
