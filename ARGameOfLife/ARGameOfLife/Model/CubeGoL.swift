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
        setupCubeOfLife(withAliveCells: cells)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCubeOfLife(withAliveCells cellLocations: [SIMD3<Float>]? = nil) {
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
                                Int($0.z) + Int(size / 2) == z
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
    
    func build() {
        
        for x in (0 ..< size) {
            var plane: [[CellGoL]] = []
            
            for y in (0 ..< size) {
                var row: [CellGoL] = []
                
                for z in (0 ..< size) {
                    // Get if the cell is alive
                    let isAlive = matrixOfLife[x][y][z]
                    // Get the width and height
                    let nodeWidth = width / CGFloat(size)
                    let nodeHeight = height / CGFloat(size)
                    // Create the basic cell
                    let cell = CellGoL(isAlive: isAlive,
                                       nodeWidth: nodeWidth,
                                       nodeHeight: nodeHeight)
                    // Set the postion for the cell
                    cell.position =  SCNVector3((CGFloat(x) * nodeWidth) - width / 2,
                                                (CGFloat(y) * nodeHeight) - width / 2,
                                                CGFloat(z) * nodeWidth)
                    // Calculate the distance from the center
                    let node1Pos = SCNVector3ToGLKVector3(cell.position)
                    let node2Pos = SCNVector3ToGLKVector3(SCNVector3(CGFloat(position.x) + nodeWidth / 2,
                                                                     CGFloat(position.y) + nodeHeight / 2,
                                                                     CGFloat(position.z) + nodeWidth / 2))
                    let distance = GLKVector3Distance(node1Pos,
                                                      node2Pos)
                    // Set the color of the box
                    let color = UIColor(red: CGFloat(255 - (x * 10)) / 255.0,
                                        green: CGFloat(255 - (y * 10)) / 255.0,
                                        blue: CGFloat(255 - (z * 10)) / 255.0,
                                        alpha: CGFloat(1 - distance))
                    cell.color = color
                    // Add the cell to the cube of life
                    addChildNode(cell)
                    row.append(cell)
                }
                
                plane.append(row)
            }
            cells.append(plane)
        }
        // The cube has been built
        isBuilt = true
        // Start the timer
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    func update() {
        for x in (0 ..< size) {
            for y in (0 ..< size) {
                for z in (0 ..< size) {
                    let cell = cells[x][y][z]
                    let isAlive = matrixOfLife[x][y][z]
                    cell.isAlive = isAlive
                }
            }
        }
    }
    
    @objc
    func tick() {
        
        var newGen: [[[Bool]]] = []
        
        for x in (0 ..< size) {
            var plane: [[Bool]] = []
            
            for y in (0 ..< size) {
                var row: [Bool] = []
                
                for z in (0 ..< size) {
                    let neighbors: [Bool?] = [
                        // Bottom
                        get(x, y, z-1),
                        get(x, y+1, z-1),
                        get(x, y-1, z-1),
                        get(x+1, y, z-1),
                        get(x+1, y+1, z-1),
                        get(x+1, y-1, z-1),
                        get(x-1, y, z-1),
                        get(x-1, y+1, z-1),
                        get(x-1, y-1, z-1),
                        // Sides (you do not check (x, y, z) this is self
                        get(x, y-1, z),
                        get(x, y+1, z),
                        get(x+1, y, z),
                        get(x+1, y+1, z),
                        get(x+1, y-1, z),
                        get(x-1, y, z),
                        get(x-1, y+1, z),
                        get(x-1, y-1, z),
                        // Top
                        get(x, y, z+1),
                        get(x, y-1, z+1),
                        get(x, y+1, z+1),
                        get(x+1, y, z+1),
                        get(x+1, y+1, z+1),
                        get(x+1, y-1, z+1),
                        get(x-1, y, z+1),
                        get(x-1, y+1, z+1),
                        get(x-1, y-1, z+1),
                        ]
                    
                    let neighborsSum = neighbors.compactMap { $0 }.map{ $0 ? 1 : 0 }.reduce(0,+)
                    
                    switch neighborsSum {
                    case 0 ... 3:
                        row.append(false)
                        
                    case 4 ... 6:
                        
                        if let isAlive = get(x, y, z) {
                            
                            if isAlive {
                                row.append(true)
                                
                            } else {
                                row.append(neighborsSum == 4)
                            }
                            
                        } else {
                            row.append(false)
                        }
                        
                    default:
                        row.append(false)
                    }
                }
                plane.append(row)
            }
            newGen.append(plane)
        }
        matrixOfLife = newGen
        update()
    }
}

