//
//  WatsYourBirthCell.swift
//  fitapp
//
// on 05.05.2023.
//

import UIKit

protocol WatsYourBirthDelegate: AnyObject {
    func selectDate(date: String)
}

class WatsYourBirthCell: UICollectionViewCell {
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: WatsYourBirthDelegate?
    private var model: WatsYourBirthCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set the TextField's delegate to self
        dateTextField.delegate = self
        dateTextField.resignFirstResponder()
        textFieldView.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
        textFieldView.roundCorners(radius: 12)
        pickerView.roundCorners(radius: 12)
        visualEffect.isHidden = true
    }
    
    func configure(with model: WatsYourBirthCellViewModel) {
        self.model = model
        
        if !model.birth.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date = Date(timeIntervalSince1970: Double(model.birth) ?? .zero)
            let string = dateFormatter.string(from: date)
            self.dateTextField.text = string
        }
    }
    
    func showDatePicker() {
        datePicker?.locale = .current
        datePicker.datePickerMode = .date
        datePicker?.preferredDatePickerStyle = .inline
        datePicker.tintColor = Style.Color.starship.uiColor
        datePicker.overrideUserInterfaceStyle = .dark
        datePicker.backgroundColor = Style.Color.buttonColor.uiColor
        datePicker?.addTarget(self, action: #selector(dateSet), for: .valueChanged)
    }
    
    @objc func dateSet() {
        delegate?.selectDate(date: datePicker.date.toString(format: "dd/MM/yyyy"))
        dateTextField.text = datePicker.date.toString(format: "dd/MM/yyyy")
        self.model?.birth = "\(datePicker.date.timeIntervalSince1970)"
        visualEffect.isHidden = true
    }
    
    // MARK: - Actions
    
    @objc func doneButtonTapped() {
        dateTextField.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.model?.birth = "\(datePicker.date.timeIntervalSince1970)"
    }
    
}

extension WatsYourBirthCell: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTextField {
            textField.resignFirstResponder()
            showDatePicker()
            visualEffect.isHidden = false
        }
    }
}

