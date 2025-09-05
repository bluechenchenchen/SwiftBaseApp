//
//  FontCodeGeneratorView.swift
//  SwiftBaseApp
//
//  Created by Assistant on 2025/1/14.
//

import SwiftUI

struct FontCodeGeneratorView: View {
  let fontSize: CGFloat
  let weight: Font.Weight
  let design: Font.Design
  let lineSpacing: CGFloat
  let letterSpacing: CGFloat
  
  @State private var selectedFramework: CodeFramework = .swiftUI
  @State private var includeModifiers = true
  @State private var includeComments = true
  @State private var showCopiedAlert = false
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 20) {
          // 配置选项
          configurationSection
          
          Divider()
          
          // 代码预览
          codePreviewSection
          
          Divider()
          
          // 示例代码
          exampleCodeSection
        }
        .padding()
      }
      .navigationTitle("字体代码生成器")
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
          ForEach(CodeFramework.allCases, id: \.self) { framework in
            Text(framework.name).tag(framework)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      }
      
      // 选项开关
      VStack(alignment: .leading, spacing: 12) {
        Toggle("包含修饰符代码", isOn: $includeModifiers)
        Toggle("包含注释说明", isOn: $includeComments)
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
    }
  }
  
  // MARK: - Example Code Section
  private var exampleCodeSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("使用示例")
        .font(.headline)
      
      ForEach(codeExamples, id: \.title) { example in
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Text(example.title)
              .font(.subheadline)
              .fontWeight(.medium)
            
            Spacer()
            
            Button("复制") {
              UIPasteboard.general.string = example.code
              showCopiedAlert = true
            }
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(.systemGray4))
            .foregroundColor(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 4))
          }
          
          Text(example.code)
            .font(.system(.caption, design: .monospaced))
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
    }
  }
  
  // MARK: - Computed Properties
  private var generatedCode: String {
    switch selectedFramework {
    case .swiftUI:
      return generateSwiftUICode()
    case .uiKit:
      return generateUIKitCode()
    }
  }
  
  private var codeExamples: [CodeExample] {
    switch selectedFramework {
    case .swiftUI:
      return swiftUIExamples
    case .uiKit:
      return uiKitExamples
    }
  }
  
  // MARK: - Code Generation
  private func generateSwiftUICode() -> String {
    var code = ""
    
    if includeComments {
      code += "// 字体配置\n"
    }
    
    // 基础字体设置
    let weightString = fontWeightString(weight)
    let designString = fontDesignString(design)
    
    code += ".font(.system(size: \(Int(fontSize)), weight: .\(weightString), design: .\(designString)))"
    
    if includeModifiers {
      if lineSpacing > 0 {
        code += "\n.lineSpacing(\(lineSpacing))"
      }
      
      if letterSpacing != 0 {
        code += "\n.kerning(\(letterSpacing))"
      }
      
      if includeComments {
        code += "\n// .foregroundColor(.primary) // 文字颜色"
        code += "\n// .multilineTextAlignment(.leading) // 文字对齐"
      }
    }
    
    return code
  }
  
  private func generateUIKitCode() -> String {
    var code = ""
    
    if includeComments {
      code += "// UIFont 配置\n"
    }
    
    let weightString = uiKitWeight(from: weight)
    let designString = uiKitDesign(from: design)
    
    code += "let font = UIFont.systemFont(ofSize: \(fontSize), weight: .\(weightString))\n"
    
    if design != .default {
      code += "// 字体设计样式需要使用 UIFontDescriptor\n"
      code += "let descriptor = font.fontDescriptor.withDesign(.\(designString))\n"
      code += "let finalFont = UIFont(descriptor: descriptor!, size: \(fontSize))\n"
    }
    
    if includeModifiers {
      code += "\n// 应用到 UILabel\n"
      code += "label.font = \(design != .default ? "finalFont" : "font")\n"
      
      if includeComments {
        code += "// label.textColor = .label // 文字颜色\n"
        code += "// label.textAlignment = .left // 文字对齐\n"
      }
    }
    
    return code
  }
  
  private func uiKitWeight(from weight: Font.Weight) -> String {
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
  
  private func uiKitDesign(from design: Font.Design) -> String {
    switch design {
    case .default: return "default"
    case .serif: return "serif"
    case .monospaced: return "monospaced"
    case .rounded: return "rounded"
    @unknown default: return "default"
    }
  }
  
  private func copyAllCode() {
    let allCode = """
        \(generatedCode)
        
        /* 使用示例 */
        \(codeExamples.map { "\($0.title):\n\($0.code)" }.joined(separator: "\n\n"))
        """
    
    UIPasteboard.general.string = allCode
    showCopiedAlert = true
  }
  
  // MARK: - Example Data
  private var swiftUIExamples: [CodeExample] {
    [
      CodeExample(
        title: "Text 组件",
        code: """
                Text("示例文本")
                    \(generatedCode)
                """
      ),
      CodeExample(
        title: "Button 组件",
        code: """
                Button("按钮文字") {
                    // 按钮动作
                }
                \(generatedCode)
                """
      ),
      CodeExample(
        title: "Label 组件",
        code: """
                Label("标签文字", systemImage: "star")
                    \(generatedCode)
                """
      ),
      CodeExample(
        title: "NavigationTitle",
        code: """
                .navigationTitle("标题")
                .navigationBarTitleDisplayMode(.large)
                """
      )
    ]
  }
  
  private var uiKitExamples: [CodeExample] {
    [
      CodeExample(
        title: "UILabel",
        code: """
                let label = UILabel()
                \(generatedCode)
                label.text = "示例文本"
                label.numberOfLines = 0
                """
      ),
      CodeExample(
        title: "UIButton",
        code: """
                let button = UIButton(type: .system)
                button.setTitle("按钮文字", for: .normal)
                button.titleLabel?.font = \(design != .default ? "finalFont" : "font")
                """
      ),
      CodeExample(
        title: "UITextField",
        code: """
                let textField = UITextField()
                textField.font = \(design != .default ? "finalFont" : "font")
                textField.placeholder = "占位符文本"
                """
      ),
      CodeExample(
        title: "UITextView",
        code: """
                let textView = UITextView()
                textView.font = \(design != .default ? "finalFont" : "font")
                textView.text = "文本内容"
                """
      )
    ]
  }
  
  // MARK: - Helper Functions
  private func fontWeightString(_ weight: Font.Weight) -> String {
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
  
  private func fontDesignString(_ design: Font.Design) -> String {
    switch design {
    case .default: return "default"
    case .serif: return "serif"
    case .monospaced: return "monospaced"
    case .rounded: return "rounded"
    @unknown default: return "default"
    }
  }
}

// MARK: - Supporting Types

enum CodeFramework: CaseIterable {
  case swiftUI, uiKit
  
  var name: String {
    switch self {
    case .swiftUI: return "SwiftUI"
    case .uiKit: return "UIKit"
    }
  }
}

struct CodeExample {
  let title: String
  let code: String
}

#Preview {
  FontCodeGeneratorView(
    fontSize: 17,
    weight: .regular,
    design: .default,
    lineSpacing: 4,
    letterSpacing: 0
  )
}
