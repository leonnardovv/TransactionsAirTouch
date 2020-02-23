//
//  Graph.swift
//  AirTouch Exercise
//
//  Created by Leonard on 2/23/20.
//  Copyright © 2020 Leonard. All rights reserved.
//

import Foundation

public protocol Graphable{
    
    associatedtype Element: Hashable
    var description: CustomStringConvertible { get }
  
    func createVertex(data: Element) -> Vertex<Element>
    
    func add(_ type: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Float?)
    
    func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Float?
    
    func edges(from source: Vertex<Element>) -> [Edge<Element>]?
    
}

