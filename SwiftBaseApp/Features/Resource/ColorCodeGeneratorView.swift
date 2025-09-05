//
//  ColorCodeGeneratorView.swift
//  SwiftBaseApp
//
//  Created by Assistant on 2025/1/14.
//

import SwiftUI

struct ColorCodeGeneratorView: View {
  @State private var selectedColor: Color = .blue
  @State private var colorName: String = "customColor"
  @State private var selectedFramework: ColorCodeFramework = .swiftUI
  @State private var includeAlpha: Bool = false
  @State private var alphaValue: Double = 1.0
  @State private var showCopiedAlert = false
  @State private var generatedColorExtensions: [ColorExtension] = []
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 20) {
          // 颜色选择器
          colorPickerSection
          
          Divider()
          
          // 配置选项
          configurationSection
          
          Divider()
          
          // 代码预览
          codePreviewSection
          
          Divider()
          
          // 颜色扩展工具
          colorExtensionsSection
        }
        .padding()
      }
      .navigationTitle("颜色代码生成器")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("关闭") {
            dismiss()
          }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("复制全部") {
            copyAllCode()
          }
          .fontWeight(.semibold)
        }
      }
    }
    .alert("已复制", isPresented: $showCopiedAlert) {
      Button("确定") { }
    } message: {
      Text("代码已复制到剪贴板")
    }
    .onAppear {
      generateColorExtensions()
    }
    .onChange(of: selectedColor) { _ in
      generateColorExtensions()
    }
  }
  
  // MARK: - Color Picker Section
  private var colorPickerSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("颜色选择")
        .font(.headline)
      
      HStack(spacing: 16) {
        // 颜色预览
        RoundedRectangle(cornerRadius: 12)
          .fill(finalColor)
          .frame(width: 80, height: 80)
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(Color(.separator), lineWidth: 1)
          )
        
        VStack(alignment: .leading, spacing: 12) {
          // 颜色选择器
          ColorPicker("选择颜色", selection: $selectedColor, supportsOpacity: false)
          
          // 颜色名称
          VStack(alignment: .leading, spacing: 4) {
            Text("颜色名称")
              .font(.caption)
              .foregroundColor(.secondary)
            
            TextField("颜色变量名", text: $colorName)
              .textFieldStyle(RoundedBorderTextFieldStyle())
          }
        }
      }
      
      // 透明度控制
      if includeAlpha {
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Text("透明度")
              .font(.subheadline)
              .fontWeight(.medium)
            
            Spacer()
            
            Text("\(Int(alphaValue * 100))%")
              .font(.caption)
              .foregroundColor(.secondary)
          }
          
          Slider(value: $alphaValue, in: 0...1, step: 0.01)
            .accentColor(selectedColor)
        }
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
  
  // MARK: - Configuration Section
  private var configurationSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("生成选项")
        .font(.headline)
      
      // 框架选择
      VStack(alignment: .leading, spacing: 8) {
        Text("目标框架")
          .font(.subheadline)
          .fontWeight(.medium)
        
        Picker("框架", selection: $selectedFramework) {
          ForEach(ColorCodeFramework.allCases, id: \.self) { framework in
            Text(framework.name).tag(framework)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      }
      
      // 选项开关
      VStack(alignment: .leading, spacing: 8) {
        Toggle("包含透明度", isOn: $includeAlpha)
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
  
  // MARK: - Code Preview Section
  private var codePreviewSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack {
        Text("生成的代码")
          .font(.headline)
        
        Spacer()
        
        Button("复制") {
          UIPasteboard.general.string = generatedCode
          showCopiedAlert = true
        }
        .font(.caption)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 6))
      }
      
      ScrollView(.horizontal, showsIndicators: false) {
        Text(generatedCode)
          .font(.system(.body, design: .monospaced))
          .padding()
          .background(Color(.systemGray6))
          .clipShape(RoundedRectangle(cornerRadius: 8))
      }
      
      // 使用示例
      VStack(alignment: .leading, spacing: 8) {
        Text("使用示例")
          .font(.subheadline)
          .fontWeight(.medium)
        
        Text(usageExample)
          .font(.system(.caption, design: .monospaced))
          .padding(12)
          .background(Color(.systemGray6))
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
  
  // MARK: - Color Extensions Section
  private var colorExtensionsSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("颜色工具")
        .font(.headline)
      
      LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
        ForEach(generatedColorExtensions) { colorExtension in
          ColorExtensionCard(
            colorExtension: colorExtension,
            onCopy: {
              UIPasteboard.general.string = colorExtension.code
              showCopiedAlert = true
            }
          )
        }
      }
    }
  }
  
  // MARK: - Computed Properties
  private var finalColor: Color {
    if includeAlpha {
      return selectedColor.opacity(alphaValue)
    } else {
      return selectedColor
    }
  }
  
  private var generatedCode: String {
    switch selectedFramework {
    case .swiftUI:
      return generateSwiftUICode()
    case .uiKit:
      return generateUIKitCode()
    }
  }
  
  private var usageExample: String {
    switch selectedFramework {
    case .swiftUI:
      return """
            Text("Hello World")
                .foregroundColor(.\(colorName))
                .background(.\(colorName))
            """
    case .uiKit:
      return """
            label.textColor = .\(colorName)
            view.backgroundColor = .\(colorName)
            """
    }
  }
  
  // MARK: - Code Generation
  private func generateSwiftUICode() -> String {
    let rgb = selectedColor.colorToRGB()
    let hex = selectedColor.colorToHex()
    
    var code = "// MARK: - Custom Color\n"
    code += "extension Color {\n"
    
    if includeAlpha {
      code += "    static let \(colorName) = Color(red: \(Double(rgb.red)/255), green: \(Double(rgb.green)/255), blue: \(Double(rgb.blue)/255)).opacity(\(alphaValue))\n"
    } else {
      code += "    static let \(colorName) = Color(red: \(Double(rgb.red)/255), green: \(Double(rgb.green)/255), blue: \(Double(rgb.blue)/255))\n"
    }
    
    code += "    \n"
    code += "    // 十六进制: \(hex)\n"
    code += "    // RGB: rgb(\(rgb.red), \(rgb.green), \(rgb.blue))\n"
    
    if includeAlpha {
      code += "    // Alpha: \(alphaValue)\n"
    }
    
    code += "}"
    
    return code
  }
  
  private func generateUIKitCode() -> String {
    let rgb = selectedColor.colorToRGB()
    let hex = selectedColor.colorToHex()
    
    var code = "// MARK: - Custom Color\n"
    code += "extension UIColor {\n"
    
    if includeAlpha {
      code += "    static let \(colorName) = UIColor(red: \(Double(rgb.red)/255), green: \(Double(rgb.green)/255), blue: \(Double(rgb.blue)/255), alpha: \(alphaValue))\n"
    } else {
      code += "    static let \(colorName) = UIColor(red: \(Double(rgb.red)/255), green: \(Double(rgb.green)/255), blue: \(Double(rgb.blue)/255), alpha: 1.0)\n"
    }
    
    code += "    \n"
    code += "    // 十六进制: \(hex)\n"
    code += "    // RGB: rgb(\(rgb.red), \(rgb.green), \(rgb.blue))\n"
    
    if includeAlpha {
      code += "    // Alpha: \(alphaValue)\n"
    }
    
    code += "}"
    
    return code
  }
  
  private func copyAllCode() {
    let allCode = """
        \(generatedCode)
        
        /* 使用示例 */
        \(usageExample)
        
        /* 颜色扩展工具 */
        \(generatedColorExtensions.map { $0.code }.joined(separator: "\n\n"))
        """
    
    UIPasteboard.general.string = allCode
    showCopiedAlert = true
  }
  
  private func generateColorExtensions() {
    let rgb = selectedColor.colorToRGB()
    let originalColor = selectedColor
    
    generatedColorExtensions = [
      ColorExtension(
        name: "浅色变体",
        color: originalColor.opacity(0.3),
        description: "30% 透明度",
        code: "Color.\(colorName).opacity(0.3)"
      ),
      ColorExtension(
        name: "深色变体",
        color: Color(red: Double(rgb.red)/255 * 0.7, green: Double(rgb.green)/255 * 0.7, blue: Double(rgb.blue)/255 * 0.7),
        description: "70% 亮度",
        code: "Color(red: \(Double(rgb.red)/255 * 0.7), green: \(Double(rgb.green)/255 * 0.7), blue: \(Double(rgb.blue)/255 * 0.7))"
      ),
      ColorExtension(
        name: "补色",
        color: Color(red: 1 - Double(rgb.red)/255, green: 1 - Double(rgb.green)/255, blue: 1 - Double(rgb.blue)/255),
        description: "色彩反转",
        code: "Color(red: \(1 - Double(rgb.red)/255), green: \(1 - Double(rgb.green)/255), blue: \(1 - Double(rgb.blue)/255))"
      ),
      ColorExtension(
        name: "灰度版本",
        color: Color.gray.opacity(Double(rgb.red + rgb.green + rgb.blue) / (255 * 3)),
        description: "去饱和度",
        code: "Color.gray.opacity(\(Double(rgb.red + rgb.green + rgb.blue) / (255 * 3)))"
      )
    ]
  }
}

