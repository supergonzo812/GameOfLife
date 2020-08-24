//
//  ViewController.swift
//  ARGameOfLife
//
//  Created by Chris Gonzales on 8/21/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    private var isSpawned = false
    private var cube: CubeOfLife?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let boxAnchor = try! Experience.loadBox()

               // Add the box anchor to the scene
               arView.scene.anchors.append(boxAnchor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
//        
//        sceneView.session.run(configuration)
    }
}

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    private var isSpawned = false
    private var cube: CubeOfLife?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set the scene to the view
        sceneView.scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
// ...
}
