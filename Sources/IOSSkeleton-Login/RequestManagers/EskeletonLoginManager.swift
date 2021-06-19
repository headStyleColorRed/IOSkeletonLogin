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
	func userLoginIntent(_ userLoginData: LoginModel, succes: @escaping(RequestResponseDTO) -> (), error: @escaping(String?) -> ())
	func userRegisterIntent(_ userLoginData: LoginModel, succes: @escaping(RequestResponseDTO) -> (), error: @escaping(String?) -> ())
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
	func userLoginIntent(_ userLoginData: LoginModel, succes: @escaping(RequestResponseDTO) -> (), error: @escaping(String?) -> ()) {
		let loginApi = baseURL + RequestURL.login.rawValue
		let headers: HTTPHeaders = ["Content-Type":"application/json"]
		let parameter = ["email": userLoginData.username, "password": userLoginData.password]
		
		AF.request(loginApi, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
			.responseJSON { (response) in
				guard let safeData = response.data,
					  let dataString = String(data: safeData, encoding: .utf8),
					  let requestResponse = RequestResponseDTO(JSONString: dataString) else {
					error(response.error?.localizedDescription)
					return
				}
				
				guard requestResponse.code == "200" else {
					error("Request response code is \(requestResponse.code ?? "unknown")")
					return
				}
				succes(requestResponse)
		}
	}
	
	// MARK: - REGISTER
	func userRegisterIntent(_ userLoginData: LoginModel, succes: @escaping(RequestResponseDTO) -> (), error: @escaping(String?) -> ()) {
		let loginApi = baseURL + RequestURL.register.rawValue
		let headers: HTTPHeaders = ["Content-Type":"application/json"]
		let parameter = ["email": userLoginData.username,
						 "password": userLoginData.password,
						 "passwordConfirmation": userLoginData.password]
		
		AF.request(loginApi, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
			.responseJSON { (response) in
				guard let safeData = response.data,
					  let dataString = String(data: safeData, encoding: .utf8),
					  let requestResponse = RequestResponseDTO(JSONString: dataString) else {
					error(response.error?.localizedDescription)
					return
				}
				
				guard requestResponse.code == "200" else {
					error("Request response code is \(requestResponse.code ?? "unknown")")
					return
				}
				succes(requestResponse)
		}
	}
}
