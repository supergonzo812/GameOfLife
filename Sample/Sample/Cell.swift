//
//  Cell.swift
//  Sample
//
//  Created by Chris Gonzales on 8/22/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation

struct Cell {
    
    var isAlive: Bool = false
    
    static func makeDeadCell() -> Cell {
        return Cell(isAlive: false)
    }
    
    static func makeLiveCell() -> Cell {
        return Cell(isAlive: true)
    }
}


struct GameState {
    var cells: [Cell] = []
    
    subscript(index: Int) -> Cell {
        get {
            return cells[index]
        } set {
            cells[index] = newValue
        }
    }
    
    static var acorn24by24: [Cell]{
        var acorn: [Cell] = []
        
        for _ in (0...((24 * 24) - 1)) {
            acorn.append(Cell())
        }
        acorn[(10*32) + 8].isAlive = true
        acorn[(11*32) + 10].isAlive = true
        acorn[(12*32) + 7].isAlive = true
        acorn[(12*32) + 8].isAlive = true
        acorn[(12*32) + 11].isAlive = true
        acorn[(12*32) + 12].isAlive = true
        acorn[(12*32) + 13].isAlive = true
        return acorn
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

typealias GameStateObserver = ((GameState) -> Void)?



class Game: NSObject {
    let width: Int
    let height: Int
    var currentState: GameState
    var timeInterval: Double = 0.01
    var timer: Timer?
    var isIterating: Bool = false
    
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        let cells = Array(repeating: Cell.makeDeadCell(),
                          count: width * height)
        currentState = GameState(cells: cells)
    }
    
    private func position(_ x: Int, _ y: Int) -> Int {
        return y * width + x
    }
    
    func startIteration(_ observer: GameStateObserver) {
        observer?(generateInitialState())
        self.isIterating = true
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
            observer?(self.iterate())
        }
    }
    
    func stopIteration () {
        
        guard let timer = timer else {
            print("no timer")
            return
        }
        timer.invalidate()
        self.isIterating = false
    }
    
    
    func reset() {
        self.generateInitialState()
    }
    
    func iterate() -> GameState  {
        
        var nextState = currentState
        
        for xIndex in 0...width - 1 {
            
            for yIndex in 0...height - 1 {
                
                nextState[position(xIndex, yIndex)] = Cell(isAlive: state(x: xIndex,
                                                                          y: yIndex))
            }
        }
        self.currentState = nextState
        return nextState
    }
    
    func aliveNeighbourCountAt(x: Int, y: Int) -> Int {
        
        var numberOfAliveNeighbours = 0
        
        for xIndex in x-1...x+1 {
            
            for yIndex in y-1...y+1 {
                // Check if you are the center ('current') cell, if so, do nothing
                if (xIndex == x && y == yIndex) || (xIndex >= width) || (xIndex < 0) || (yIndex < 0 ) {continue}
                
                let index = yIndex * width + xIndex
                
                guard index >= 0 && index < width * height else {continue}
                if currentState[index].isAlive {
                    numberOfAliveNeighbours += 1
                }
            }
        }
        return numberOfAliveNeighbours
    }
    
    /// This method returns a Bool based on the application of the Game of Life rules to a cell at the passed (x, y) coordinates.
    func state(x: Int, y: Int) -> Bool {
        
        // Get the number of cells
        let numberOfAliveNeighbours = aliveNeighbourCountAt(x: x,
                                                            y: y)
        // Get the state of the cell at the given location
        let wasPrevioslyAlive = currentState[position(x, y)].isAlive
        // Check if the cell was previously alive
        if wasPrevioslyAlive {
            // Return true if it has two or three alive neighbors
            return numberOfAliveNeighbours == 2 || numberOfAliveNeighbours == 3
        } else {
            // If a dead cell has three alive neighnors, return true
            return numberOfAliveNeighbours == 3
        }
    }
    
    func setInitialState(_ state: GameState) {
        currentState = state
    }
    
    /*
     We should feed the game an initial state to start with
     we can do it with random generated numbers i.e
     */
    @discardableResult
    func generateInitialState() -> GameState {
        
        //        let acorn = GameState.acorn24by24
        //        return GameState(cells: acorn)
        
        let maxItems = width*height - 1
        let initialStatePoints = self.generateRandom(between: 0...maxItems, count: maxItems/8)
        
        for point in initialStatePoints{
            currentState[point] = Cell.makeLiveCell()
        }
        return self.currentState
    }
    
    private func generateRandom(between range: ClosedRange<Int>, count: Int) -> [Int] {
        
        return [
            ((15*width) + 15),
            ((16*width) + 17),
            ((17*width) + 14),
            ((17*width) + 15),
            ((17*width) + 18),
            ((17*width) + 19),
            ((17*width) + 20)
        ]
        
//                return Array(0...count).map { _ in
//                    Int.random(in: range)
//                }
    }
}
