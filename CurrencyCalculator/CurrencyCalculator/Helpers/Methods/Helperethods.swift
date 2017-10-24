//
//  Helperethods.swift
//  CurrencyCalculator
//
//  Created by Emmanouil Zervos on 24/10/2017.
//  Copyright © 2017 manos. All rights reserved.
//

import Foundation

func makeCalculation(operand: String, firstValue: Double, secondValue: Double) -> Double{
    switch operand {
    case "+":
        return firstValue + secondValue
    case "-":
        return firstValue - secondValue
    case "x":
        return firstValue * secondValue
    case "/":
        return firstValue / secondValue
    case "%":
        return firstValue / 100
    case "+/-":
        return firstValue * -1
    default:
        return 0
    }
}
