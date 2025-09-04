//
//  SFSymbolsShowcaseView.swift
//  SwiftBaseApp
//
//  Created by Assistant on 2025/1/14.
//

import SwiftUI

struct SFSymbolsShowcaseView: View {
  @State private var searchText = ""
  @State private var selectedCategory: SymbolCategory = .communication
  @State private var selectedWeight: Font.Weight = .regular
  @State private var selectedSize: CGFloat = 24
  @State private var selectedColor: Color = .primary
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        // 控制面板
        controlPanel
        
        Divider()
        
        // 分类选择器
        categorySelector
        
        Divider()
        
        // 图标网格
        symbolGrid
      }
      .navigationTitle("SF Symbols 图标库")
      .navigationBarTitleDisplayMode(.large)
      .searchable(text: $searchText, prompt: "搜索图标...")
    }
  }
  
  // MARK: - Control Panel
  private var controlPanel: some View {
    VStack(spacing: 16) {
      // 权重选择
      VStack(alignment: .leading, spacing: 8) {
        Text("字体权重")
          .font(.caption)
          .foregroundColor(.secondary)
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(FontWeight.allCases, id: \.self) { weight in
              Button(action: {
                selectedWeight = weight.value
              }) {
                Text(weight.name)
                  .font(.caption)
                  .padding(.horizontal, 12)
                  .padding(.vertical, 6)
                  .background(
                    selectedWeight == weight.value
                    ? Color.blue
                    : Color(.systemGray5)
                  )
                  .foregroundColor(
                    selectedWeight == weight.value
                    ? .white
                    : .primary
                  )
                  .clipShape(RoundedRectangle(cornerRadius: 8))
              }
            }
          }
          .padding(.horizontal)
        }
      }
      
      // 大小和颜色控制
      HStack(spacing: 20) {
        // 大小滑块
        VStack(alignment: .leading, spacing: 4) {
          Text("大小: \(Int(selectedSize))pt")
            .font(.caption)
            .foregroundColor(.secondary)
          
          Slider(value: $selectedSize, in: 12...48, step: 2)
            .accentColor(.blue)
        }
        
        // 颜色选择
        VStack(alignment: .leading, spacing: 4) {
          Text("颜色")
            .font(.caption)
            .foregroundColor(.secondary)
          
          HStack(spacing: 8) {
            ForEach(PresetColor.allCases, id: \.self) { color in
              Button(action: {
                selectedColor = color.value
              }) {
                Circle()
                  .fill(color.value)
                  .frame(width: 24, height: 24)
                  .overlay(
                    Circle()
                      .stroke(Color.primary, lineWidth: selectedColor == color.value ? 2 : 0)
                  )
              }
            }
          }
        }
      }
    }
    .padding()
    .background(Color(.systemGray6))
  }
  
  // MARK: - Category Selector
  private var categorySelector: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 12) {
        ForEach(SymbolCategory.allCases, id: \.self) { category in
          Button(action: {
            selectedCategory = category
          }) {
            VStack(spacing: 4) {
              Image(systemName: category.icon)
                .font(.title2)
                .foregroundColor(selectedCategory == category ? .white : .primary)
              
              Text(category.name)
                .font(.caption)
                .foregroundColor(selectedCategory == category ? .white : .primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
              selectedCategory == category
              ? Color.blue
              : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
          }
        }
      }
      .padding(.horizontal)
    }
    .padding(.vertical, 8)
  }
  
  // MARK: - Symbol Grid
  private var symbolGrid: some View {
    ScrollView {
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
        ForEach(filteredSymbols, id: \.self) { symbol in
          SymbolCard(
            symbol: symbol,
            size: selectedSize,
            weight: selectedWeight,
            color: selectedColor
          )
        }
      }
      .padding()
    }
  }
  
  // MARK: - Computed Properties
  private var filteredSymbols: [String] {
    let categorySymbols = selectedCategory.symbols
    
    if searchText.isEmpty {
      return categorySymbols
    }
    
    return categorySymbols.filter { symbol in
      symbol.localizedCaseInsensitiveContains(searchText)
    }
  }
}

