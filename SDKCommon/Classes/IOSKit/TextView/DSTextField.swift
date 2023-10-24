//
//  DSTextField.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 13/10/23.
//

import Foundation
import UIKit
import SnapKit

public class DSTextField: UITextField, UITextFieldDelegate {
    private var underlineView: UIView?
    private var underlineColor: UIColor = .lightGray
    private var isUnderlined: Bool = false
    private var customInputAccessoryView: UIView?
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = DSColor.darkest
        label.numberOfLines = 0
        label.font = .circularBold(size: 15)
        label.textAlignment = .center
        return label
    }()
    
    public enum Masks {
        case none
        case currency
    }
    
    // Initializer to allow specifying the underline color, whether to underline, and the mask
    public convenience init(underlineColor: UIColor = .lightGray,
                            isUnderlined: Bool = false,
                            mask: Masks = .currency,
                            label: String? = nil) {
        self.init()
        self.underlineColor = underlineColor
        self.isUnderlined = isUnderlined
        setupTextField()
        
        switch mask {
        case .currency:
            addCurrencyMask()
        case .none:
            break
        }
        
        if let label = label {
            self.label.text = label
            setupLabel()
        }
        
        // Create and set the custom input accessory view
        customInputAccessoryView = createCustomInputAccessoryView()
        self.inputAccessoryView = customInputAccessoryView
    }
    
    private func setupLabel() {
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-20)
            make.left.equalToSuperview()
        }
    }
    
    private func setupTextField() {
        if isUnderlined {
            underlineView = UIView()
            underlineView?.backgroundColor = underlineColor
            addSubview(underlineView!)

            // Constraints for the underline view using SnapKit
            underlineView?.snp.makeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(1.0)
            }
        }
        
        self.font = .circularBold(size: 24)
        
        // Change placeholder text size
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.circularBold(size: 24),
            .foregroundColor: DSColor.secondary
        ]
        self.attributedPlaceholder = NSAttributedString(string: "R$: 0,00", attributes: attributes)
    }
    
    private func addCurrencyMask() {
        // Add a target to respond to editing changes
        self.addTarget(self, action: #selector(formatCurrency), for: .editingChanged)
        keyboardType = .numberPad
    }
    
    @objc private func formatCurrency() {
        guard let text = self.text, !text.isEmpty else {
            return
        }
        
        if let amountString = self.text?.currencyInputFormatting() {
            self.text = amountString
        }
    }
    
    private func createCustomInputAccessoryView() -> UIView {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Confirmar", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [UIBarButtonItem(customView: doneButton)] // Add a closing bracket here

        return toolbar
    }
    
    @objc
    func doneButtonTapped() {
        self.resignFirstResponder()
     }
}
