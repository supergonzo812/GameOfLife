//
//  GoLCell.swift
//  GameOfLife
//
//  Created by Chris Gonzales on 8/21/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class GoLCell: UICollectionViewCell {
    
    @IBOutlet weak var squareView: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
        squareView.layer.cornerRadius = squareView.bounds.size.width/2
    }
    
    func configureWithState(_ isAlive: Bool) {
        self.squareView.backgroundColor = isAlive ?  UIColor.green : UIColor.purple
    }
}
