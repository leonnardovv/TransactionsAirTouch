//
//  Stack.swift
//  AirTouch Exercise
//
//  Created by Leonard on 2/23/20.
//  Copyright © 2020 Leonard. All rights reserved.
//

import Foundation

public struct Stack<T> {
    
    fileprivate var array: [T] = []
  
    public init() {}
  
    public mutating func push(_ element: T) {
        array.append(element)
    }
  
    public mutating func pop() -> T? {
        return array.popLast()
    }
  
    public func peek() -> T? {
        return array.last
        }
    }

extension Stack: CustomStringConvertible {
    public var description: String {
        let topDivider = "---Stack---\n"
        let bottomDivider = "\n-----------\n"
        
        let stackElements = array.map { "\($0)" }.reversed().joined(separator: "\n")
        return topDivider + stackElements + bottomDivider
    }
}
