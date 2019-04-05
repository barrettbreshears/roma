//
//  RegexParser.swift
//  ActiveLabel
//
//  Created by Pol Quintana on 06/01/16.
//  Copyright © 2016 Optonaut. All rights reserved.
//

import Foundation

struct RegexParser {

//    static let hashtagPattern = "(?:^|\\s|$)#[\\p{L}0-9_]*"
    static let hashtagPattern = "\\B#\\w\\w+"
//    static let mentionPattern = "(?:^|\\s|$|[.])@[\\p{L}0-9_]*"
    static let mentionPattern = "(?:^|\\s|$|[.])@[\\p{L}0-9_@.]*"
    //static let urlPattern = "(^|[\\s.:;?\\-\\]<\\(])" + "((https?://|www\\.|pic\\.)[-\\w;/?:@&=+$\\|\\_.!~*\\|'()\\[\\]%#,☺]+[\\w/#](\\(\\))?)" + "(?=$|[\\s',\\|\\(\\).:;?\\-\\[\\]>\\)])"
    
//    static let urlPattern = "(https?:\\/\\/(?:www\\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\\.[^\\s]{2,}|www\\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\\.[^\\s]{2,}|https?:\\/\\/(?:www\\.|(?!www))[a-zA-Z0-9]\\.[^\\s]{2,}|www\\.[a-zA-Z0-9]\\.[^\\s]{2,})"
    static let urlPattern = "(https?:\\/\\/)(www\\.)?(?<domain>[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6})(?<path>\\/[-a-zA-Z0-9@:%_\\/+.~#?&=]*)?"

    private static var cachedRegularExpressions: [String : NSRegularExpression] = [:]

    static func getElements(from text: String, with pattern: String, range: NSRange) -> [NSTextCheckingResult]{
        guard let elementRegex = regularExpression(for: pattern) else { return [] }
        return elementRegex.matches(in: text, options: [], range: range)
    }

    private static func regularExpression(for pattern: String) -> NSRegularExpression? {
        if let regex = cachedRegularExpressions[pattern] {
            return regex
        } else if let createdRegex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
            cachedRegularExpressions[pattern] = createdRegex
            return createdRegex
        } else {
            return nil
        }
    }
}
