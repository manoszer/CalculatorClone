//
//  CalculatorButton.swift
//  CurrencyCalculator
//
//  Created by Emmanouil Zervos on 24/10/2017.
//  Copyright © 2017 manos. All rights reserved.
//

import UIKit

@IBDesignable
class CalculatorButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        createButtonUI()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        createButtonUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.rounded(cornerRadius: self.frame.height / 2)
    }
    
    override func prepareForInterfaceBuilder() {
        createButtonUI()
    }
    
    func createButtonUI() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont(name: "Helvetica", size: 35)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.backgroundColor = UIColor.lightGray
    }
    
    func createButtonsAnimation() {
        self.addTarget(self, action: #selector(animateSelection) , for: .touchUpInside)
    }
    
    @objc func animateSelection() {
        let color = self.backgroundColor
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        }, completion: { (complete: Bool) in
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundColor = color
            })
        })
    }
    
    func animateOperandSelection() {
        UIView.animate(withDuration: 0.2, animations: {
            self.setTitleColor(ColorPalette.orange, for: .normal)
            self.backgroundColor = UIColor.white
        })
    }
    
    func animateOperandDeselection() {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = ColorPalette.orange
            self.setTitleColor(UIColor.white, for: .normal)
        })
    }
    
    func colorUpButton (color: UIColor) {
        self.backgroundColor = color
    }
    
    func colorUpText (color: UIColor) {
        self.setTitleColor(color, for: .normal)
    }
    
    func changeTitle (title: String) {
        self.setTitle(title, for: .normal)
    }
}
