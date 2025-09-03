import SwiftUI



// MARK: - 主视图
struct ImageDemoView: View {
  // MARK: - 状态属性
  @State private var isAnimating = false
  
  var body: some View {
    ShowcaseList {
      // MARK: - 基础图片
      ShowcaseSection("基础图片") {
        // 1. 系统图标
        ShowcaseItem(title: "系统图标", backgroundColor: Color.red.opacity(0.1)) {
          Image(systemName: "star.fill")
            .font(.largeTitle)
            .foregroundStyle(.yellow).padding()
        }
        
        // 2. 本地图片
        ShowcaseItem(title: "本地图片", backgroundColor: Color.green.opacity(0.1)) {
          HStack {
            Image("twinlake")
              .resizable()
              .frame(width: 100, height: 100)
              .cornerRadius(8)
            Spacer()
            VStack(alignment: .leading) {
              Text("本地图片")
                .font(.headline)
              Text("从Assets加载")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
          }.padding()
        }
        
        // 3. 网络图片
        ShowcaseItem(title: "网络图片", backgroundColor: Color.gray.opacity(0.1)) {
          HStack {
            AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
              image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .cornerRadius(8)
            } placeholder: {
              ProgressView()
                .frame(width: 100, height: 100)
            }
            Spacer()
            VStack(alignment: .leading) {
              Text("异步加载")
                .font(.headline)
              Text("自动显示占位图")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
          }.padding()
        }
      }
      
      // MARK: - 图片样式
      ShowcaseSection("图片样式") {
        // 1. 圆形图片
        ShowcaseItem(title: "圆形图片",backgroundColor: Color.mint.opacity(0.1)) {
          Image(systemName: "person.circle.fill")
            .resizable()
            .frame(width: 60, height: 60)
            .foregroundStyle(.blue)
            .clipShape(Circle()).padding()
        }
        
        // 2. 带边框的图片
        ShowcaseItem(title: "带边框的图片", backgroundColor: Color.purple.opacity(0.1)) {
          Image(systemName: "photo")
            .resizable()
            .frame(width: 60, height: 60)
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 2)
            )
        }
        
        // 3. 带阴影的图片
        ShowcaseItem(title: "带阴影的图片", backgroundColor: Color.orange.opacity(0.1)) {
          Image(systemName: "star.fill")
            .resizable()
            .frame(width: 60, height: 60)
            .foregroundStyle(.yellow)
            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2).padding()
        }
      }
      
      // MARK: - SF Symbols
      ShowcaseSection("SF Symbols") {
        // 1. 基本图标
        ShowcaseItem(title: "基本图标", backgroundColor: Color.indigo.opacity(0.1)) {
          HStack(spacing: 20) {
            Image(systemName: "heart.fill")
              .foregroundStyle(.red)
              .font(.title)
            Image(systemName: "star.fill")
              .foregroundStyle(.yellow)
              .font(.title)
            Image(systemName: "bell.fill")
              .foregroundStyle(.blue)
              .font(.title)
          }.padding()
        }
        
        // 2. 变体图标
        ShowcaseItem(title: "变体图标", backgroundColor: Color.green.opacity(0.1)) {
          HStack(spacing: 20) {
            Image(systemName: "star.fill")
              .symbolVariant(.circle)
              .font(.title)
            Image(systemName: "star.fill")
              .symbolVariant(.square)
              .font(.title)
            Image(systemName: "star.fill")
              .symbolVariant(.fill)
              .font(.title)
          }.padding()
        }
        
        // 3. 动画图标
        ShowcaseItem(title: "动画图标", backgroundColor: Color.gray.opacity(0.1)) {
          HStack(spacing: 20) {
            Image(systemName: "bell.fill")
              .font(.title)
              .symbolEffect(.bounce, value: isAnimating)
            Image(systemName: "heart.fill")
              .font(.title)
              .symbolEffect(.pulse, value: isAnimating)
            Image(systemName: "star.fill")
              .font(.title)
              .symbolEffect(.bounce.byLayer, value: isAnimating)
          }.padding()
            .onTapGesture {
              isAnimating.toggle()
            }
        }
      }
      
