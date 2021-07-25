//
//  LoginManager.swift
//  IOSKELETON_LOGIN
//
//  Created by Rodrigo Labrador on 21/02/2021.
//

import Foundation
import Alamofire
import ObjectMapper

public class EskeletonLoginManager: EskeletonLoginManagerProtocol {
    public var baseURL: String
	
	enum RequestURL: String {
		case login = "/login/log_user"
		case register = "/register/register_user"
	}
	
    public init(baseUrl: String) {
		self.baseURL = baseUrl
	}
	
	
	// MARK: - LOGIN
    public func userLoginIntent(_ userLoginData: LoginModel, completion: @escaping LoginIntentHandler) {
		let loginApi = baseURL + RequestURL.login.rawValue
		let headers: HTTPHeaders = ["Content-Type":"application/json"]
		let parameter = ["email": userLoginData.username, "password": userLoginData.password]
		
		AF.request(loginApi, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
			.responseJSON { (response) in
				guard let safeData = response.data,
					  let dataString = String(data: safeData, encoding: .utf8),
					  let requestResponse = LoginRequestResponseDTO(JSONString: dataString) else {
                    let error = response.error?.localizedDescription ?? "Unknown Error"
                    completion(.failure(error.asError))
					return
				}
				
				guard requestResponse.code == "200" else {
                    let error = requestResponse.message ?? "Unknown Error"
                    completion(.failure(error.asError))
					return
				}
                completion(.success(requestResponse))
		}
	}

	// MARK: - REGISTER
    public func userRegisterIntent(_ userLoginData: LoginModel, completion: @escaping LoginIntentHandler) {
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
                    let error = response.error?.localizedDescription ?? "Unknown Error"
                    completion(.failure(error.asError))
					return
				}
				
				guard requestResponse.code == "200" else {
                    let error = requestResponse.message ?? "Unknown Error"
                    completion(.failure(error.asError))
					return
				}
                completion(.success(requestResponse))
		}
	}
}
