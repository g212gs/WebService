//
//  ResultType.swift
//  WebService
//
//  Created by Gaurang Lathiya on 3/7/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import Foundation
public enum ResultType<T> {
    
    public typealias Completion = (ResultType<T>) -> Void
    
    case success(T)
    case failure(Swift.Error)
    
}