      // MARK: - 图片效果
      ShowcaseSection("图片效果") {
        // 1. 模糊效果
        ShowcaseItem(title: "模糊效果", backgroundColor: Color.blue.opacity(0.1)) {
          HStack(spacing: 20) {
            // 原始图片
            Image(systemName: "cloud.fill")
              .resizable()
              .frame(width: 50, height: 50)
              .foregroundStyle(.blue)
            
            // 轻度模糊
            Image(systemName: "cloud.fill")
              .resizable()
              .frame(width: 50, height: 50)
              .foregroundStyle(.blue)
              .blur(radius: 2)
            
            // 重度模糊
            Image(systemName: "cloud.fill")
              .resizable()
              .frame(width: 50, height: 50)
              .foregroundStyle(.blue)
              .blur(radius: 5)
          }.padding()
        }
        
        // 2. 透明度效果
        ShowcaseItem(title: "透明度效果", backgroundColor: Color.secondary.opacity(0.1)) {
          HStack(spacing: 20) {
            Image(systemName: "moon.fill")
              .resizable()
              .frame(width: 50, height: 50)
              .foregroundStyle(.purple)
              .opacity(1)
            
            Image(systemName: "moon.fill")
              .resizable()
              .frame(width: 50, height: 50)
              .foregroundStyle(.purple)
              .opacity(0.7)
            
            Image(systemName: "moon.fill")
              .resizable()
              .frame(width: 50, height: 50)
              .foregroundStyle(.purple)
              .opacity(0.3)
          }.padding()
        }
        
        // 3. 渐变效果
        ShowcaseItem(title: "渐变效果",backgroundColor: Color.mint.opacity(0.1)) {
          Image(systemName: "circle.fill")
            .resizable()
            .frame(width: 100, height: 100)
            .foregroundStyle(
              LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            ).padding()
        }
      }
      
      // MARK: - 图片组合
      ShowcaseSection("图片组合") {
        // 1. 图文组合
        ShowcaseItem(title: "图文组合",backgroundColor: Color.teal.opacity(0.1)) {
          VStack(spacing: 20) {
            // 使用 Label
            Label("收藏", systemImage: "star.fill")
              .font(.title2)
              .foregroundStyle(.yellow)
            
            // 自定义组合
            HStack {
              Image(systemName: "heart.fill")
                .foregroundStyle(.red)
              Text("喜欢")
                .foregroundStyle(.primary)
            }
          }.padding()
        }
        
        // 2. 图层叠加
        ShowcaseItem(title: "图层叠加", backgroundColor: Color.indigo.opacity(0.1)) {
          ZStack {
            Circle()
              .fill(Color.blue)
              .frame(width: 60, height: 60)
            
            Image(systemName: "person.fill")
              .resizable()
              .scaledToFit()
              .frame(width: 40, height: 40)
              .foregroundStyle(.white)
          }.padding()
        }
      }
      
      // MARK: - 图片缩放和填充
      ShowcaseSection("图片缩放和填充") {
        // 1. 缩放模式
        ShowcaseItem(title: "缩放模式", backgroundColor: Color.pink.opacity(0.1)) {
          VStack(spacing: 20) {
            // 填充模式
            Image("twinlake")
              .resizable()
              .frame(width: 100, height: 60)
              .scaledToFill()
              .clipped()
              .overlay(Text("Fill").foregroundStyle(.white))
            
            // 适应模式
            Image("twinlake")
              .resizable()
              .frame(width: 100, height: 60)
              .scaledToFit()
              .overlay(Text("Fit").foregroundStyle(.white))
          }.padding()
        }
        
        // 2. 纵横比
        ShowcaseItem(title: "纵横比", backgroundColor: Color.green.opacity(0.1)) {
          VStack(spacing: 20) {
            Image("twinlake")
              .resizable()
              .aspectRatio(1.0, contentMode: .fit)
              .frame(width: 100)
              .overlay(Text("1:1").foregroundStyle(.white))
            
            Image("twinlake")
              .resizable()
              .aspectRatio(16/9, contentMode: .fit)
              .frame(width: 100)
              .overlay(Text("16:9").foregroundStyle(.white))
          }.padding()
        }
      }
      
      // MARK: - 图片处理
      ShowcaseSection("图片处理") {
        // 1. 颜色调整
        ShowcaseItem(title: "颜色调整",backgroundColor: Color.mint.opacity(0.1)) {
          HStack(spacing: 20) {
            Image("twinlake")
              .resizable()
              .frame(width: 60, height: 60)
              .saturation(0.0) // 黑白
            
            Image("twinlake")
              .resizable()
              .frame(width: 60, height: 60)
              .contrast(1.5) // 高对比度
            
            Image("twinlake")
              .resizable()
              .frame(width: 60, height: 60)
              .brightness(0.2) // 提高亮度
          }.padding()
        }
        
        // 2. 蒙版和混合
        ShowcaseItem(title: "蒙版和混合", backgroundColor: Color.red.opacity(0.1)) {
          HStack(spacing: 20) {
            // 渐变蒙版
            Image("twinlake")
              .resizable()
              .frame(width: 60, height: 60)
              .mask(
                LinearGradient(
                  colors: [.black, .clear],
                  startPoint: .top,
                  endPoint: .bottom
                )
              )
            
            // 形状蒙版
            Image("twinlake")
              .resizable()
              .frame(width: 60, height: 60)
              .mask(
                Circle()
              )
            
            // 混合模式
            ZStack {
              Circle()
                .fill(.blue)
                .frame(width: 60, height: 60)
              
              Image("twinlake")
                .resizable()
                .frame(width: 60, height: 60)
                .blendMode(.multiply)
            }
          }.padding()
        }
        
        // 3. 滤镜效果
        ShowcaseItem(title: "滤镜效果", backgroundColor: Color.indigo.opacity(0.1)) {
          HStack(spacing: 20) {
            Image("twinlake")
              .resizable()
              .frame(width: 60, height: 60)
              .colorInvert() // 反色
            
            Image("twinlake")
              .resizable()
              .frame(width: 60, height: 60)
              .colorMultiply(.blue) // 颜色叠加
            
            Image("twinlake")
              .resizable()
              .frame(width: 60, height: 60)
              .hueRotation(.degrees(90)) // 色相旋转
          }.padding()
        }
      }
      
