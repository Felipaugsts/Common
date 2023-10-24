//
//  IconTextField.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 14/10/23.
//

import Foundation
import UIKit

public class IconTextField: UIView, UITextFieldDelegate {

    public let textField = UITextField()
    private let iconImageView = UIImageView()

    let underline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = DSColor.dark
        return view
    }()
    
    public init(icon: UIImage, placeholder: String) {
        super.init(frame: .zero)

        // Configure the icon image view
        iconImageView.image = icon
        iconImageView.tintColor = DSColor.dark
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        // Configure the text field
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        addSubview(iconImageView)
        addSubview(textField)
        addSubview(underline)

        // Layout constraints
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),

            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            underline.topAnchor.constraint(equalTo: textField.bottomAnchor),
            underline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            underline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            underline.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var inputAccessoryView: UIView? {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Confirmar", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        // Create a toolbar with the "Done" button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [UIBarButtonItem(customView: doneButton)]
        
        return toolbar
    }
    
    @objc func doneButtonTapped() {
         textField.resignFirstResponder()
     }
}
