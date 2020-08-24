//
//  GameState.swift
//  GameOfLife
//
//  Created by Chris Gonzales on 8/21/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation

/// This struct represents a snapshot of the state of all the cells within the field
struct GameState {
    
    var cells: [CellOfLife] = []
    
    // Allows developers to subscript gameState[index] instead of gameState.cells[index}
    subscript(index: Int) -> CellOfLife {
        get{
            return cells[index]
        } set {
            cells[index] = newValue
        }
    }
}

extension GameState: Equatable {
    public static func == (lhs: GameState, rhs: GameState) -> Bool {
        for lhsCell in lhs.cells {
            for rhsCell in rhs.cells {
                
                if lhsCell.isAlive != rhsCell.isAlive {
                    return false
                }
            }
        }
        return true
    }
}