// MARK: - Color Extension Card
struct ColorExtensionCard: View {
  let colorExtension: ColorExtension
  let onCopy: () -> Void
  
  var body: some View {
    VStack(spacing: 8) {
      // 颜色预览
      RoundedRectangle(cornerRadius: 8)
        .fill(colorExtension.color)
        .frame(height: 40)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color(.separator), lineWidth: 0.5)
        )
      
      // 信息
      VStack(alignment: .leading, spacing: 4) {
        Text(colorExtension.name)
          .font(.caption)
          .fontWeight(.medium)
        
        Text(colorExtension.description)
          .font(.caption2)
          .foregroundColor(.secondary)
        
        // 复制按钮
        Button(action: onCopy) {
          HStack {
            Image(systemName: "doc.on.doc")
              .font(.caption2)
            Text("复制")
              .font(.caption2)
          }
          .foregroundColor(.blue)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(8)
    .background(Color(.systemGray6))
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

// MARK: - Supporting Types
struct ColorExtension: Identifiable {
  let id = UUID()
  let name: String
  let color: Color
  let description: String
  let code: String
}

enum ColorCodeFramework: CaseIterable {
  case swiftUI, uiKit
  
  var name: String {
    switch self {
    case .swiftUI: return "SwiftUI"
    case .uiKit: return "UIKit"
    }
  }
}

// MARK: - Color Extensions
extension Color {
  func colorToHex() -> String {
    let uiColor = UIColor(self)
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    
    uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    let r = Int(red * 255)
    let g = Int(green * 255)
    let b = Int(blue * 255)
    
    return String(format: "#%02X%02X%02X", r, g, b)
  }
  
  func colorToRGB() -> (red: Int, green: Int, blue: Int) {
    let uiColor = UIColor(self)
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    
    uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    return (
      red: Int(red * 255),
      green: Int(green * 255),
      blue: Int(blue * 255)
    )
  }
}

#Preview {
  ColorCodeGeneratorView()
}
