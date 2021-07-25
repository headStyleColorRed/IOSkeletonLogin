//
//  EskeletonLoginManagerProtocol.swift.swift
//  
//
//  Created by Rodrigo Labrador Serrano on 25/7/21.
//

import Foundation

public protocol EskeletonLoginManagerProtocol {
    typealias LoginIntentHandler = (Result<LoginRequestResponseDTO, Error>) -> Void

    var baseURL: String { get set }

    func userLoginIntent(_ userLoginData: LoginModel, completion: @escaping LoginIntentHandler)
    func userRegisterIntent(_ userLoginData: LoginModel, completion: @escaping LoginIntentHandler)
}
