//
//  File.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 13/10/23.
//

import UIKit

public protocol KeyboardPickerDelegate: AnyObject {
    func didSelectOption(_ option: String)
}

public class KeyboardPickerTextField: UITextField {

    private let pickerView = UIPickerView()
    private var pickerData = [String]()
    private var currentRow: Int = 0
    private weak var pickerDelegate: KeyboardPickerDelegate?

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configurePicker()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configurePicker()
    }

    private func configurePicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        inputView = pickerView

        // Create a "Done" button for the input accessory view
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexibleSpace, doneButton]
        inputAccessoryView = toolbar
    }

    @objc private func doneButtonTapped() {
        hidePicker()
        let formattedValue = String(format: "%02d", currentRow == 0 ? 1 : currentRow)
        pickerDelegate?.didSelectOption(formattedValue)
    }


    public func setPickerData(_ data: [String]) {
        pickerData = data
        pickerView.reloadAllComponents()
    }

    public func showPicker(at: Int = 0) {
        currentRow = at + 1
        pickerView.reloadAllComponents()
        pickerView.selectRow(at, inComponent: 0, animated: false)
        self.becomeFirstResponder()
    }

    public func hidePicker() {
        self.resignFirstResponder()
    }

    public func setPickerDelegate(_ delegate: KeyboardPickerDelegate) {
        pickerDelegate = delegate
    }
}

extension KeyboardPickerTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let updatedRow = row + 1
        currentRow = updatedRow
    }
}
