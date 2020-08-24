//
//  GameViewController.swift
//  Sample
//
//  Created by Chris Gonzales on 8/22/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var game: Game!
    // 24 is the max... the collection view formats strangely after that
    var dimension: Int = 32
    
    @IBOutlet weak var gameCollectionView: UICollectionView!
    
    @IBAction func Play(_ sender: UIButton) {
        if game.isIterating {
            game.stopIteration()
        }
        if !game.isIterating {
            game.startIteration { [weak self] state in
                self?.dataSource = state.cells
            }
        }
    }
    
    var dataSource: [Cell] = [] {
        didSet {
            self.gameCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameCollectionView.isScrollEnabled = false
        let margin: CGFloat = 0
        
        guard let flowLayout = gameCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        game = Game(width: dimension,
                    height: dimension)
        self.dataSource = game.currentState.cells
    }
}

extension GameViewController: UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        //        return dimension * dimension
        return dataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCollectionViewCell",
                                                            for: indexPath) as? CellCollectionViewCell
            else { return UICollectionViewCell() }
        cell.configureWithState(dataSource[indexPath.item].isAlive)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemPerRow = sqrt(Double(dataSource.count))
//        let size = 28
        let size = (gameCollectionView.bounds.width) / CGFloat(itemPerRow)
        print(size)
        
        
        return CGSize(width: size,
                      height: size)
    }
}
