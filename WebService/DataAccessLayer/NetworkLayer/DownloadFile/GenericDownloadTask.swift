//
//  GenericDownloadTask.swift
//  ConnectSocial
//
//  Created by Yogesh Padekar on 3/7/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import Foundation

class GenericDownloadTask {
    
    var completionHandler: ResultType<Data>.Completion?
    var progressHandler: ((Double) -> Void)?
    
    private(set) var task: URLSessionDataTask
    var expectedContentLength: Int64 = 0
    var buffer = Data()
    
    init(task: URLSessionDataTask) {
        self.task = task
    }
    
    deinit {
        print("Deinit: \(task.originalRequest?.url?.absoluteString ?? "")")
    }
    
}

extension GenericDownloadTask: DownloadTask {
    
    func resume() {
        task.resume()
    }
    
    func suspend() {
        task.suspend()
    }
    
    func cancel() {
        task.cancel()
    }
}
