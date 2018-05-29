//
//  DownloadTask.swift
//  WebService
//
//  Created by Gaurang Lathiya on 3/7/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import Foundation

protocol DownloadTask {
    
    var completionHandler: ResultType<Data>.Completion? { get set }
    var progressHandler: ((Double) -> Void)? { get set }
    
    func resume()
    func suspend()
    func cancel()
}
