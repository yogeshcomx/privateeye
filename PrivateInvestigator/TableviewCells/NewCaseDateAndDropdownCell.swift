//
//  NewCaseDateAndDropdownCell.swift
//  PrivateInvestigator
//
//  Created by apple on 6/22/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import UIDropDown

protocol CaseDateAndTimeSelectionDelegate: class {
    func caseDateSelected(caseDate:Date)
    func expandCell()
    func collapseCell()
    func caseExpectedOutcomesSelected(selectedOutcomes:[String])
}

class NewCaseDateAndDropdownCell: UITableViewCell {

    @IBOutlet weak var btnCalender: UIButton!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var dropdownExpectedOutcomes: UIDropDown!
    @IBOutlet weak var btnDone: UIButton!
    
    let datePicker = UIDatePicker()
    var delegate: CaseDateAndTimeSelectionDelegate?
    
    var selectedCaseExpectedOutcomes:[String] = []
    var selectedCaseExpectedOutcomeIndices:[Int] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupDropDownExpectedOutcomes()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickBtnCalender(_ sender: Any) {
        txtDate.becomeFirstResponder()
    }
    
    @IBAction func clickTxtDate(_ sender: Any) {
        showDatePicker()
    }
    
    @IBAction func clickBtnDone(_ sender: Any) {
        let _ = dropdownExpectedOutcomes.resign()
    }
    
    func showDatePicker(){
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date().addingTimeInterval(30.0 * 60.0)
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        txtDate.inputAccessoryView = toolbar
        txtDate.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy  HH:mm"
        let _ = formatter.string(from: datePicker.date)
        delegate?.caseDateSelected(caseDate: datePicker.date)
        self.txtDate.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.txtDate.endEditing(true)
    }
    
    
    func setupDropDownExpectedOutcomes() {
        dropdownExpectedOutcomes.borderWidth = 1.0
        dropdownExpectedOutcomes.tableHeight = 150.0
        dropdownExpectedOutcomes.extraWidth = 0.0
        dropdownExpectedOutcomes.multipleSelectionOption = true
        dropdownExpectedOutcomes.adjustsFontSizeToFitWidthValue = false
        dropdownExpectedOutcomes.tableWillAppear {
            self.delegate?.expandCell()
            self.btnDone.isHidden = false
            self.bringSubview(toFront: self.dropdownExpectedOutcomes)
        }
        dropdownExpectedOutcomes.title.text = "Select case outcome"
        dropdownExpectedOutcomes.textAlignment = .center
        dropdownExpectedOutcomes.textColor = UIColor.black
        dropdownExpectedOutcomes.placeholder = ""
        dropdownExpectedOutcomes.options = caseOutcomeListGlobal
        dropdownExpectedOutcomes.didSelect { (option, index) in
            //self.selectedCaseMinTime = filteredCaseMinTimeArray[index]
           // self.dropdownCaseMinTime.title.text = filteredCaseMinTimeArray[index].title
        }
        dropdownExpectedOutcomes.didSelectMultiple{ (option, index) in
            self.selectedCaseExpectedOutcomeIndices = index
            let dropdownTitle:String = option.joined(separator: ",")
            self.dropdownExpectedOutcomes.title.text = dropdownTitle
            
        }
        dropdownExpectedOutcomes.tableDidDisappear {
            self.delegate?.collapseCell()
            self.selectedCaseExpectedOutcomes = []
            for index in self.selectedCaseExpectedOutcomeIndices {
                self.selectedCaseExpectedOutcomes.append(caseOutcomeListGlobal[index])
            }
            self.delegate?.caseExpectedOutcomesSelected(selectedOutcomes: self.selectedCaseExpectedOutcomes)
            self.btnDone.isHidden = true
            self.reloadInputViews()
        }
        
    }
    
    
}
