//
//  LoginViewModel.swift
//  IOSKELETON_LOGIN
//
//  Created by Rodrigo Labrador on 21/02/2021.
//

import Foundation

public protocol LoginProtocol {
	func loginIntentResult(response: ResponseResult)
}

class LoginViewModel: ObservableObject {
	@Published var model = LoginModel()
    @Published var loading: Bool = false
    @Published var registerSucess = false
	
	var delegate: LoginProtocol?
	private var manager: LoginManager? = nil
	
	
    init(baseUrl: String, delegate: LoginProtocol?) {
		manager = EskeletonLoginManager(baseUrl: baseUrl)
        self.delegate = delegate
	}

}

extension LoginViewModel {
	// MARK: - LOGIN
	func userLoginIntent(username: String, password: String) {
		guard userDataisValid(username: username, password: password, actionType: .login) else {
            delegate?.loginIntentResult(response: .invalidUsername)
            return
        }
		
		loading = true
		manager?.userLoginIntent(LoginModel(username: username, password: password)) { (response) in
            self.loading = false
            let loginUser = UserResult(username: username, token: response.token ?? "")
            self.delegate?.loginIntentResult(response: .loginSuccess(loginUser))
		} error: { (error) in
			self.loading = false
            self.delegate?.loginIntentResult(response: .serverError(error))
		}

	}
	
	// MARK: - REGISTER
    func userRegisterIntent(username: String, password: String, repeatPassword: String) {
		guard userDataisValid(username: username, password: password, actionType: .signup),
              repeatPassword == password else {
            delegate?.loginIntentResult(response: .invalidUsername)
            return
        }
		
		loading = true
		manager?.userRegisterIntent(LoginModel(username: username, password: password)) { (response) in
			self.loading = false
			if response.code == "200" {
                self.delegate?.loginIntentResult(response: .registerSuccess)
                self.registerSucess = true
			} else {
                self.delegate?.loginIntentResult(response: .genericError)
			}
				
		} error: { (error) in
			self.loading = false
            self.delegate?.loginIntentResult(response: .serverError(error))
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
