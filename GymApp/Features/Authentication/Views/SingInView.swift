//
//  SingInView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 28/07/25.
//

import SwiftUI


struct SignInView: View {
    
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isLoading: Bool = false
    @State private var savePassword: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background_4")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 0.999,
                        alignment: .top
                    )
                    .overlay(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.3),
                                Color.black.opacity(0.1),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                VStack(spacing: 0) {
                    VStack {
                        HStack {
                            CustomBackButton(action: {
                                navigationRouter.goBack()
                            })
                            
                            Spacer()
                            
                        }
                        .padding(.horizontal, 20)
                        
                    }
                    .frame(height: geometry.size.height * 0.25)
                    
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text(StringConstants.welcome)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.top, 16)
                            
                            Text(StringConstants.enterYourCredentials)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 32)
                        
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "envelope")
                                        .foregroundColor(.secondary)
                                        .frame(width: 20)
                                    
                                    TextField("Email Address", text: $email)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.1))
                                )
                            }
                            
                            // Password field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "lock")
                                        .foregroundColor(.secondary)
                                        .frame(width: 20)
                                    
                                    if isPasswordVisible {
                                        TextField("Password", text: $password)
                                            .textFieldStyle(PlainTextFieldStyle())
                                    } else {
                                        SecureField("Password", text: $password)
                                            .textFieldStyle(PlainTextFieldStyle())
                                    }
                                    
                                    Button(action: {
                                        isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.1))
                                )
                            }
                            
                        }
                        
                        HStack(alignment: .top, spacing: 12) {
                            Button(action: {
                                savePassword.toggle()
                            }) {
                                Image(systemName: savePassword ? "checkmark.square.fill" : "square")
                                    .foregroundColor(savePassword ? .blue : .secondary)
                                    .font(.title3)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(StringConstants.rememberPassword)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.primary)
                                
                                Text(StringConstants.rememberPasswordDetails)
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        
                        
                        // Sign in button
                        Button(action: {
                            signIn()
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Sign In")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                LinearGradient(
                                    colors: [Color.indigo, Color.blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                        }
                        .disabled(isLoading || email.isEmpty || password.isEmpty)
                        .opacity((email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                        
                        // Forgot password
                        Button(action: {
                            // Handle forgot password
                        }) {
                            Text("Forgot your password?")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                            
                            Text("Or sign in with")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                signInWithGoogle()
                            }) {
                                HStack(spacing: 8) {
                                    Image("google_ic")
                                        .resizable()
                                        .frame(width: 30.0, height: 30.0)
                                        .foregroundColor(.primary)
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                
                            }
                            
                            Button(action: {
                                signInWithApple()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "apple.logo")
                                        .resizable()
                                        .foregroundColor(.primary)
                                        .frame(width: 30.0, height: 30.0)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(.systemBackground))
                            .ignoresSafeArea(.all, edges: .bottom)
                    )
                    .frame(maxHeight: .infinity)
                }
            }
        }
        .ignoresSafeArea()
        .hideKeyboardOnTap()
        .enableNativeSwipeBack()
        .navigationBarBackButtonHidden(true)
        
    }
    
    // MARK: - Methods
    private func signIn() {
        isLoading = true
        // Implement your sign in logic here
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
    
    private func signInWithGoogle() {
        // Implement Google Sign In
        print("Sign in with Google")
    }
    
    private func signInWithFacebook() {
        // Implement Facebook Sign In
        print("Sign in with Facebook")
    }
    
    private func signInWithApple() {
        // Implement Apple Sign In
        print("Sign in with Apple")
    }
}

// MARK: - BlurView
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// MARK: - Preview
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
