//
//  Vertex.swift
//  AirTouch Exercise
//
//  Created by Leonard on 2/23/20.
//  Copyright © 2020 Leonard. All rights reserved.
//

import Foundation

public struct Vertex<T: Hashable> {
    var data: T
    
    init(data: T){
        self.data = data
    }
}

extension Vertex: Hashable {
    
    public func hash(into hasher: inout Hasher){
        
        return hasher.combine(data)
    }
  
    static public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.data == rhs.data
    }
}

extension Vertex: CustomStringConvertible {
    
    public var description: String {
        return "\(data)"
    }
    
}