      // MARK: - 交互效果
      ShowcaseSection("交互效果") {
        // 1. 手势缩放
        ShowcaseItem(title: "手势缩放", backgroundColor: Color.orange.opacity(0.1)) {
          ImageScaleDemo().padding()
        }
        
        // 2. 点击效果
        ShowcaseItem(title: "点击效果",backgroundColor: Color.secondary.opacity(0.1)) {
          ImageTapDemo().padding()
        }
      }
      
      // MARK: - 高级动画
      ShowcaseSection("高级动画") {
        // 1. 过渡动画
        ShowcaseItem(title: "过渡动画",backgroundColor: Color.pink.opacity(0.1)) {
          ImageTransitionDemo().padding()
        }
        
        // 2. 连续动画
        ShowcaseItem(title: "连续动画",backgroundColor: Color.green.opacity(0.1)) {
          ImageContinuousAnimationDemo().padding()
        }
      }
      
      // MARK: - 实用组件
      ShowcaseSection("实用组件") {
        // 1. 头像组件
        ShowcaseItem(title: "头像组件", backgroundColor: Color.mint.opacity(0.1)) {
          HStack(spacing: 20) {
            // 小头像
            Image(systemName: "person.crop.circle.fill")
              .resizable()
              .frame(width: 40, height: 40)
              .foregroundStyle(.blue)
            
            // 中头像
            Image(systemName: "person.crop.circle.fill")
              .resizable()
              .frame(width: 60, height: 60)
              .foregroundStyle(.blue)
              .background(Circle().fill(Color.blue.opacity(0.2)))
            
            // 大头像
            Image(systemName: "person.crop.circle.fill")
              .resizable()
              .frame(width: 80, height: 80)
              .foregroundStyle(.blue)
              .background(Circle().fill(Color.blue.opacity(0.2)))
              .overlay(
                Circle()
                  .stroke(Color.blue, lineWidth: 2)
              )
          }.padding()
        }
        
        // 2. 图片卡片
        ShowcaseItem(title: "图片卡片",backgroundColor: Color.green.opacity(0.1)) {
          VStack(spacing: 8) {
            Image(systemName: "photo.fill")
              .resizable()
              .frame(width: 200, height: 150)
              .foregroundStyle(.white)
              .background(
                RoundedRectangle(cornerRadius: 12)
                  .fill(Color.gray)
              )
            
            Text("示例图片")
              .font(.caption)
              .foregroundStyle(.secondary)
          }.padding()
        }
      }
    }
    .navigationTitle("Image 示例")
  }
}

// MARK: - 预览
// MARK: - 交互演示组件
struct ImageScaleDemo: View {
  @GestureState private var scale: CGFloat = 1.0
  
  var body: some View {
    Image("twinlake")
      .resizable()
      .frame(width: 100, height: 100)
      .scaleEffect(scale)
      .gesture(
        MagnificationGesture()
          .updating($scale) { currentState, gestureState, _ in
            gestureState = currentState
          }
      )
  }
}

struct ImageTapDemo: View {
  @State private var isPressed = false
  
  var body: some View {
    Image("twinlake")
      .resizable()
      .frame(width: 100, height: 100)
      .scaleEffect(isPressed ? 0.9 : 1.0)
      .animation(.spring, value: isPressed)
      .onTapGesture {
        isPressed.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          isPressed.toggle()
        }
      }
  }
}

// MARK: - 动画演示组件
struct ImageTransitionDemo: View {
  @State private var isFlipped = false
  
  var body: some View {
    Image("twinlake")
      .resizable()
      .frame(width: 100, height: 100)
      .rotation3DEffect(
        .degrees(isFlipped ? 180 : 0),
        axis: (x: 0.0, y: 1.0, z: 0.0)
      )
      .animation(.spring, value: isFlipped)
      .onTapGesture {
        isFlipped.toggle()
      }
  }
}

struct ImageContinuousAnimationDemo: View {
  @State private var isAnimating = false
  
  var body: some View {
    Image("twinlake")
      .resizable()
      .frame(width: 100, height: 100)
      .rotationEffect(.degrees(isAnimating ? 360 : 0))
      .animation(
        .linear(duration: 2.0)
        .repeatForever(autoreverses: false),
        value: isAnimating
      )
      .onAppear {
        isAnimating = true
      }
  }
}

#Preview {
  NavigationView {
    ImageDemoView()
  }
}