// MARK: - Symbol Card
struct SymbolCard: View {
  let symbol: String
  let size: CGFloat
  let weight: Font.Weight
  let color: Color
  
  @State private var isPressed = false
  @State private var showCopiedAlert = false
  
  var body: some View {
    VStack(spacing: 8) {
      // 图标展示
      Image(systemName: symbol)
        .font(.system(size: size, weight: weight))
        .foregroundColor(color)
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
      
      // 图标名称
      Text(symbol)
        .font(.caption2)
        .foregroundColor(.secondary)
        .lineLimit(2)
        .multilineTextAlignment(.center)
    }
    .onTapGesture {
      copyToClipboard()
    }
    .onLongPressGesture(
      minimumDuration: 0,
      pressing: { pressing in
        isPressed = pressing
      },
      perform: {
        copyToClipboard()
      }
    )
    .alert("已复制", isPresented: $showCopiedAlert) {
      Button("确定") { }
    } message: {
      Text("图标名称 '\(symbol)' 已复制到剪贴板")
    }
  }
  
  private func copyToClipboard() {
    UIPasteboard.general.string = symbol
    showCopiedAlert = true
    
    // 触觉反馈
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    impactFeedback.impactOccurred()
  }
}

// MARK: - Supporting Types

enum SymbolCategory: CaseIterable {
  case communication
  case navigation
  case interface
  case media
  case documents
  case social
  case system
  case weather
  case commerce
  case health
  case transportation
  case editing
  case security
  case gaming
  case science
  
  var name: String {
    switch self {
    case .communication: return "通信"
    case .navigation: return "导航"
    case .interface: return "界面"
    case .media: return "多媒体"
    case .documents: return "文档"
    case .social: return "社交"
    case .system: return "系统"
    case .weather: return "天气"
    case .commerce: return "商务"
    case .health: return "健康"
    case .transportation: return "交通"
    case .editing: return "编辑"
    case .security: return "安全"
    case .gaming: return "游戏"
    case .science: return "科学"
    }
  }
  
  var icon: String {
    switch self {
    case .communication: return "phone"
    case .navigation: return "arrow.left.arrow.right"
    case .interface: return "slider.horizontal.3"
    case .media: return "play.circle"
    case .documents: return "doc"
    case .social: return "heart"
    case .system: return "gear"
    case .weather: return "cloud.sun"
    case .commerce: return "cart"
    case .health: return "heart.text.square"
    case .transportation: return "car"
    case .editing: return "pencil"
    case .security: return "lock"
    case .gaming: return "gamecontroller"
    case .science: return "atom"
    }
  }
  
