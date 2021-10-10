//
//  LogHelper.swift
//  News
//
//  Created by Saffi on 2021/10/10.
//

import Foundation

class LogHelper: NSObject {
    
    enum Category: String {
        case debug
        case api
        case database
        case `deinit`
        case download
        case thread

        var prefix: String {
            return String(format: "[Log-%@]", self.rawValue)
        }
    }
    
    class func print(_ category: Category, item: Any...) {
        if category == .thread {
            Thread.printCurrent()
            return
        }
        Swift.print(category.prefix, item)
    }
}

extension Thread {
    class func printCurrent() {
        print("⚡️: \(Thread.current)\n" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")")
    }
}
