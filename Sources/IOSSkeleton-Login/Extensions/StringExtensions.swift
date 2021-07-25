//
//  StringExtensions.swift
//  
//
//  Created by Rodrigo Labrador Serrano on 25/7/21.
//

import Foundation

extension String {
    var asError: Error {
        return NSError(domain: "", code: -1,
                       userInfo: [NSLocalizedDescriptionKey: self])
    }
}
