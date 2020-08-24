//
//  GameViewController.swift
//  GameOfLife
//
//  Created by Chris Gonzales on 8/21/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
}

class GameViewController: UIViewController {

    // MARK: Outlets
    
     @IBOutlet weak var collectionView: UICollectionView!
        var dataSource: [CellOfLife]  = [] {
            didSet {
                self.collectionView.reloadData()
            }
        }
    
    // MARK: Actions
    
    @IBAction func resetAction(_ sender: UIButton) {
        game.reset()
    }

    // MARK: Private Properties
    
    private var gridSize: Int = 25
    private var game: GoL!
    
    private var boardWidth: Int {
        return Int(floor(collectionView.frame.size.width/CGFloat(gridSize)))
    }
    private var boardHeight: Int {
        return Int(floor(collectionView.frame.size.height/CGFloat(gridSize)))
    }
    
   // MARK: Methods
    
    func display(_ state: GameState) {
        self.dataSource = state.cells
    }

    // MARK: View Lifecycle
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        game = GoL(width: boardWidth,
                   height: boardWidth)
        
        game.addStateObserver { [weak self] state in
            self?.display(state)
        }
    }
}
        
extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoLCell",
                                                      for: indexPath) as! GoLCell
        cell.configureWithState(dataSource[indexPath.item].isAlive)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: gridSize,
                      height: gridSize)
    }
}
