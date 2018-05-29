//
//  Enums.swift
//  ConnectSocial
//
//  Created by Yogesh Padekar on 9/7/17.
//  Copyright © 2017 Gaurang Lathiya. All rights reserved.
//

import Foundation

public enum CommentPrivacyType: Int {
    case AllowComments
    case DisableComments
    
    // MARK:  Helper methods
    static let count: Int = {
        var max: Int = 0
        while let _ = CommentPrivacyType(rawValue: max) { max += 1 }
        return max
    }()
    
    var string: String {
        return String(describing: self)
    }
}

// User Gender
public enum Gender: Int
{
    case Male = 1
    case Female = 2
    case Other = 3
    
    // MARK:  Helper methods
    static let count: Int = {
        var max: Int = 0
        while let _ = Gender(rawValue: max) { max += 1 }
        return max
    }()
    
    var string: String {
        return String(describing: self)
    }
}
