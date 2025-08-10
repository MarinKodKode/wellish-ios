//
//  AuthViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/08/25.
//

import Foundation
import Combine
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import FirebaseCore
import Firebase

@MainActor
final class AuthViewModel: ObservableObject {
    
    
    
    @Published var user: User? = nil
    
    // MARK: - Form Fields
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var fullName = ""
    @Published var agreeToTerms = false

    // MARK: - UI State
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    // MARK: - Auth State
    @Published private(set) var currentUser: AuthUser?
    @Published private(set) var isAuthenticated = false
    
    private let authService: AuthenticationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(authService: AuthenticationServiceProtocol = AuthService.shared) {
        self.authService = authService
        setupBindings()
    }
    
    private func setupBindings() {
        authService.authStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
            .store(in: &cancellables)
    }

    // MARK: - Validation
    var isFormValid: Bool {
        email.isValidEmail &&
        password == confirmPassword &&
        password.isStrongPassword &&
        agreeToTerms
    }
    
    var passwordRequirements: [PasswordRequirement] {
        [
            PasswordRequirement(
                text: StringConstants.atLeastEightCharacters,
                isValid: password.count >= 8
            ),
            PasswordRequirement(
                text: StringConstants.passwordMustContainUpperAndLowerLetters,
                isValid: password
                    .rangeOfCharacter(from: .lowercaseLetters) != nil
            ),
            PasswordRequirement(
                text: StringConstants.passwordMustContainLettersAndNumbers,
                isValid: password.rangeOfCharacter(from: .decimalDigits) != nil
            )
        ]
    }

    // MARK: - Auth Methods
    func register() async {
        guard isFormValid else { return }
        
        await performAuthOperation {
            let user = UserRegistrationModel(
                fullName: self.fullName.trimmed,
                email: self.email.trimmed.lowercased(),
                password: self.password,
                provider: .email
            )
            _ = try await self.authService.createUser(with: user)
            await self.resetForm()
        }
    }

    func login() async {
        await performAuthOperation {
            _ = try await self.authService.signIn(
                email: self.email.trimmed.lowercased(),
                password: self.password
            )
        }
    }

    func signOut() {
        do {
            try authService.signOut()
            resetForm()
        } catch {
            Task { await handleError(AuthenticationError.unknownError(error.localizedDescription)) }
        }
    }

    // MARK: - Helpers
    private func performAuthOperation(_ operation: @escaping () async throws -> Void) async {
        isLoading = true
        errorMessage = nil
        showError = false

        do {
            try await operation()
        } catch let error as AuthenticationError {
            await handleError(error)
        } catch {
            await handleError(AuthenticationError.unknownError(error.localizedDescription))
        }

        isLoading = false
    }

    private func handleError(_ error: AuthenticationError) async {
        errorMessage = error.localizedDescription
        showError = true
        print("Auth Error: \(error.localizedDescription)")
    }

    private func resetForm() {
        email = ""
        password = ""
        confirmPassword = ""
        fullName = ""
        agreeToTerms = false
    }
    
    
}
