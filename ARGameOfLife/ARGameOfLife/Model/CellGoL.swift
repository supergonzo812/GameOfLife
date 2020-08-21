//
//  CellGoL.swift
//  ARGameOfLife
//
//  Created by Chris Gonzales on 8/21/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import SceneKit

class CellGoL: SCNNode {
    
    // A default color the cell will use when alive
    //  TODO:  Randomize color, add alpha, try to ake gradients
    private let aliveColor = UIColor.blue
    // The 3-D box that represents a cell in the game of life
    private var cubeNode: SCNNode
    // A color for the box which can be set
    public var color: UIColor? {
        didSet{
            self.cubeNode.geometry?.firstMaterial?.diffuse.contents = color ?? aliveColor
        }
    }
    
    public var isAlive: Bool {
        didSet {
            cubeNode.isHidden = !isAlive
        }
    }
    
    init(isAlive: Bool,
                  nodeWidth: CGFloat,
                  nodeHeight: CGFloat) {
        //  Makes a box to apply the cubeNode to
        //  TODO: vary chamferRadius
        let box = SCNBox(width: nodeWidth,
                         height: nodeHeight,
                         length: nodeWidth,
                         chamferRadius: 0)
        //  Make sure that the initial color of the node is the alive color
        self.isAlive = true
        box.firstMaterial?.diffuse.contents = aliveColor
        cubeNode = SCNNode(geometry: box)
        super.init()
        addChildNode(cubeNode)
        cubeNode.isHidden = !isAlive
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
