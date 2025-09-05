//
//  ColorCards.swift
//  SwiftBaseApp
//
//  Created by Assistant on 2025/1/14.
//

import SwiftUI

// MARK: - System Color Card
struct SystemColorCard: View {
  let systemColor: SystemColor
  let format: ColorFormat
  var isCompact: Bool = false
  let onCopy: (String) -> Void
  
  @State private var showDetails = false
  
  var body: some View {
    VStack(spacing: 0) {
      // 颜色展示区
      RoundedRectangle(cornerRadius: isCompact ? 8 : 12)
        .fill(systemColor.color)
        .frame(height: isCompact ? 60 : 80)
        .overlay(
          RoundedRectangle(cornerRadius: isCompact ? 8 : 12)
            .stroke(Color(.separator), lineWidth: 0.5)
        )
      
      // 信息区域
      VStack(alignment: .leading, spacing: isCompact ? 4 : 8) {
        // 颜色名称
        Text(systemColor.name)
          .font(isCompact ? .caption : .subheadline)
          .fontWeight(.medium)
          .lineLimit(1)
        
        if !isCompact {
          // 颜色描述
          Text(systemColor.description)
            .font(.caption)
            .foregroundColor(.secondary)
            .lineLimit(2)
          
          // 颜色值
          Text(colorValue)
            .font(.system(.caption2, design: .monospaced))
            .foregroundColor(.blue)
            .lineLimit(1)
        }
        
        // 操作按钮
        HStack(spacing: 8) {
          if !isCompact {
            Button(action: {
              showDetails.toggle()
            }) {
              Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
          }
          
          Button(action: {
            copyColorValue()
          }) {
            Image(systemName: "doc.on.doc")
              .font(.caption)
              .foregroundColor(.blue)
          }
          
          Button(action: {
            copySwiftUICode()
          }) {
            Image(systemName: "swift")
              .font(.caption)
              .foregroundColor(.orange)
          }
        }
      }
      .padding(isCompact ? 8 : 12)
      
      // 详细信息（展开状态）
      if showDetails && !isCompact {
        VStack(spacing: 8) {
          Divider()
          
          detailsSection
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
      }
    }
    .background(Color(.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: isCompact ? 10 : 14))
    .overlay(
      RoundedRectangle(cornerRadius: isCompact ? 10 : 14)
        .stroke(Color(.separator), lineWidth: 0.5)
    )
    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
  }
  
  // MARK: - Details Section
  private var detailsSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      // 颜色值展示
      VStack(alignment: .leading, spacing: 4) {
        Text("颜色值")
          .font(.caption)
          .fontWeight(.medium)
          .foregroundColor(.secondary)
        
        VStack(alignment: .leading, spacing: 2) {
          ColorValueRow(title: "HEX", value: hexValue, onCopy: onCopy)
          ColorValueRow(title: "RGB", value: rgbValue, onCopy: onCopy)
          ColorValueRow(title: "HSB", value: hsbValue, onCopy: onCopy)
        }
      }
      
      // 代码示例
      VStack(alignment: .leading, spacing: 4) {
        Text("代码示例")
          .font(.caption)
          .fontWeight(.medium)
          .foregroundColor(.secondary)
        
        VStack(alignment: .leading, spacing: 2) {
          CodeRow(title: "SwiftUI", code: systemColor.swiftUICode, onCopy: onCopy)
          CodeRow(title: "UIKit", code: systemColor.uiKitCode, onCopy: onCopy)
        }
      }
    }
  }
  
  // MARK: - Computed Properties
  private var colorValue: String {
    switch format {
    case .hex: return hexValue
    case .rgb: return rgbValue
    case .hsb: return hsbValue
    }
  }
  
  private var hexValue: String {
    systemColor.color.toHex()
  }
  
  private var rgbValue: String {
    let rgb = systemColor.color.toRGB()
    return "rgb(\(rgb.red), \(rgb.green), \(rgb.blue))"
  }
  
  private var hsbValue: String {
    let hsb = systemColor.color.toHSB()
    return "hsb(\(hsb.hue)°, \(hsb.saturation)%, \(hsb.brightness)%)"
  }
  
  // MARK: - Actions
  private func copyColorValue() {
    UIPasteboard.general.string = colorValue
    onCopy("已复制颜色值：\(colorValue)")
  }
  
  private func copySwiftUICode() {
    UIPasteboard.general.string = systemColor.swiftUICode
    onCopy("已复制 SwiftUI 代码")
  }
}

// MARK: - Custom Color Card
struct CustomColorCard: View {
  let customColor: CustomColor
  let format: ColorFormat
  let onCopy: (String) -> Void
  let onDelete: () -> Void
  
  @State private var showingColorPicker = false
  @State private var selectedColor: Color
  @State private var colorName: String
  
