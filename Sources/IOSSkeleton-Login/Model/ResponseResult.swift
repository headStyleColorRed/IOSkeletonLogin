//
//  ResponseResult.swift
//  
//
//  Created by Rodrigo Labrador Serrano on 19/6/21.
//

import Foundation

public enum ResponseResult {
    case registerSuccess
    case loginSuccess(UserResult)
    case invalidUsername
    case invalidPassword
    case serverError(LoginError?)
    case genericError
}
