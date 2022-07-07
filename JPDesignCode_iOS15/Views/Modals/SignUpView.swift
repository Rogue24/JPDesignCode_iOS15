//
//  SignUpView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/26.
//

import SwiftUI

struct SignUpView: View {
    enum Field: Hashable {
        case email
        case password
    }
    
    @State var email = ""
    @State var password = ""
    // 聚焦状态（用于标记第一响应者）
    @FocusState var focusedField: Field?
    @State var emailY: CGFloat = 0
    @State var passwordY: CGFloat = 0
    @State var circleY: CGFloat = 0
    @State var circleColor: Color = .blue
    @State var appear = [false, false, false]
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sign Up")
                .font(.largeTitle.bold())
                .opacity(appear[0] ? 1 : 0)
                .offset(y: appear[0] ? 0 : 20)
            
            Text("Access 999+ hours of courses, tutorials and livestreams")
                .font(.headline)
                .opacity(appear[1] ? 1 : 0)
                .offset(y: appear[1] ? 0 : 20)
            
            // 可以对`Group`中所有的`View`统一添加`Modifier`，
            // 不必再对每个`View`都设置同样的`Modifier`了，减少大量重复代码。
            Group {
                TextField("Email", text: $email)
                    .inputStyle(icon: "mail")
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    // 关闭自动大写
                    .autocapitalization(.none)
                    // 禁用自动校正
                    .disableAutocorrection(true)
                    // 绑定聚焦状态（当成为第一响应者时，`focusedField`会修改为`.email`）
                    .focused($focusedField, equals: .email)
                    .shadow(color: focusedField == .email ? .primary.opacity(0.3) : .clear, radius: 10, x: 0, y: 3)
                    // 监听当前`View`在父视图上的坐标
                    .overlay(geometry)
                    // 监听坐标的回调闭包
                    .onPreferenceChange(CirclePreferenceKey.self) { value in
                        emailY = value
                        if circleY == 0 {
                            circleY = value
                        }
                    }
                    
                SecureField("Password", text: $password)
                    .inputStyle(icon: "lock")
                    .textContentType(.password)
                    // 绑定聚焦状态（当成为第一响应者时，`focusedField`会修改为`.password`）
                    .focused($focusedField, equals: .password)
                    .shadow(color: focusedField == .password ? .primary.opacity(0.3) : .clear, radius: 10, x: 0, y: 3)
                    // 监听当前`View`在父视图上的坐标
                    .overlay(geometry)
                    // 监听坐标的回调闭包
                    .onPreferenceChange(CirclePreferenceKey.self) { value in
                        passwordY = value
                    }
                
                Button {
                    // 直接修改聚焦状态的值，则会让绑定该值的`View`成为第一响应者
                    if email.isEmpty {
                        focusedField = .email
                    } else if password.isEmpty {
                        focusedField = .password
                    } else {
                        print("did click to create an account")
                    }
                } label: {
                    // 如果没有给文本设置颜色（foregroundColor），
                    // 当外层有【能交互的父视图】（如`NavigationLink`、`Button`等）将其包裹时，
                    // 文本会自动渲染成【淡紫色】。
                    Text("Create an account")
                        .frame(maxWidth: .infinity)
                }
                .font(.headline)
                .blendMode(.overlay)
                .buttonStyle(.angular)
                .tint(.accentColor)
                .controlSize(.large)
                // 同时使用了`.blendMode(.overlay)`和`.buttonStyle(.angular)`需要有阴影的加持下才会有效果
                .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
                
                Group {
                    // `Text`默认支持`Markdown`语法
                    Text("By clicking on ")
                    + Text("_Create an account_")
                        .foregroundColor(.primary.opacity(0.7))
                    + Text(", you agree to our **Terms of Service** and **[Privacy Policy](https://github.com/Rogue24)**")
                    
                    Divider()
                    
                    HStack {
                        Text("Already have an account?")
                        Button {
                            model.selectedModal = .signIn
                        } label: {
                            Text("**Sign in**")
                        }
                    }
                }
                .font(.footnote)
                // 如果没有给`Button`的文本设置颜色（foregroundColor），
                // 那么`Button`的文本会自动渲染成【淡紫色】。
                .foregroundColor(.secondary)
                // 设置可交互文本（上面写的跳转链接）的颜色（默认也是【淡紫色】）
                .accentColor(.pink)
            }
            // 对整个`Group`设置以下`Modifier`，能同时应用到所有的子视图（对应`Modifier`没有单独设置过的才生效）
            .opacity(appear[2] ? 1 : 0)
            .offset(y: appear[2] ? 0 : 20)
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .background(
            Circle()
                .fill(circleColor)
                .frame(width: 68, height: 68)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(y: circleY)
        )
        // 设置该视图的坐标命名空间，可以让`GeometryReader`监听【相对于】该视图上的坐标变化。
        .coordinateSpace(name: "container")
        .strokeStyle(cornerRadius: 30)
        // `onChange`用于监听某个状态值的变化，类似KVC
        .onChange(of: focusedField) { value in
            withAnimation {
                if value == .password {
                    circleY = passwordY
                    circleColor = .red
                } else {
                    circleY = emailY
                    circleColor = .blue
                }
            }
        }
        .onAppear {
            withAnimation(.spring().delay(0.1)) {
                appear[0] = true
            }
            withAnimation(.spring().delay(0.2)) {
                appear[1] = true
            }
            withAnimation(.spring().delay(0.3)) {
                appear[2] = true
            }
        }
    }
    
    var geometry: some View {
        // 在`GeometryReader`里面放入一个透明颜色用于专门监听子视图在父视图上的坐标
        GeometryReader { proxy in
            //【注意】：不可以直接在【子视图内部】刷新父视图的State属性
            // 解决方案：使用`PreferenceKey` ---【能够在视图之间传递值】
            Color.clear
                .preference(key: CirclePreferenceKey.self, // PreferenceKey类型
                            value: proxy.frame(in: .named("container")).minY) // 监听的值
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        // 使用了`@FocusState`会无法预览（`Preview`会报错）
        // 解决方案：丢进`ZStack`中
        ZStack {
            SignUpView()
        }
    }
}
