//
//  CalculatorViewController.swift
//  CurrencyCalculator
//
//  Created by Emmanouil Zervos on 24/10/2017.
//  Copyright © 2017 manos. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var numberButtonsOutletCollection: [CalculatorButton]!
    @IBOutlet var operandsButtonsOutletCollection: [CalculatorButton]!
    @IBOutlet var instantOperandsOutletCollection: [CalculatorButton]!
    @IBOutlet var equalButton: CalculatorButton!
    // Source Amount outlets
    @IBOutlet var sourceCurrencyButton: UIButton!
    @IBOutlet var sourceCollectionView: UICollectionView!
    @IBOutlet var sourceCurrencyCollectionViewWidthConstraint: NSLayoutConstraint!
    // Exchanged amount outlets
    @IBOutlet var exchangeView: UIView!
    @IBOutlet var exchangeLabel: UILabel!
    @IBOutlet var exchangeButton: UIButton!
    @IBOutlet var exchangeCollectionView: UICollectionView!
    @IBOutlet var exchangeCollectionViewWidthConstraint: NSLayoutConstraint!
    
    let currencyModel = CurrencyModel()
    var result: Double = 0
    var selectedAction: String?
    var justPressedOperand: Bool = false
    var displayValue: Double? {
        didSet {
            valueLabel.text = (displayValue ?? 0).formattedWithCommas
            updateExchangeLabel()
        }
    }
    var sourceCurrency = "EUR"
    var exchangeCurrency: String? {
        didSet {
            DispatchQueue.main.async {
                self.exchangeCurrency == nil ? (self.exchangeView.isHidden = true) : (self.exchangeView.isHidden = false)
            }
        }
    }
    var rates: Dictionary<String, Double>? {
        // rates updates when service is called so we have to update the converted amount too
        didSet {
            if let rates = rates {
                if rates.count > 0 {
                    DispatchQueue.main.async {
                        self.exchangeCollectionView.reloadData()
                        self.sourceCollectionView.reloadData()
                        self.exchangeView.isHidden = false
                        self.updateExchangeLabel()
                    }
                } else {
                    self.exchangeView.isHidden = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonsUI()
        setupCollectionViews(collectionView: sourceCollectionView)
        setupCollectionViews(collectionView: exchangeCollectionView)
        makeCurrencyCall(forCurrency: sourceCurrency)
    }
    
    // MARK: - Service methods
    func makeCurrencyCall(forCurrency: String) {
        exchangeButton.isEnabled = false
        currencyModel.getCurrencyRates(base: forCurrency, completion: { isSuccesfull in
            if isSuccesfull {
                DispatchQueue.main.async {
                    self.exchangeButton.isEnabled = true
                }
                self.rates = self.currencyModel.rates?.rates ?? [:]
            } else {
                self.exchangeCurrency = nil
                let alert = UIAlertController(title: "Error", message: "Could not fetch the \(String(describing: forCurrency)) rates", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler:{(action:UIAlertAction!) in
                    self.makeCurrencyCall(forCurrency: forCurrency)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    // Updates the exchange label based on the display value
    func updateExchangeLabel() {
        if let rates = rates {
            if rates.count > 0 {
                if let currencyLabel = self.exchangeButton.title(for: .normal) {
                    let convertedAmount = (self.displayValue ?? 0) * (rates[currencyLabel] ?? 1)
                    self.exchangeLabel.text = "equals to \(String(describing: convertedAmount.formattedWithCommas!))"
                }
            }
        }
    }
    
    // MARK: - Setup UI
    func setupButtonsUI() {
        for button in numberButtonsOutletCollection {
            button.colorUpButton(color: ColorPalette.darkGray)
            button.createButtonsAnimation()
        }
        for button in operandsButtonsOutletCollection {
            button.colorUpButton(color: ColorPalette.orange)
        }
        for button in instantOperandsOutletCollection {
            button.colorUpButton(color: ColorPalette.lightGray)
            button.colorUpText(color: UIColor.black)
            button.createButtonsAnimation()
        }
        equalButton.colorUpButton(color: ColorPalette.orange)
        equalButton.createButtonsAnimation()
        sourceCurrencyButton.bordered(color: UIColor.white, borderWidth: 1)
        sourceCurrencyButton.rounded(cornerRadius: sourceCurrencyButton.frame.height/2)
        exchangeButton.bordered(color: UIColor.white, borderWidth: 1)
        exchangeButton.rounded(cornerRadius: exchangeButton.frame.height/2)
    }
    
    func setupCollectionViews(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CurrencyCollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: "CurrencyCollectionViewCellIdentifier")
        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            if #available(iOS 10.0, *) {
                flowlayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
            } else {
                flowlayout.estimatedItemSize = CGSize(width: 80, height: 30)
            }
        }
    }
    // collection view animation methods
    func animateCollectionView(shouldExpand: Bool, collectionView: UICollectionView, withWidthConstraint:NSLayoutConstraint) {
        UIView.animate(withDuration: 0.3, animations: {
            withWidthConstraint.constant = shouldExpand == true ? (self.view.bounds.width - 70) : 0
            self.view.layoutIfNeeded()
        })
    }

    // Checks if any of the operand buttons is already selected and deselects it if needed
    func deselectPreviousButtonIfNeeded() {
        for button in operandsButtonsOutletCollection {
            if button.titleLabel?.text == selectedAction {
                button.animateOperandDeselection()
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func numberButtonTapped(_ sender: CalculatorButton) {
        //deselect operand button if there is any selected
        deselectPreviousButtonIfNeeded()
        //check the var justpressedoperand in order to find out if a new number should be written
        if justPressedOperand {
            self.displayValue = Double((sender.titleLabel!.text)!)
            justPressedOperand = false
            return
        }
        //append the new character on the end of valuelabel
        if let previousValue = valueLabel.text?.replacingOccurrences(of: ",", with: "") {
            let newNumber = previousValue + (sender.titleLabel!.text)!
            self.displayValue = Double(newNumber)
        }
    }
    @IBAction func decimalButtonTapped(_ sender: CalculatorButton) {
        if valueLabel.text!.contains(".") {
            return
        }
        valueLabel.text! = valueLabel.text! + "."
    }
    
    @IBAction func operandButtonTapped(_ sender: CalculatorButton) {
        // check to deselect previous operand selection
        deselectPreviousButtonIfNeeded()
        
        // make calculation with previous operand if exists
        if let operand = selectedAction {
            // check if just changed operand in order just to update the selected action and not make the calculation
            if justPressedOperand {
                selectedAction = sender.titleLabel?.text
                sender.animateOperandSelection()
                return
            }
            result = makeCalculation(operand: operand, firstValue: result, secondValue: displayValue!)
            displayValue = result
        } else {
            result = displayValue ?? 0
        }
        
        selectedAction = sender.titleLabel?.text
        sender.animateOperandSelection()
        justPressedOperand = true
    }
    
    @IBAction func instantOperationButtonTapped(_ sender: CalculatorButton) {
        // if = is tapped we make the calculation between the result and the display value with the selectedoperand
        if sender.titleLabel?.text == "=" {
            if let operand = selectedAction {
                result = makeCalculation(operand: operand, firstValue: result, secondValue: displayValue!)
                displayValue = result
                deselectPreviousButtonIfNeeded()
                selectedAction = nil
                self.justPressedOperand = true
                return
            }
            return
        }
        // if "AC" is tapped we clear everything
        if sender.titleLabel?.text == "AC" {
            deselectPreviousButtonIfNeeded()
            selectedAction = nil
            result = 0
        }
        
        if let firstValue = displayValue {
            displayValue = makeCalculation(operand: (sender.titleLabel?.text)!, firstValue: firstValue, secondValue: 0)
        }
    }
    
    @IBAction func sourceCurrencyButtonTapped(_ sender: UIButton) {
        let senderIsSource: Bool = (sender == sourceCurrencyButton)
        let senderConstraint: NSLayoutConstraint = senderIsSource == true ? sourceCurrencyCollectionViewWidthConstraint : exchangeCollectionViewWidthConstraint
        let opositeConstraint: NSLayoutConstraint = senderIsSource == true ? exchangeCollectionViewWidthConstraint : sourceCurrencyCollectionViewWidthConstraint
        let senderCollectionView: UICollectionView = senderIsSource == true ? sourceCollectionView : sourceCollectionView
        let opositeCollectionView: UICollectionView = senderIsSource == true ? exchangeCollectionView : sourceCollectionView
        let opositeButton: UIButton = senderIsSource == true ? exchangeButton : sourceCurrencyButton
        let currency: String = senderIsSource == true ? sourceCurrency : (exchangeCurrency ?? "USD")
        let opositeCurrency: String = senderIsSource == true ? (exchangeCurrency ?? "USD") : sourceCurrency

        if senderConstraint.constant == 0 {
            if opositeConstraint.constant != 0 {
                animateCollectionView(shouldExpand: false, collectionView: opositeCollectionView, withWidthConstraint: opositeConstraint)
                opositeButton.setTitle(opositeCurrency, for: .normal)
            }
            animateCollectionView(shouldExpand: true, collectionView: senderCollectionView, withWidthConstraint: senderConstraint)
            sender.setTitle("Cancel", for: .normal)
        } else {
            animateCollectionView(shouldExpand: false, collectionView: senderCollectionView, withWidthConstraint: senderConstraint)
            sender.setTitle(currency, for: .normal)
        }
    }
}

//MARK: - CollectionView delegate methods
extension CalculatorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rates?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CurrencyCollectionViewCell.dequeueInCollectionView(collectionView, forIndexPath: indexPath)
        if let rates = self.rates {
            cell.titleLabel.text = Array(rates.keys)[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CurrencyCollectionViewCell
        let selectedCurrency = cell.titleLabel.text
        if collectionView == exchangeCollectionView {
            exchangeCurrency = selectedCurrency
            exchangeButton.setTitle(selectedCurrency, for: .normal)
            self.updateExchangeLabel()
            self.animateCollectionView(shouldExpand: false, collectionView: exchangeCollectionView, withWidthConstraint: exchangeCollectionViewWidthConstraint)
        } else {
            sourceCurrency = selectedCurrency!
            sourceCurrencyButton.setTitle(selectedCurrency, for: .normal)
            self.makeCurrencyCall(forCurrency: selectedCurrency!)
            self.animateCollectionView(shouldExpand: false, collectionView: sourceCollectionView, withWidthConstraint: sourceCurrencyCollectionViewWidthConstraint)
        }
    }
}
