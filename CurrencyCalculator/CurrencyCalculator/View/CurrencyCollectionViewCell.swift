//
//  CurrencyCollectionViewCell.swift
//  CurrencyCalculator
//
//  Created by Emmanouil Zervos on 24/10/2017.
//  Copyright © 2017 manos. All rights reserved.
//

import UIKit

class CurrencyCollectionViewCell: UICollectionViewCell {
    @IBOutlet var backroundView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        backroundView.bordered(color: UIColor.white, borderWidth: 1)
        backroundView.rounded(cornerRadius: self.frame.height/2)
    }
}
