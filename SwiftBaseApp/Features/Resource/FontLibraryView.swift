//
//  FontLibraryView.swift
//  SwiftBaseApp
//
//  Created by Assistant on 2025/1/14.
//

import SwiftUI

struct FontLibraryView: View {
  @State private var selectedCategory: FontCategory = .weights
  @State private var selectedFontSize: CGFloat = 17
  @State private var selectedWeight: Font.Weight = .regular
  @State private var selectedDesign: Font.Design = .default
  @State private var lineSpacing: CGFloat = 4
  @State private var letterSpacing: CGFloat = 0
  @State private var sampleText = "The quick brown fox jumps over the lazy dog"
  @State private var showCodeGenerator = false
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        // 分类选择器
        categorySelector
        
        Divider()
        
        // 内容展示区
        ScrollView {
          VStack(spacing: 20) {
            // 配置面板
            configurationPanel
            
            Divider()
            
            // 字体展示区
            fontDisplayArea
          }
          .padding()
        }
      }
      .navigationTitle("字体样式库")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("代码生成器") {
            showCodeGenerator = true
          }
        }
      }
      .sheet(isPresented: $showCodeGenerator) {
        FontCodeGeneratorView(
          fontSize: selectedFontSize,
          weight: selectedWeight,
          design: selectedDesign,
          lineSpacing: lineSpacing,
          letterSpacing: letterSpacing
        )
      }
    }
  }
  
  // MARK: - Category Selector
  private var categorySelector: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 16) {
        ForEach(FontCategory.allCases, id: \.self) { category in
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
  
  // MARK: - Configuration Panel
  private var configurationPanel: some View {
    VStack(spacing: 16) {
      // 实时预览文本
      VStack(alignment: .leading, spacing: 8) {
        Text("预览文本")
          .font(.caption)
          .foregroundColor(.secondary)
        
        TextField("输入预览文本", text: $sampleText)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      
      // 字体配置
      VStack(spacing: 12) {
        // 大小调节
        HStack {
          Text("大小")
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(width: 50, alignment: .leading)
          
          Slider(value: $selectedFontSize, in: 10...72, step: 1)
            .accentColor(.blue)
          
          Text("\(Int(selectedFontSize))pt")
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(width: 40, alignment: .trailing)
        }
        
        // 权重选择
        HStack {
          Text("权重")
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(width: 50, alignment: .leading)
          
          Picker("字体权重", selection: $selectedWeight) {
            ForEach(FontWeightOption.allCases, id: \.self) { weight in
              Text(weight.name).tag(weight.value)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        
        // 设计样式
        HStack {
          Text("样式")
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(width: 50, alignment: .leading)
          
          Picker("字体设计", selection: $selectedDesign) {
            ForEach(FontDesignOption.allCases, id: \.self) { design in
              Text(design.name).tag(design.value)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        
        // 行间距
        HStack {
          Text("行距")
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(width: 50, alignment: .leading)
          
          Slider(value: $lineSpacing, in: 0...20, step: 1)
            .accentColor(.blue)
          
          Text("\(Int(lineSpacing))pt")
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(width: 40, alignment: .trailing)
        }
        
        // 字间距
        HStack {
          Text("字距")
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(width: 50, alignment: .leading)
          
          Slider(value: $letterSpacing, in: -2...5, step: 0.1)
            .accentColor(.blue)
          
          Text(String(format: "%.1f", letterSpacing))
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(width: 40, alignment: .trailing)
        }
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
  
  // MARK: - Font Display Area
  private var fontDisplayArea: some View {
    VStack(spacing: 16) {
      switch selectedCategory {
      case .weights:
        FontWeightsView(
          sampleText: sampleText,
          fontSize: selectedFontSize,
          design: selectedDesign,
          lineSpacing: lineSpacing,
          letterSpacing: letterSpacing
        )
      case .sizes:
        FontSizesView(
          sampleText: sampleText,
          weight: selectedWeight,
          design: selectedDesign,
          lineSpacing: lineSpacing,
          letterSpacing: letterSpacing
        )
      case .designs:
        FontDesignsView(
          sampleText: sampleText,
          fontSize: selectedFontSize,
          weight: selectedWeight,
          lineSpacing: lineSpacing,
          letterSpacing: letterSpacing
        )
      case .hierarchy:
        FontHierarchyView(
          sampleText: sampleText,
          design: selectedDesign,
          lineSpacing: lineSpacing,
          letterSpacing: letterSpacing
        )
      case .accessibility:
        FontAccessibilityView(
          sampleText: sampleText,
          fontSize: selectedFontSize,
          weight: selectedWeight,
          design: selectedDesign
        )
      }
    }
  }
}

// MARK: - Supporting Types

enum FontCategory: CaseIterable {
  case weights, sizes, designs, hierarchy, accessibility
  
  var name: String {
    switch self {
    case .weights: return "权重"
    case .sizes: return "大小"
    case .designs: return "设计"
    case .hierarchy: return "层级"
    case .accessibility: return "无障碍"
    }
  }
  
  var icon: String {
    switch self {
    case .weights: return "textformat.size"
    case .sizes: return "plus.magnifyingglass"
    case .designs: return "textformat"
    case .hierarchy: return "list.number"
    case .accessibility: return "accessibility"
    }
  }
}

enum FontWeightOption: CaseIterable {
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

enum FontDesignOption: CaseIterable {
  case `default`, serif, monospaced, rounded
  
  var name: String {
    switch self {
    case .default: return "默认"
    case .serif: return "衬线"
    case .monospaced: return "等宽"
    case .rounded: return "圆体"
    }
  }
  
  var value: Font.Design {
    switch self {
    case .default: return .default
    case .serif: return .serif
    case .monospaced: return .monospaced
    case .rounded: return .rounded
    }
  }
}

// MARK: - Font Weights View
struct FontWeightsView: View {
  let sampleText: String
  let fontSize: CGFloat
  let design: Font.Design
  let lineSpacing: CGFloat
  let letterSpacing: CGFloat
  
  var body: some View {
    VStack(spacing: 16) {
      Text("字体权重对比")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      ForEach(FontWeightOption.allCases, id: \.self) { weight in
        FontSampleCard(
          title: weight.name,
          sampleText: sampleText,
          font: .system(size: fontSize, weight: weight.value, design: design),
          lineSpacing: lineSpacing,
          letterSpacing: letterSpacing,
          codeString: ".font(.system(size: \(Int(fontSize)), weight: .\(weightString(weight.value)), design: .\(designString(design)))))"
        )
      }
    }
  }
}

// MARK: - Font Sizes View
struct FontSizesView: View {
  let sampleText: String
  let weight: Font.Weight
  let design: Font.Design
  let lineSpacing: CGFloat
  let letterSpacing: CGFloat
  
  private let fontSizes: [CGFloat] = [12, 14, 16, 18, 20, 24, 28, 32, 36, 48]
  
  var body: some View {
    VStack(spacing: 16) {
      Text("字体大小对比")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      ForEach(Array(fontSizes.enumerated()), id: \.offset) { index, size in
        FontSampleCard(
          title: "\(Int(size))pt",
          sampleText: sampleText,
          font: .system(size: size, weight: weight, design: design),
          lineSpacing: lineSpacing,
          letterSpacing: letterSpacing,
          codeString: ".font(.system(size: \(Int(size)), weight: .\(weightString(weight)), design: .\(designString(design)))))"
        )
      }
    }
  }
}

// MARK: - Font Designs View
struct FontDesignsView: View {
  let sampleText: String
  let fontSize: CGFloat
  let weight: Font.Weight
  let lineSpacing: CGFloat
  let letterSpacing: CGFloat
  
  var body: some View {
    VStack(spacing: 16) {
      Text("字体设计对比")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      ForEach(FontDesignOption.allCases, id: \.self) { design in
        FontSampleCard(
          title: design.name,
          sampleText: sampleText,
          font: .system(size: fontSize, weight: weight, design: design.value),
          lineSpacing: lineSpacing,
          letterSpacing: letterSpacing,
          codeString: ".font(.system(size: \(Int(fontSize)), weight: .\(weightString(weight)), design: .\(designString(design.value)))))"
        )
      }
    }
  }
}

// MARK: - Font Hierarchy View
struct FontHierarchyView: View {
  let sampleText: String
  let design: Font.Design
  let lineSpacing: CGFloat
  let letterSpacing: CGFloat
  
  private let textStyles: [(String, Font, String)] = [
    ("大标题", .largeTitle, ".largeTitle"),
    ("标题", .title, ".title"),
    ("标题2", .title2, ".title2"),
    ("标题3", .title3, ".title3"),
    ("标题", .headline, ".headline"),
    ("副标题", .subheadline, ".subheadline"),
    ("正文", .body, ".body"),
    ("引用", .callout, ".callout"),
    ("脚注", .footnote, ".footnote"),
    ("说明", .caption, ".caption"),
    ("说明2", .caption2, ".caption2")
  ]
  
  var body: some View {
    VStack(spacing: 16) {
      Text("文本层级系统")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      ForEach(Array(textStyles.enumerated()), id: \.offset) { index, style in
        FontSampleCard(
          title: style.0,
          sampleText: sampleText,
          font: style.1,
          lineSpacing: lineSpacing,
          letterSpacing: letterSpacing,
          codeString: ".font(\(style.2))"
        )
      }
    }
  }
}

// MARK: - Font Accessibility View
struct FontAccessibilityView: View {
  let sampleText: String
  let fontSize: CGFloat
  let weight: Font.Weight
  let design: Font.Design
  
  @Environment(\.dynamicTypeSize) var dynamicTypeSize
  
  private let contentSizes: [DynamicTypeSize] = [
    .xSmall, .small, .medium, .large, .xLarge, .xxLarge, .xxxLarge,
    .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5
  ]
  
  var body: some View {
    VStack(spacing: 16) {
      Text("动态字体大小")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Text("当前系统设置: \(dynamicTypeSize.name)")
        .font(.caption)
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      ForEach(contentSizes, id: \.self) { size in
        FontSampleCard(
          title: size.name,
          sampleText: sampleText,
          font: .system(size: fontSize, weight: weight, design: design),
          lineSpacing: 2,
          letterSpacing: 0,
          codeString: "// 系统会自动适配动态字体大小",
          dynamicTypeSize: size
        )
      }
    }
  }
}

// MARK: - Font Sample Card
struct FontSampleCard: View {
  let title: String
  let sampleText: String
  let font: Font
  let lineSpacing: CGFloat
  let letterSpacing: CGFloat
  let codeString: String
  var dynamicTypeSize: DynamicTypeSize? = nil
  
  @State private var showCode = false
  @State private var showCopiedAlert = false
  
  var body: some View {
    VStack(spacing: 12) {
      // 标题和操作按钮
      HStack {
        Text(title)
          .font(.subheadline)
          .fontWeight(.medium)
        
        Spacer()
        
        HStack(spacing: 8) {
          Button(action: {
            showCode.toggle()
          }) {
            Image(systemName: showCode ? "chevron.up" : "chevron.down")
              .foregroundColor(.blue)
          }
          
          Button(action: {
            UIPasteboard.general.string = codeString
            showCopiedAlert = true
          }) {
            Image(systemName: "doc.on.doc")
              .foregroundColor(.blue)
          }
        }
      }
      
      // 文本预览
      Group {
        if let dynamicSize = dynamicTypeSize {
          Text(sampleText)
            .font(font)
            .lineSpacing(lineSpacing)
            .kerning(letterSpacing)
            .environment(\.dynamicTypeSize, dynamicSize)
        } else {
          Text(sampleText)
            .font(font)
            .lineSpacing(lineSpacing)
            .kerning(letterSpacing)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .multilineTextAlignment(.leading)
      
      // 代码展示
      if showCode {
        Text(codeString)
          .font(.system(.caption, design: .monospaced))
          .foregroundColor(.secondary)
          .padding(8)
          .background(Color(.systemGray6))
          .clipShape(RoundedRectangle(cornerRadius: 6))
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .padding()
    .background(Color(.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(Color(.separator), lineWidth: 0.5)
    )
    .alert("已复制", isPresented: $showCopiedAlert) {
      Button("确定") { }
    } message: {
      Text("代码已复制到剪贴板")
    }
  }
}

// MARK: - Helper Functions
private func weightString(_ weight: Font.Weight) -> String {
  switch weight {
  case .ultraLight: return "ultraLight"
  case .thin: return "thin"
  case .light: return "light"
  case .regular: return "regular"
  case .medium: return "medium"
  case .semibold: return "semibold"
  case .bold: return "bold"
  case .heavy: return "heavy"
  case .black: return "black"
  default: return "regular"
  }
}

private func designString(_ design: Font.Design) -> String {
  switch design {
  case .default: return "default"
  case .serif: return "serif"
  case .monospaced: return "monospaced"
  case .rounded: return "rounded"
  @unknown default: return "default"
  }
}

// MARK: - Extensions
extension DynamicTypeSize {
  var name: String {
    switch self {
    case .xSmall: return "超小"
    case .small: return "小"
    case .medium: return "中"
    case .large: return "大（默认）"
    case .xLarge: return "超大"
    case .xxLarge: return "特大"
    case .xxxLarge: return "超特大"
    case .accessibility1: return "无障碍1"
    case .accessibility2: return "无障碍2"
    case .accessibility3: return "无障碍3"
    case .accessibility4: return "无障碍4"
    case .accessibility5: return "无障碍5"
    @unknown default: return "未知"
    }
  }
}

#Preview {
  FontLibraryView()
}