  init(customColor: CustomColor, format: ColorFormat, onCopy: @escaping (String) -> Void, onDelete: @escaping () -> Void) {
    self.customColor = customColor
    self.format = format
    self.onCopy = onCopy
    self.onDelete = onDelete
    self._selectedColor = State(initialValue: customColor.color)
    self._colorName = State(initialValue: customColor.name)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      // 颜色展示区
      RoundedRectangle(cornerRadius: 12)
        .fill(selectedColor)
        .frame(height: 80)
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color(.separator), lineWidth: 0.5)
        )
        .onTapGesture {
          showingColorPicker = true
        }
      
      // 信息区域
      VStack(alignment: .leading, spacing: 8) {
        // 颜色名称（可编辑）
        TextField("颜色名称", text: $colorName)
          .font(.subheadline)
          .fontWeight(.medium)
          .textFieldStyle(PlainTextFieldStyle())
        
        // 颜色描述
        Text(customColor.description)
          .font(.caption)
          .foregroundColor(.secondary)
          .lineLimit(2)
        
        // 颜色值
        Text(colorValue)
          .font(.system(.caption2, design: .monospaced))
          .foregroundColor(.blue)
          .lineLimit(1)
        
        // 操作按钮
        HStack(spacing: 8) {
          Button(action: {
            showingColorPicker = true
          }) {
            Image(systemName: "eyedropper")
              .font(.caption)
              .foregroundColor(.blue)
          }
          
          Spacer()
          
          Button(action: {
            copyColorValue()
          }) {
            Image(systemName: "doc.on.doc")
              .font(.caption)
              .foregroundColor(.blue)
          }
          
          Button(action: onDelete) {
            Image(systemName: "trash")
              .font(.caption)
              .foregroundColor(.red)
          }
        }
      }
      .padding(12)
    }
    .background(Color(.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 14))
    .overlay(
      RoundedRectangle(cornerRadius: 14)
        .stroke(Color(.separator), lineWidth: 0.5)
    )
    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    .sheet(isPresented: $showingColorPicker) {
      ColorPicker("选择颜色", selection: $selectedColor)
        .padding()
        .presentationDetents([.medium])
    }
  }
  
  // MARK: - Computed Properties
  private var colorValue: String {
    switch format {
    case .hex: return selectedColor.toHex()
    case .rgb:
      let rgb = selectedColor.toRGB()
      return "rgb(\(rgb.red), \(rgb.green), \(rgb.blue))"
    case .hsb:
      let hsb = selectedColor.toHSB()
      return "hsb(\(hsb.hue)°, \(hsb.saturation)%, \(hsb.brightness)%)"
    }
  }
  
  // MARK: - Actions
  private func copyColorValue() {
    UIPasteboard.general.string = colorValue
    onCopy("已复制颜色值：\(colorValue)")
  }
}

// MARK: - Helper Views

struct ColorValueRow: View {
  let title: String
  let value: String
  let onCopy: (String) -> Void
  
  var body: some View {
    HStack {
      Text(title)
        .font(.caption2)
        .foregroundColor(.secondary)
        .frame(width: 30, alignment: .leading)
      
      Text(value)
        .font(.system(.caption2, design: .monospaced))
        .foregroundColor(.primary)
      
      Spacer()
      
      Button(action: {
        UIPasteboard.general.string = value
        onCopy("已复制：\(value)")
      }) {
        Image(systemName: "doc.on.doc")
          .font(.caption2)
          .foregroundColor(.blue)
      }
    }
  }
}

struct CodeRow: View {
  let title: String
  let code: String
  let onCopy: (String) -> Void
  
  var body: some View {
    HStack {
      Text(title)
        .font(.caption2)
        .foregroundColor(.secondary)
        .frame(width: 50, alignment: .leading)
      
      Text(code)
        .font(.system(.caption2, design: .monospaced))
        .foregroundColor(.primary)
        .lineLimit(1)
      
      Spacer()
      
      Button(action: {
        UIPasteboard.general.string = code
        onCopy("已复制代码")
      }) {
        Image(systemName: "doc.on.doc")
          .font(.caption2)
          .foregroundColor(.blue)
      }
    }
  }
}

// MARK: - Color Extensions
extension Color {
  func toHex() -> String {
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
  
  func toRGB() -> (red: Int, green: Int, blue: Int) {
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
  
  func toHSB() -> (hue: Int, saturation: Int, brightness: Int) {
    let uiColor = UIColor(self)
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0
    
    uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    
    return (
      hue: Int(hue * 360),
      saturation: Int(saturation * 100),
      brightness: Int(brightness * 100)
    )
  }
}

#Preview {
  VStack {
    SystemColorCard(
      systemColor: SystemColor(
        name: "System Blue",
        color: .blue,
        description: "系统蓝色，用于链接和按钮",
        swiftUICode: "Color.blue",
        uiKitCode: "UIColor.systemBlue"
      ),
      format: .hex,
      onCopy: { _ in }
    )
    
    CustomColorCard(
      customColor: CustomColor(
        name: "自定义蓝色",
        color: .blue,
        description: "用户自定义颜色"
      ),
      format: .hex,
      onCopy: { _ in },
      onDelete: { }
    )
  }
  .padding()
}
