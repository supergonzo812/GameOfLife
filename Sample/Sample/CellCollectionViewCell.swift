//
//  CellCollectionViewCell.swift
//  Sample
//
//  Created by Chris Gonzales on 8/22/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class CellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var squareView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configureWithState(_ isAlive: Bool) {
        self.squareView.backgroundColor = isAlive ?  UIColor.green : UIColor.red
    }
    
}
