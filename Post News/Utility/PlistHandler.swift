//
//  PlistHandler.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import Foundation

enum PlistKey: String {
    case WebURL
}

struct PlistHandler {
    fileprivate static var infoDict: [String: Any] {
        guard let dictionary = Bundle.main.infoDictionary else { fatalError("Plist file not found") }
        return dictionary
    }
    
    static func configuration(_ key: PlistKey) -> String {
        return PlistHandler.infoDict[key.rawValue] as! String
    }
}
