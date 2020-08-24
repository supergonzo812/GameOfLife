//
//  GoL.swift
//  GameOfLife
//
//  Created by Chris Gonzales on 8/21/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation

typealias GameStateObserver = ((GameState) -> Void)?

class GoL {
    
    var iterations: [GameState] = []
    
    let width: Int
    let height: Int
    var currentState: GameState
    var timeInterval: Double = 0.33
    var timer: Timer?
    var isIterating: Bool = false
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        let cells = Array(repeating: CellOfLife.makeDeadCell(),
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
                
                nextState[position(xIndex, yIndex)] = CellOfLife(isAlive: state(x: xIndex,
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
    
    func state(x: Int, y: Int) -> Bool {
        
        let numberOfAliveNeighbours = aliveNeighbourCountAt(x: x,
                                                            y: y)
        let wasPrevioslyAlive = currentState[position(x, y)].isAlive
        if wasPrevioslyAlive {
            return numberOfAliveNeighbours == 2 || numberOfAliveNeighbours == 3
        } else {
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
        let maxItems = width*height - 1
        let initialStatePoints = self.generateRandom(between: 0...maxItems, count: maxItems/8)

        for point in initialStatePoints{
            currentState[point] = CellOfLife.makeLiveCell()
        }
        return self.currentState
    }
    
    private func generateRandom(between range: ClosedRange<Int>, count: Int) -> [Int] {
        return Array(0...count).map { _ in
            Int.random(in: range)
        }
    }
}


extension GoL {
    
    
    
    func backgroundIteration() {
        
        DispatchQueue.main.async {
            for _ in self.iterations {
                self.iterations.append(self.iterate())
            }
        }
    }
    
}
