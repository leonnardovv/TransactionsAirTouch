//
//  Edge.swift
//  AirTouch Exercise
//
//  Created by Leonard on 2/23/20.
//  Copyright © 2020 Leonard. All rights reserved.
//

import Foundation

public enum EdgeType {
    
    case directed, undirected
    
}

public struct Edge<T: Hashable> {
    
    public var source: Vertex<T>
    public var destination: Vertex<T>
    public let weight: Float?
}

extension Edge: Hashable {
  

    public func hash(into hasher: inout Hasher){
        hasher.combine("\(source)\(destination)\(weight)")
    }
    
    static public func == (lhs: Edge<T>, rhs: Edge<T>) -> Bool {
        return lhs.source == rhs.source &&
            lhs.destination == rhs.destination &&
            lhs.weight == rhs.weight
    }
}

