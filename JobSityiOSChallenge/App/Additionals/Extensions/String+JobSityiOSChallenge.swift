//
//  String+JobSityiOSChallenge.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 18/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import Foundation

extension String {
    
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension Array where Element == String {
    var joinedWithCommas: String {
        return joined(separator: ", ")
    }
}
