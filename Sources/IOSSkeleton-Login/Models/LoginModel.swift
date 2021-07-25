//
//  LoginModel.swift
//  IOSKELETON_LOGIN
//
//  Created by Rodrigo Labrador on 21/02/2021.
//

import Foundation

public struct LoginModel {
	var username = String()
	var password = String()

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
