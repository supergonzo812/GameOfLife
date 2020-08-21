//
//  CubeGoL.swift
//  ARGameOfLife
//
//  Created by Chris Gonzales on 8/21/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import SceneKit

import SceneKit

class CubeOfLife: SCNNode {
    
    var matrixOfLife: [[[Bool]]] = []
    var cells: [[[CellGoL]]] = []
    var size: Int
    var width: CGFloat
    var height: CGFloat
    var depth: Int
    var isBuilt = false
    
    init(n: Int, withAliveCells cells: [SIMD3<Float>]? = nil) {
        self.size = n
        self.depth = n
        self.width = CGFloat(n)
        self.height = CGFloat(n)
        super.init()
        setupLife(withAliveCells: cells)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLife(withAliveCells cellLocations: [SIMD3<Float>]? = nil) {
        // Loops through the x plane nodes from 0 to (size - 1)
        for x in (0 ..< size) {
            var plane: [[Bool]] = []
            // Loops through the y plane nodes from 0 to (size - 1)
            for y in (0 ..< size) {
                var row: [Bool] = []
                // Loops through the z plane nodes from 0 to (size - 1)
                for z in (0 ..< size) {
                    if let cells = cellLocations {
                        
                        // Center the Location
                        let count = cells.filter {
                            Int($0.x) + Int(size / 2) == x &&
                                Int($0.y) + Int(size / 2) == y &&
                                Int($0.z + 1) == z
                        }
                        
                        row.append(!count.isEmpty)
                        
                    } else {
                        // Random!
                        row.append(Bool.random())
                    }
                }
                plane.append(row)
            }
            matrixOfLife.append(plane)
        }
    }
    
    // Verifies that there is a value at certain coordinate set (so you don't get an index out of rang)
    private func get(_ x: Int, _ y: Int, _ z: Int) -> Bool? {
        if x > 0, y > 0, z > 0,
            x < size, y < size, z < size {
            let value = matrixOfLife[x][y][z]
            
            return value
        }
        return nil
        
    }
    
    // Verifies that there is a value at certain coordinates set withi a given GoL matrix (so you don't get an index out of rang)
    private func get(_ x: Int, _ y: Int, _ z: Int, from matrix: [[[Bool]]]) -> Bool? {
        
        if x > 0,
            y > 0,
            z > 0,
            x < matrix.count,
            y < matrix.count,
            z < matrix.count {
            let value = matrix[x][y][z]
            
            return value
        }
        return nil
    }
}

