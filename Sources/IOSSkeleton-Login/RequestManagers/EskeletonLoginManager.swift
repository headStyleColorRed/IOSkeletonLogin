//
//  LoginManager.swift
//  IOSKELETON_LOGIN
//
//  Created by Rodrigo Labrador on 21/02/2021.
//

import Foundation
import Alamofire
import ObjectMapper

protocol LoginManager {
	var baseURL: String { get set }
	func userLoginIntent(_ userLoginData: LoginModel, succes: @escaping(LoginRequestResponseDTO) -> (), error: @escaping(LoginError?) -> ())
	func userRegisterIntent(_ userLoginData: LoginModel, succes: @escaping(LoginRequestResponseDTO) -> (), error: @escaping(LoginError?) -> ())
}

class EskeletonLoginManager: LoginManager {
	var baseURL: String
	
	enum RequestURL: String {
		case login = "/login/log_user"
		case register = "/register/register_user"
	}
	
	init(baseUrl: String) {
		self.baseURL = baseUrl
	}
	
	
	// MARK: - LOGIN
	func userLoginIntent(_ userLoginData: LoginModel, succes: @escaping(LoginRequestResponseDTO) -> (), error: @escaping(LoginError?) -> ()) {
		let loginApi = baseURL + RequestURL.login.rawValue
		let headers: HTTPHeaders = ["Content-Type":"application/json"]
		let parameter = ["email": userLoginData.username, "password": userLoginData.password]
		
		AF.request(loginApi, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
			.responseJSON { (response) in
				guard let safeData = response.data,
					  let dataString = String(data: safeData, encoding: .utf8),
					  let requestResponse = LoginRequestResponseDTO(JSONString: dataString) else {
                    error(LoginError(status: "418", data: response.error?.localizedDescription))
					return
				}
				
				guard requestResponse.code == "200" else {
                    error(LoginError(status: requestResponse.code, data: requestResponse.status))
					return
				}
				succes(requestResponse)
		}
	}
	
	// MARK: - REGISTER
	func userRegisterIntent(_ userLoginData: LoginModel, succes: @escaping(LoginRequestResponseDTO) -> (), error: @escaping(LoginError?) -> ()) {
		let loginApi = baseURL + RequestURL.register.rawValue
		let headers: HTTPHeaders = ["Content-Type":"application/json"]
		let parameter = ["email": userLoginData.username,
						 "password": userLoginData.password,
						 "passwordConfirmation": userLoginData.password]
		
		AF.request(loginApi, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
			.responseJSON { (response) in
				guard let safeData = response.data,
					  let dataString = String(data: safeData, encoding: .utf8),
					  let requestResponse = LoginRequestResponseDTO(JSONString: dataString) else {
                    error(LoginError(status: "418", data: response.error?.localizedDescription))
					return
				}
				
				guard requestResponse.code == "200" else {
                    error(LoginError(status: requestResponse.code, data: requestResponse.status))
					return
				}
				succes(requestResponse)
		}
	}
}
