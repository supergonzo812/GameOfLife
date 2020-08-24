//
//  CellofLife.swift
//  GameOfLife
//
//  Created by Chris Gonzales on 8/21/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation

struct CellOfLife {
    
    var isAlive: Bool = false
    
      static func makeDeadCell() -> CellOfLife {
        return CellOfLife(isAlive: false)
    }
    
    static func makeLiveCell() -> CellOfLife {
        return CellOfLife(isAlive: true)
    }
}
