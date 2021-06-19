//
//  LoginViewModel.swift
//  IOSKELETON_LOGIN
//
//  Created by Rodrigo Labrador on 21/02/2021.
//

import Foundation

protocol LoginViewModelProtocol {
	func loginIntentResult(response: RequestResponse)
}

class LoginViewModel: ObservableObject {
	@Published var model = LoginModel()
	@Published var error: RequestResponse?
	@Published var loading = Bool()
	
	var delegate: LoginViewModelProtocol?
	private var manager: LoginManager? = nil
	
	
	init(baseUrl: String) {
		manager = EskeletonLoginManager(baseUrl: baseUrl)
	}

}

extension LoginViewModel {
	// MARK: - LOGIN
	func userLoginIntent(username: String, password: String) {
		guard userDataisValid(username: username, password: password, actionType: .login) else { return }
		
		loading = true
		manager?.userLoginIntent(LoginModel(username: username, password: password)) { (response) in
			self.loading = false
			print("Success!!!!")
		} error: { (error) in
			self.loading = false
			self.error = RequestResponse(status: error)
			print(error ?? "")
		}

	}
	
	// MARK: - REGISTER
	func userRegisterIntent(username: String, password: String) {
		guard userDataisValid(username: username, password: password, actionType: .signup) else { return }
		
		loading = true
		manager?.userRegisterIntent(LoginModel(username: username, password: password)) { (response) in
			self.loading = false
			if response.code == "200" {
				print("Success!!!!")
			} else {
				self.error = RequestResponse(response: response)
			}
				
		} error: { (error) in
			self.loading = false
			self.error = RequestResponse(status: error)
			print(error ?? "")
		}

	}
	
	private func userDataisValid(username: String, password: String, repeatPassword: String = "", actionType: NavigationFlow) -> Bool {
		if !isValidEmail(username) || !isValidPassword(password) {
			return false
		}
		return true
	}
	
	private func isValidEmail(_ email: String) -> Bool {
	  let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
	  let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
	  return emailPred.evaluate(with: email)
	}
	
	private func isValidPassword(_ password: String) -> Bool {
	  let minPasswordLength = 6
	  return password.count >= minPasswordLength
	}
}
