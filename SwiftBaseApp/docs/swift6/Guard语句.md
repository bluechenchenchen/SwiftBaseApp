# Swift Guard 语句指南（面向前端开发者）

## 1. 什么是 guard let？

guard let 是 Swift 中的一种特殊的条件语句，主要用于提前退出函数或方法。你可以把它理解为一个"门卫"，它会检查条件是否满足：

- 如果条件满足，代码继续执行
- 如果条件不满足，必须退出当前作用域

### 1.1 与 JavaScript 的对比

```javascript
// JavaScript 中的提前返回
function processUser(user) {
  if (!user) {
    console.log("无效用户");
    return;
  }
  // 这里确保 user 存在
  console.log(user.name);
}
```

```swift
// Swift 中的 guard let
func processUser(user: User?) {
    guard let user = user else {
        print("无效用户")
        return
    }
    // 这里的 user 已解包，确保有值
    print(user.name)
}
```

## 2. guard let 的特点

### 2.1 主要特点

1. **提前退出**

   - guard 强制要求在条件不满足时提前退出
   - 避免深层嵌套的 if-else 结构
   - 使代码更清晰、更易读

2. **条件必须有 else 子句**

   - else 子句必须退出当前作用域（使用 return, break, continue, throw 等）
   - 这保证了代码的安全性

3. **变量解包后仍然可用**
   - 通过 guard 解包的可选值，在后续代码中仍然可以使用
   - 这是与 if let 的一个重要区别

### 2.2 与 if let 的对比

```swift
// 使用 if let
func processUser1(name: String?) {
    if let name = name {
        // name 只在这个作用域内可用
        print("欢迎, \(name)")
    } else {
        print("无效的用户名")
        return
    }
    // 这里不能使用 name
}

// 使用 guard let
func processUser2(name: String?) {
    guard let name = name else {
        print("无效的用户名")
        return
    }
    // name 在这里可以使用
    print("欢迎, \(name)")
    // name 在函数剩余部分都可以使用
}
```

## 3. 常见使用场景

### 3.1 参数验证

```swift
func createUser(name: String?, age: Int?, email: String?) {
    // 验证所有必需参数
    guard let name = name, !name.isEmpty else {
        print("名字不能为空")
        return
    }

    guard let age = age, age >= 18 else {
        print("年龄必须大于或等于18岁")
        return
    }

    guard let email = email, email.contains("@") else {
        print("邮箱格式无效")
        return
    }

    // 所有验证通过，可以使用解包后的值
    print("创建用户: \(name), \(age)岁, \(email)")
}
```

### 3.2 API 响应处理

```swift
struct APIResponse {
    let data: Data?
    let error: Error?
}

func handleResponse(_ response: APIResponse) {
    // 检查错误
    guard response.error == nil else {
        print("错误: \(response.error!.localizedDescription)")
        return
    }

    // 确保有数据
    guard let data = response.data else {
        print("没有数据")
        return
    }

    // 处理数据...
    print("成功获取数据：\(data)")
}
```

### 3.3 多条件验证

```swift
func validateUserInput(name: String?, age: Int?, email: String?) {
    guard let name = name,
          let age = age,
          let email = email else {
        print("所有字段都必须填写")
        return
    }

    guard !name.isEmpty else {
        print("名字不能为空")
        return
    }

    guard age >= 18 else {
        print("必须年满18岁")
        return
    }

    guard email.contains("@") else {
        print("邮箱格式无效")
        return
    }

    // 所有验证通过
    print("验证通过")
}
```

## 4. 最佳实践

### 4.1 推荐用法

1. 在函数开始处验证参数
2. 处理多个可选值时
3. 需要提前退出的场景
4. 检查必要的前置条件

```swift
func processPayment(user: User?, amount: Double?) {
    // 1. 验证用户
    guard let user = user else {
        print("用户不存在")
        return
    }

    // 2. 验证金额
    guard let amount = amount, amount > 0 else {
        print("无效的金额")
        return
    }

    // 3. 验证用户余额
    guard user.balance >= amount else {
        print("余额不足")
        return
    }

    // 所有条件满足，处理支付
    print("处理支付：\(user.name) - ¥\(amount)")
}
```

### 4.2 不推荐的用法

1. 不要过度使用 guard

```swift
// ❌ 过度使用
func processData(data: String?) {
    guard let data = data else { return }
    guard data.count > 0 else { return }
    guard data != "invalid" else { return }
    // ...
}

// ✅ 合理使用
func processData(data: String?) {
    guard let data = data,
          data.count > 0,
          data != "invalid" else {
        print("无效数据")
        return
    }
    // ...
}
```

2. 避免复杂的 else 块

```swift
// ❌ 复杂的 else 块
guard let user = user else {
    print("错误")
    loadDefaultUser()
    updateUI()
    return
}

// ✅ 保持简单
guard let user = user else {
    handleUserError()
    return
}
```

## 5. 使用技巧

### 5.1 组合条件

```swift
func validateUser(age: Int?, hasPermission: Bool?) {
    guard let age = age,
          let hasPermission = hasPermission,
          age >= 18 && hasPermission else {
        print("访问被拒绝")
        return
    }

    print("访问granted")
}
```

### 5.2 使用 where 子句

```swift
func processNumbers(_ numbers: [Int]?) {
    guard let numbers = numbers where numbers.count > 0 else {
        print("数组为空")
        return
    }

    print("处理 \(numbers.count) 个数字")
}
```

## 6. 常见问题

### Q1: 什么时候使用 guard let，什么时候使用 if let？

A:

- 使用 guard let 当：

  1. 需要提前退出
  2. 解包的值在后续代码中都需要使用
  3. 有多个条件需要检查

- 使用 if let 当：
  1. 只需要在特定条件下执行代码
  2. 解包的值只在小范围内使用
  3. 有多个分支需要处理

### Q2: guard let 能替代所有的 if let 吗？

A: 不能。每种方式都有其适用场景。guard let 主要用于提前退出场景，而 if let 更适合条件分支处理。

### Q3: guard let 后的 else 必须要 return 吗？

A: else 块必须退出当前作用域，可以使用：

- return
- break
- continue
- throw
- fatalError()

## 7. 与前端开发的对比

| JavaScript                              | Swift                                                  |
| --------------------------------------- | ------------------------------------------------------ | ------------ | -------------------------------------------- |
| `if (!user) return;`                    | `guard let user = user else { return }`                |
| `if (!data) { handleError(); return; }` | `guard let data = data else { handleError(); return }` |
| `if (!a                                 |                                                        | !b) return;` | `guard let a = a, let b = b else { return }` |

## 8. 总结

guard let 是 Swift 中一个强大的控制流工具，它：

1. 提高代码的可读性
2. 减少嵌套层级
3. 确保代码安全性
4. 使错误处理更清晰

记住：guard let 不是为了替代 if let，而是提供了一种更清晰的方式来处理提前退出的场景。
