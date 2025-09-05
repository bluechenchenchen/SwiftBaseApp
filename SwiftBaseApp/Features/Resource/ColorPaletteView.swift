//
//  ColorPaletteView.swift
//  SwiftBaseApp
//
//  Created by Assistant on 2025/1/14.
//

import SwiftUI

struct ColorPaletteView: View {
  @State private var selectedCategory: ColorCategory = .system
  @State private var colorScheme: ColorScheme = .light
  @State private var selectedColorFormat: ColorFormat = .hex
  @State private var showCodeGenerator = false
  @State private var showCopiedAlert = false
  @State private var copiedMessage = ""
  @State private var colorHistory: [SystemColor] = []
  @State private var customColors: [CustomColor] = []
  @Environment(\.colorScheme) private var systemColorScheme
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        // 分类选择器
        categorySelector
        
        Divider()
        
        // 控制面板
        controlPanel
        
        Divider()
        
        // 颜色展示区
        ScrollView {
          LazyVStack(spacing: 16) {
            switch selectedCategory {
            case .system:
              systemColorsSection
            case .semantic:
              semanticColorsSection
            case .custom:
              customColorsSection
            case .history:
              historyColorsSection
            }
          }
          .padding()
        }
      }
      .navigationTitle("颜色调色板")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("代码生成器") {
            showCodeGenerator = true
          }
        }
      }
      .sheet(isPresented: $showCodeGenerator) {
        ColorCodeGeneratorView()
      }
      .alert(copiedMessage, isPresented: $showCopiedAlert) {
        Button("确定") { }
      }
    }
    .preferredColorScheme(colorScheme == systemColorScheme ? nil : colorScheme)
  }
  
  // MARK: - Category Selector
  private var categorySelector: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 16) {
        ForEach(ColorCategory.allCases, id: \.self) { category in
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
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
              selectedCategory == category
              ? Color.blue
              : Color(.systemGray6)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
          }
        }
      }
      .padding(.horizontal)
    }
    .padding(.vertical, 12)
  }
  
  // MARK: - Control Panel
  private var controlPanel: some View {
    VStack(spacing: 12) {
      HStack {
        // 颜色方案切换
        VStack(alignment: .leading, spacing: 4) {
          Text("外观模式")
            .font(.caption)
            .foregroundColor(.secondary)
          
          Picker("外观", selection: $colorScheme) {
            Text("浅色").tag(ColorScheme.light)
            Text("深色").tag(ColorScheme.dark)
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        
        Spacer()
        
        // 颜色格式选择
        VStack(alignment: .leading, spacing: 4) {
          Text("颜色格式")
            .font(.caption)
            .foregroundColor(.secondary)
          
          Picker("格式", selection: $selectedColorFormat) {
            ForEach(ColorFormat.allCases, id: \.self) { format in
              Text(format.name).tag(format)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
      }
    }
    .padding()
    .background(Color(.systemGray6))
  }
  
  // MARK: - System Colors Section
  private var systemColorsSection: some View {
    VStack(spacing: 16) {
      ForEach(SystemColorGroup.allCases, id: \.self) { group in
        VStack(alignment: .leading, spacing: 12) {
          Text(group.name)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            ForEach(group.colors, id: \.name) { color in
              SystemColorCard(
                systemColor: color,
                format: selectedColorFormat,
                onCopy: { message in
                  copiedMessage = message
                  showCopiedAlert = true
                  addToHistory(color)
                }
              )
            }
          }
        }
      }
    }
  }
  
  // MARK: - Semantic Colors Section
  private var semanticColorsSection: some View {
    VStack(spacing: 16) {
      Text("语义颜色层级")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      ForEach(SemanticColorLevel.allCases, id: \.self) { level in
        VStack(alignment: .leading, spacing: 12) {
          Text(level.name)
            .font(.subheadline)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
            ForEach(level.colors, id: \.name) { color in
              SystemColorCard(
                systemColor: color,
                format: selectedColorFormat,
                onCopy: { message in
                  copiedMessage = message
                  showCopiedAlert = true
                  addToHistory(color)
                }
              )
            }
          }
        }
      }
    }
  }
  
  // MARK: - Custom Colors Section
  private var customColorsSection: some View {
    VStack(spacing: 16) {
      HStack {
        Text("自定义颜色")
          .font(.headline)
        
        Spacer()
        
        Button("添加颜色") {
          addCustomColor()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
      }
      
      if customColors.isEmpty {
        VStack(spacing: 16) {
          Image(systemName: "paintpalette")
            .font(.system(size: 48))
            .foregroundColor(.secondary)
          
          Text("暂无自定义颜色")
            .font(.title3)
            .foregroundColor(.secondary)
          
          Text("点击添加颜色开始创建你的调色板")
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
      } else {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
          ForEach(customColors) { color in
            CustomColorCard(
              customColor: color,
              format: selectedColorFormat,
              onCopy: { message in
                copiedMessage = message
                showCopiedAlert = true
              },
              onDelete: {
                deleteCustomColor(color)
              }
            )
          }
        }
      }
    }
  }
  
  // MARK: - History Colors Section
  private var historyColorsSection: some View {
    VStack(spacing: 16) {
      HStack {
        Text("颜色历史")
          .font(.headline)
        
        Spacer()
        
        if !colorHistory.isEmpty {
          Button("清空历史") {
            colorHistory.removeAll()
          }
          .font(.caption)
          .foregroundColor(.red)
        }
      }
      
      if colorHistory.isEmpty {
        VStack(spacing: 16) {
          Image(systemName: "clock")
            .font(.system(size: 48))
            .foregroundColor(.secondary)
          
          Text("暂无颜色历史")
            .font(.title3)
            .foregroundColor(.secondary)
          
          Text("复制颜色时会自动添加到历史记录")
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
      } else {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
          ForEach(colorHistory.reversed(), id: \.name) { color in
            SystemColorCard(
              systemColor: color,
              format: selectedColorFormat,
              isCompact: true,
              onCopy: { message in
                copiedMessage = message
                showCopiedAlert = true
              }
            )
          }
        }
      }
    }
  }
  
  // MARK: - Helper Methods
  private func addToHistory(_ color: SystemColor) {
    if !colorHistory.contains(where: { $0.name == color.name }) {
      colorHistory.append(color)
      if colorHistory.count > 20 {
        colorHistory.removeFirst()
      }
    }
  }
  
  private func addCustomColor() {
    let newColor = CustomColor(
      name: "自定义颜色 \(customColors.count + 1)",
      color: Color.colorRandom,
      description: "用户自定义颜色"
    )
    customColors.append(newColor)
  }
  
  private func deleteCustomColor(_ color: CustomColor) {
    customColors.removeAll { $0.id == color.id }
  }
}

// MARK: - Supporting Types

enum ColorCategory: CaseIterable {
  case system, semantic, custom, history
  
  var name: String {
    switch self {
    case .system: return "系统"
    case .semantic: return "语义"
    case .custom: return "自定义"
    case .history: return "历史"
    }
  }
  
  var icon: String {
    switch self {
    case .system: return "paintbrush"
    case .semantic: return "tag"
    case .custom: return "paintpalette"
    case .history: return "clock"
    }
  }
}

enum ColorFormat: CaseIterable {
  case hex, rgb, hsb
  
  var name: String {
    switch self {
    case .hex: return "HEX"
    case .rgb: return "RGB"
    case .hsb: return "HSB"
    }
  }
}

struct SystemColor {
  let name: String
  let color: Color
  let description: String
  let swiftUICode: String
  let uiKitCode: String
}

struct CustomColor: Identifiable {
  let id = UUID()
  let name: String
  let color: Color
  let description: String
}

enum SystemColorGroup: CaseIterable {
  case label, fill, background, separator, system
  
  var name: String {
    switch self {
    case .label: return "标签颜色"
    case .fill: return "填充颜色"
    case .background: return "背景颜色"
    case .separator: return "分隔符颜色"
    case .system: return "系统颜色"
    }
  }
  
  var colors: [SystemColor] {
    switch self {
    case .label:
      return [
        SystemColor(name: "Label", color: Color(.label), description: "主要文本", swiftUICode: "Color(.label)", uiKitCode: "UIColor.label"),
        SystemColor(name: "Secondary Label", color: Color(.secondaryLabel), description: "次要文本", swiftUICode: "Color(.secondaryLabel)", uiKitCode: "UIColor.secondaryLabel"),
        SystemColor(name: "Tertiary Label", color: Color(.tertiaryLabel), description: "三级文本", swiftUICode: "Color(.tertiaryLabel)", uiKitCode: "UIColor.tertiaryLabel"),
        SystemColor(name: "Quaternary Label", color: Color(.quaternaryLabel), description: "四级文本", swiftUICode: "Color(.quaternaryLabel)", uiKitCode: "UIColor.quaternaryLabel")
      ]
    case .fill:
      return [
        SystemColor(name: "System Fill", color: Color(.systemFill), description: "系统填充", swiftUICode: "Color(.systemFill)", uiKitCode: "UIColor.systemFill"),
        SystemColor(name: "Secondary Fill", color: Color(.secondarySystemFill), description: "次要填充", swiftUICode: "Color(.secondarySystemFill)", uiKitCode: "UIColor.secondarySystemFill"),
        SystemColor(name: "Tertiary Fill", color: Color(.tertiarySystemFill), description: "三级填充", swiftUICode: "Color(.tertiarySystemFill)", uiKitCode: "UIColor.tertiarySystemFill"),
        SystemColor(name: "Quaternary Fill", color: Color(.quaternarySystemFill), description: "四级填充", swiftUICode: "Color(.quaternarySystemFill)", uiKitCode: "UIColor.quaternarySystemFill")
      ]
    case .background:
      return [
        SystemColor(name: "System Background", color: Color(.systemBackground), description: "系统背景", swiftUICode: "Color(.systemBackground)", uiKitCode: "UIColor.systemBackground"),
        SystemColor(name: "Secondary Background", color: Color(.secondarySystemBackground), description: "次要背景", swiftUICode: "Color(.secondarySystemBackground)", uiKitCode: "UIColor.secondarySystemBackground"),
        SystemColor(name: "Tertiary Background", color: Color(.tertiarySystemBackground), description: "三级背景", swiftUICode: "Color(.tertiarySystemBackground)", uiKitCode: "UIColor.tertiarySystemBackground"),
        SystemColor(name: "Grouped Background", color: Color(.systemGroupedBackground), description: "分组背景", swiftUICode: "Color(.systemGroupedBackground)", uiKitCode: "UIColor.systemGroupedBackground")
      ]
    case .separator:
      return [
        SystemColor(name: "Separator", color: Color(.separator), description: "分隔符", swiftUICode: "Color(.separator)", uiKitCode: "UIColor.separator"),
        SystemColor(name: "Opaque Separator", color: Color(.opaqueSeparator), description: "不透明分隔符", swiftUICode: "Color(.opaqueSeparator)", uiKitCode: "UIColor.opaqueSeparator")
      ]
    case .system:
      return [
        SystemColor(name: "Blue", color: .blue, description: "系统蓝色", swiftUICode: "Color.blue", uiKitCode: "UIColor.systemBlue"),
        SystemColor(name: "Green", color: .green, description: "系统绿色", swiftUICode: "Color.green", uiKitCode: "UIColor.systemGreen"),
        SystemColor(name: "Red", color: .red, description: "系统红色", swiftUICode: "Color.red", uiKitCode: "UIColor.systemRed"),
        SystemColor(name: "Orange", color: .orange, description: "系统橙色", swiftUICode: "Color.orange", uiKitCode: "UIColor.systemOrange"),
        SystemColor(name: "Yellow", color: .yellow, description: "系统黄色", swiftUICode: "Color.yellow", uiKitCode: "UIColor.systemYellow"),
        SystemColor(name: "Pink", color: .pink, description: "系统粉色", swiftUICode: "Color.pink", uiKitCode: "UIColor.systemPink"),
        SystemColor(name: "Purple", color: .purple, description: "系统紫色", swiftUICode: "Color.purple", uiKitCode: "UIColor.systemPurple"),
        SystemColor(name: "Indigo", color: .indigo, description: "系统靛蓝", swiftUICode: "Color.indigo", uiKitCode: "UIColor.systemIndigo")
      ]
    }
  }
}

enum SemanticColorLevel: CaseIterable {
  case primary, secondary, tertiary
  
  var name: String {
    switch self {
    case .primary: return "主要层级"
    case .secondary: return "次要层级"
    case .tertiary: return "三级层级"
    }
  }
  
  var colors: [SystemColor] {
    switch self {
    case .primary:
      return [
        SystemColor(name: "Primary", color: Color(.label), description: "主要内容", swiftUICode: "Color.primary", uiKitCode: "UIColor.label"),
        SystemColor(name: "Background", color: Color(.systemBackground), description: "主要背景", swiftUICode: "Color(.systemBackground)", uiKitCode: "UIColor.systemBackground"),
        SystemColor(name: "Fill", color: Color(.systemFill), description: "主要填充", swiftUICode: "Color(.systemFill)", uiKitCode: "UIColor.systemFill")
      ]
    case .secondary:
      return [
        SystemColor(name: "Secondary", color: Color(.secondaryLabel), description: "次要内容", swiftUICode: "Color.secondary", uiKitCode: "UIColor.secondaryLabel"),
        SystemColor(name: "Background", color: Color(.secondarySystemBackground), description: "次要背景", swiftUICode: "Color(.secondarySystemBackground)", uiKitCode: "UIColor.secondarySystemBackground"),
        SystemColor(name: "Fill", color: Color(.secondarySystemFill), description: "次要填充", swiftUICode: "Color(.secondarySystemFill)", uiKitCode: "UIColor.secondarySystemFill")
      ]
    case .tertiary:
      return [
        SystemColor(name: "Tertiary", color: Color(.tertiaryLabel), description: "三级内容", swiftUICode: "Color(.tertiaryLabel)", uiKitCode: "UIColor.tertiaryLabel"),
        SystemColor(name: "Background", color: Color(.tertiarySystemBackground), description: "三级背景", swiftUICode: "Color(.tertiarySystemBackground)", uiKitCode: "UIColor.tertiarySystemBackground"),
        SystemColor(name: "Fill", color: Color(.tertiarySystemFill), description: "三级填充", swiftUICode: "Color(.tertiarySystemFill)", uiKitCode: "UIColor.tertiarySystemFill")
      ]
    }
  }
}

// MARK: - Extensions
extension Color {
  static var colorRandom: Color {
    Color(
      red: Double.random(in: 0...1),
      green: Double.random(in: 0...1),
      blue: Double.random(in: 0...1)
    )
  }
}

#Preview {
  ColorPaletteView()
}
