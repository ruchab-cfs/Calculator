//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by apple on 24/02/25.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    
    @IBOutlet weak var displayLabel: UILabel!
    var displayNumber: Double {
        let text = displayLabel.text!
        let number = Double(text)!
        return number
    }
    
    @IBOutlet var roundButtons: [UIButton]!
    
    @IBOutlet weak var divideButton: OperatorButton!
    @IBOutlet weak var multiplayButton: OperatorButton!
    @IBOutlet weak var minusButton: OperatorButton!
    @IBOutlet weak var plusButton: OperatorButton!
    
    lazy var operationButtons: [OperatorButton] = [divideButton, multiplayButton, minusButton, plusButton]

    enum Operation {
        case divide
        case multiply
        case subtract
        case add
        case none
    }
    var operation: Operation = .none
    
    var opertaionIsSelected: Bool{
        for button in operationButtons {
            if button.isSelection {
                return true
            }
        }
        return false
    }
    
    var previousNumber: Double?
    var equalButtonTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    func setupButtons(){
//        for button in operationButtons {
//            button.layer.cornerRadius = button.frame.height / 2
//        }
//        
//        for button in roundButtons {
//            button.layer.cornerRadius = button.frame.height / 2
//        }
        
        for i in 0..<roundButtons.count {
        roundButtons[i].layer.cornerRadius = 16
    }
     
    }

    @IBAction func didTapOperationButton(_ sender: OperatorButton) {
        
        if previousNumber != nil, !equalButtonTapped, !opertaionIsSelected {
            performOperation()
            self.previousNumber = nil
        }
        
        let title = sender.currentTitle
        switch title {
        case "÷":
            operation = .divide
        case "x":
            operation = .multiply
        case "-":
            operation = .subtract
        case "+":
            operation = .add
        case .none:
            operation = .none
        default:
            break
        }
        highlightButton(sender)
        equalButtonTapped = false
        previousNumber = displayNumber
    }
    
    func deselectButtons(){
        
        operationButtons.forEach { button in
            button.backgroundColor = .systemOrange
            button.setTitleColor(.white, for: .normal)
            button.isSelection = false
        }
    }
        func highlightButton(_ button: OperatorButton){
            deselectButtons()
            button.backgroundColor = .white
            button.setTitleColor(.systemOrange, for: .normal)
            button.isSelection = true
        }
        
    
    @IBAction func didTapNumberButton(_ sender: UIButton) {
        let number = sender.tag
        
        
        if opertaionIsSelected {
            deselectButtons()
            displayLabel.text = "\(number)"
        }else{
            if displayNumber == 0 {
                displayLabel.text = "\(number)"
            } else {
                displayLabel.text! += "\(number)"
            }
        }
    }
    
    func performOperation(){
        guard let previousNumber else { return }
        var result: Double = 0
        
        switch operation {
        case .divide:
            result = previousNumber / displayNumber
            
        case .multiply:
            result = previousNumber * displayNumber
            
        case .subtract:
            result = previousNumber - displayNumber
            
        case .add:
            result = previousNumber + displayNumber
            
        case .none:
            return
        }
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            let int = Int(result)
            displayLabel.text = "\(int)"
        } else {
            displayLabel.text = "\(result)"
        }
        self.previousNumber = result
    }
    
    @IBAction func didTapDecimalButton() {
        let text = displayLabel.text!
        if text.last == "." {
            displayLabel.text?.removeLast()
        } else if !text.contains(".") {
            displayLabel.text! += "."
        }
    }
    
    @IBAction func didTapEqualButton() {
        guard operation != .none else { return }
        performOperation()
        equalButtonTapped = true
    }
    
    @IBAction func didTapPercentButton() {
        guard var n = Double(displayLabel.text!) else {
            return }
        n /= 100
    }
    
    @IBAction func didTapPlusMinusButton() {
        guard var n = Double(displayLabel.text!) else {
            return }
        n *= -1
        displayLabel.text = "\(n)"
    }
    
    @IBAction func didTapClearButton() {
        previousNumber = nil
        displayLabel.text = "0"
        operation = .none
        deselectButtons()
    }
}
