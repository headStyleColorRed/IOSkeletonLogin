//
//  RequestDTO.swift
//  IOSKELETON_LOGIN
//
//  Created by Rodrigo Labrador on 21/02/2021.
//

import Foundation
import ObjectMapper

class RequestResponseDTO: Mappable {
	var code: String?
	var status: String?
	var data: String?
	
	public required init?(map: Map) { }
	
	public func mapping(map: Map) {
		code <- map["code"]
		status <- map["status"]
		data <- map["data"]
	}
}
