//
//  LoginRequestResponseDTO.swift
//  IOSKELETON_LOGIN
//
//  Created by Rodrigo Labrador on 21/02/2021.
//

import Foundation
import ObjectMapper

public class LoginRequestResponseDTO: Mappable {
	public var code: String?
	public var message: String?
	public var token: String?
	
	public required init?(map: Map) { }
	
	public func mapping(map: Map) {
		code <- map["code"]
        message <- map["status"]
        token <- map["token"]
	}
}