  var symbols: [String] {
    switch self {
    case .communication:
      return [
        "phone", "phone.fill", "phone.circle", "phone.circle.fill",
        "phone.badge.plus", "phone.connection", "phone.down",
        "message", "message.fill", "message.circle", "message.circle.fill",
        "envelope", "envelope.fill", "envelope.open", "envelope.open.fill",
        "paperplane", "paperplane.fill", "mail", "mail.stack",
        "bubble.left", "bubble.right", "bubble.left.and.bubble.right",
        "text.bubble", "text.bubble.fill", "quote.bubble",
        "phone.arrow.up.right", "phone.arrow.down.left", "phone.arrow.right"
      ]
      
    case .navigation:
      return [
        "chevron.left", "chevron.right", "chevron.up", "chevron.down",
        "chevron.left.circle", "chevron.right.circle", "chevron.up.circle", "chevron.down.circle",
        "arrow.left", "arrow.right", "arrow.up", "arrow.down",
        "arrow.up.left", "arrow.up.right", "arrow.down.left", "arrow.down.right",
        "arrow.clockwise", "arrow.counterclockwise", "arrow.2.circlepath",
        "arrow.triangle.2.circlepath", "arrow.left.arrow.right", "arrow.up.arrow.down",
        "location", "location.fill", "location.circle", "location.circle.fill"
      ]
      
    case .interface:
      return [
        "plus", "plus.circle", "plus.circle.fill", "plus.square", "plus.square.fill",
        "minus", "minus.circle", "minus.circle.fill", "minus.square", "minus.square.fill",
        "multiply", "multiply.circle", "multiply.circle.fill", "xmark", "xmark.circle",
        "checkmark", "checkmark.circle", "checkmark.circle.fill", "checkmark.square",
        "gear", "gearshape", "gearshape.fill", "slider.horizontal.3",
        "ellipsis", "ellipsis.circle", "line.horizontal.3", "line.horizontal.3.decrease",
        "square.grid.2x2", "square.grid.3x3", "circle.grid.hex", "list.bullet"
      ]
      
    case .media:
      return [
        "play", "play.fill", "play.circle", "play.circle.fill",
        "pause", "pause.fill", "pause.circle", "pause.circle.fill",
        "stop", "stop.fill", "stop.circle", "stop.circle.fill",
        "backward", "backward.fill", "forward", "forward.fill",
        "speaker", "speaker.fill", "speaker.wave.1", "speaker.wave.2", "speaker.wave.3",
        "volume.1", "volume.2", "volume.3", "volume.x",
        "camera", "camera.fill", "camera.circle", "camera.circle.fill",
        "video", "video.fill", "video.circle", "video.circle.fill",
        "mic", "mic.fill", "mic.circle", "mic.circle.fill"
      ]
      
    case .documents:
      return [
        "doc", "doc.fill", "doc.circle", "doc.circle.fill",
        "doc.text", "doc.text.fill", "doc.richtext", "doc.richtext.fill",
        "folder", "folder.fill", "folder.circle", "folder.circle.fill",
        "archivebox", "archivebox.fill", "tray", "tray.fill",
        "paperclip", "link", "bookmark", "bookmark.fill",
        "note", "note.text", "newspaper", "newspaper.fill",
        "trash", "trash.fill", "trash.circle", "trash.circle.fill"
      ]
      
    case .social:
      return [
        "heart", "heart.fill", "heart.circle", "heart.circle.fill",
        "star", "star.fill", "star.circle", "star.circle.fill",
        "hand.thumbsup", "hand.thumbsup.fill", "hand.thumbsdown", "hand.thumbsdown.fill",
        "person", "person.fill", "person.circle", "person.circle.fill",
        "person.2", "person.2.fill", "person.3", "person.3.fill",
        "share", "square.and.arrow.up", "square.and.arrow.down",
        "gift", "gift.fill", "bell", "bell.fill"
      ]
      
    case .system:
      return [
        "iphone", "ipad", "macbook", "applewatch", "airpods",
        "desktopcomputer", "laptopcomputer", "display", "tv",
        "battery", "battery.25", "battery.50", "battery.75", "battery.100",
        "wifi", "wifi.slash", "antenna.radiowaves.left.and.right",
        "bluetooth", "cable.connector", "powerplug", "powercord",
        "externaldrive", "internaldrive", "opticaldiscdrive"
      ]
      
    case .weather:
      return [
        "sun.max", "sun.min", "sunrise", "sunset",
        "cloud", "cloud.fill", "cloud.drizzle", "cloud.rain",
        "cloud.heavyrain", "cloud.fog", "cloud.hail", "cloud.snow",
        "cloud.sleet", "cloud.bolt", "cloud.bolt.rain",
        "tornado", "hurricane", "thermometer",
        "snow", "drop", "drop.fill"
      ]
      
    case .commerce:
      return [
        "cart", "cart.fill", "cart.circle", "cart.circle.fill",
        "bag", "bag.fill", "bag.circle", "bag.circle.fill",
        "creditcard", "creditcard.fill", "banknote", "banknote.fill",
        "dollarsign.circle", "yensign.circle", "eurosign.circle",
        "bitcoinsign.circle", "percent", "tag", "tag.fill",
        "giftcard", "giftcard.fill", "storefront", "storefront.fill"
      ]
      
    case .health:
      return [
        "heart.text.square", "cross", "cross.fill", "cross.circle",
        "pills", "pills.fill", "syringe", "syringe.fill",
        "stethoscope", "thermometer", "bandage", "bandage.fill",
        "figure.walk", "figure.run", "figure.yoga", "figure.dance",
        "bed.double", "bed.double.fill", "lungs", "lungs.fill",
        "drop", "drop.fill", "flame", "flame.fill"
      ]
      
    case .transportation:
      return [
        "car", "car.fill", "car.circle", "car.circle.fill",
        "bus", "bus.fill", "bicycle", "bicycle.circle",
        "airplane", "airplane.circle", "train.side.front.car",
        "ferry", "sailboat", "sailboat.fill",
        "fuelpump", "fuelpump.fill", "road.lanes", "road.lanes.curved.left",
        "parkingsign", "parkingsign.circle", "stop.circle", "stop.circle.fill"
      ]
      
    case .editing:
      return [
        "pencil", "pencil.circle", "pencil.circle.fill", "pencil.tip",
        "pencil.tip.crop.circle", "paintbrush", "paintbrush.fill",
        "eyedropper", "eyedropper.halffull", "scribble", "scribble.variable",
        "scissors", "scissors.badge.ellipsis", "rotate.left", "rotate.right",
        "crop", "crop.rotate", "square.and.pencil", "rectangle.and.pencil.and.ellipsis"
      ]
      
    case .security:
      return [
        "lock", "lock.fill", "lock.circle", "lock.circle.fill",
        "lock.open", "lock.open.fill", "key", "key.fill",
        "shield", "shield.fill", "shield.lefthalf.fill", "shield.righthalf.fill",
        "checkmark.shield", "checkmark.shield.fill", "xmark.shield", "xmark.shield.fill",
        "eye", "eye.fill", "eye.slash", "eye.slash.fill",
        "faceid", "touchid", "questionmark.diamond", "questionmark.diamond.fill"
      ]
      
    case .gaming:
      return [
        "gamecontroller", "gamecontroller.fill", "dice", "dice.fill",
        "suit.heart", "suit.heart.fill", "suit.club", "suit.club.fill",
        "suit.diamond", "suit.diamond.fill", "suit.spade", "suit.spade.fill",
        "target", "scope", "trophy", "trophy.fill",
        "medal", "medal.fill", "crown", "crown.fill"
      ]
      
    case .science:
      return [
        "atom", "flask", "flask.fill", "testtube.2",
        "microscope", "telescope", "scale.3d", "ruler",
        "function", "percent", "plus.forwardslash.minus", "divide",
        "multiply", "equal", "lessthan", "greaterthan",
        "sum", "infinity", "x.squareroot", "fx"
      ]
    }
  }
}

enum FontWeight: CaseIterable {
  case ultraLight, thin, light, regular, medium, semibold, bold, heavy, black
  
  var name: String {
    switch self {
    case .ultraLight: return "超细"
    case .thin: return "细"
    case .light: return "轻"
    case .regular: return "常规"
    case .medium: return "中等"
    case .semibold: return "半粗"
    case .bold: return "粗体"
    case .heavy: return "重"
    case .black: return "超重"
    }
  }
  
  var value: Font.Weight {
    switch self {
    case .ultraLight: return .ultraLight
    case .thin: return .thin
    case .light: return .light
    case .regular: return .regular
    case .medium: return .medium
    case .semibold: return .semibold
    case .bold: return .bold
    case .heavy: return .heavy
    case .black: return .black
    }
  }
}

enum PresetColor: CaseIterable {
  case primary, blue, green, red, orange, yellow, purple, pink, gray
  
  var value: Color {
    switch self {
    case .primary: return .primary
    case .blue: return .blue
    case .green: return .green
    case .red: return .red
    case .orange: return .orange
    case .yellow: return .yellow
    case .purple: return .purple
    case .pink: return .pink
    case .gray: return .gray
    }
  }
}

#Preview {
  SFSymbolsShowcaseView()
}
