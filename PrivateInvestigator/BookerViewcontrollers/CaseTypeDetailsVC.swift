//
//  CaseTypeDetailsVC.swift
//  PrivateInvestigator
//
//  Created by apple on 7/13/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import UIDropDown

protocol CaseTypeSelectionDelegate: class {
    func caseSelected(caseTpe:CaseType, caseMinTime:Int, caseLength:CaseTime)
}


class CaseTypeDetailsVC: UIViewController {
    
    @IBOutlet weak var dropdownCaseType: UIDropDown!
    @IBOutlet weak var dropdownCaseMinTime: UIDropDown!
    @IBOutlet weak var dropdownCaseLength: UIDropDown!
    
    var selectedCase:CaseType?
    var selectedCaseMinTime:Int?
    var selectedCaseLength:CaseTime?
    var CaseTypeList:[CaseType] = []
    var delegate:CaseTypeSelectionDelegate?
    var datepickerForJobDate:Bool = true
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getCaseTypeList()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    
    @IBAction func clickBtnDone(_ sender: Any) {
        if selectedCase == nil {
            showAlert(title: "Error", message: "Please select case type")
        } else if selectedCaseMinTime == nil {
            showAlert(title: "Error", message: "Please select case minimum time")
        } else if selectedCaseLength == nil {
            showAlert(title: "Error", message: "Please select case length")
        } else {
            delegate?.caseSelected(caseTpe: selectedCase!, caseMinTime: selectedCaseMinTime!, caseLength: selectedCaseLength!)
            //navigationController?.popViewController(animated: true)
            NewCaseVC.caseGlobal.selectedCaseType = selectedCase!
            NewCaseVC.caseGlobal.selectedCaseMinTime = selectedCaseMinTime!
            NewCaseVC.caseGlobal.selectedCaseLength = selectedCaseLength!
            performSegue(withIdentifier: "toPOIDetailsFromCaseTypeDetails", sender: self)
        }
    }
    
    
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        dropdownCaseType.title.text = "Select case type"
        dropdownCaseMinTime.title.text = "Select case minimum time"
        dropdownCaseLength.title.text = "Select case length"
        dropdownCaseMinTime.isUserInteractionEnabled = false
    }
    
    
    func setupDropdownCaseType() {
        dropdownCaseType.borderWidth = 1.0
        dropdownCaseType.tableHeight = 450.0
        dropdownCaseType.extraWidth = 0.0
        dropdownCaseType.tableWillAppear {
            self.view.bringSubview(toFront: self.dropdownCaseType)
            self.view.sendSubview(toBack: self.dropdownCaseMinTime)
            self.view.sendSubview(toBack: self.dropdownCaseLength)
        }
        let casetypeNames = self.CaseTypeList.map{$0.case_type}
        dropdownCaseType.title.text = "Select case type"
        dropdownCaseType.textAlignment = .center
        dropdownCaseType.textColor = UIColor.black
        dropdownCaseType.placeholder = "Select case type"
        dropdownCaseType.options = casetypeNames
        dropdownCaseType.didSelect { (option, index) in
            self.selectedCase = self.CaseTypeList[index]
            self.dropdownCaseType.title.text = self.CaseTypeList[index].case_type
            self.selectedCaseLength = nil
            self.selectedCaseMinTime = nil
            self.setupDropdownCaseMinimumTime()
            self.setupDropdownCaseLength()
            let _ = self.dropdownCaseType.resign()
        }
        self.view.addSubview(dropdownCaseType)
    }
    
    
    func setupDropdownCaseMinimumTime() {
//        let filteredCaseMinTimeArray:[CaseTime] = caseTimeValuesGlobal.filter{$0.minutes >= Int(selectedCase!.min_length_with_travel) ?? 0}
        dropdownCaseMinTime.borderWidth = 1.0
//        dropdownCaseMinTime.tableHeight = 180.0
//        dropdownCaseMinTime.extraWidth = 0.0
//        dropdownCaseMinTime.tableWillAppear {
//            self.view.sendSubview(toBack: self.dropdownCaseLength)
//            self.view.bringSubview(toFront: self.dropdownCaseMinTime)
//            self.view.sendSubview(toBack: self.dropdownCaseType)
//        }
//        let caseMinTimeNames = filteredCaseMinTimeArray.map{$0.title}
        
        dropdownCaseMinTime.title.text = Int((selectedCase?.min_length_with_travel)!)?.minutesToTimestamp()
        dropdownCaseMinTime.textAlignment = .center
        dropdownCaseMinTime.textColor = UIColor.black
        self.selectedCaseMinTime = Int((selectedCase?.min_length_with_travel)!)
        self.selectedCaseLength = nil
//        dropdownCaseMinTime.placeholder = ""
//        dropdownCaseMinTime.options = caseMinTimeNames
//        dropdownCaseMinTime.didSelect { (option, index) in
//            self.selectedCaseMinTime = filteredCaseMinTimeArray[index]
//            self.dropdownCaseMinTime.title.text = filteredCaseMinTimeArray[index].title
//            self.selectedCaseLength = nil
//            self.setupDropdownCaseLength()
//            let _ = self.dropdownCaseMinTime.resign()
//        }
//        self.view.addSubview(dropdownCaseMinTime)
    }
    
    
    func setupDropdownCaseLength() {
        let filteredCaseLengthArray:[CaseTime] = caseTimeValuesGlobal.filter{$0.minutes >=  Int((selectedCase?.min_length_with_travel) ?? "0") ?? 0 }
        dropdownCaseLength.borderWidth = 1.0
        dropdownCaseLength.tableHeight = 180.0
        dropdownCaseLength.extraWidth = 0.0
        dropdownCaseLength.tableWillAppear {
            self.view.bringSubview(toFront: self.dropdownCaseLength)
            self.view.sendSubview(toBack: self.dropdownCaseType)
            self.view.sendSubview(toBack: self.dropdownCaseMinTime)
        }
        let caseLengthNames = filteredCaseLengthArray.map{$0.title}
        dropdownCaseLength.title.text = "Select case length"
        dropdownCaseLength.textAlignment = .center
        dropdownCaseLength.textColor = UIColor.black
        dropdownCaseLength.placeholder = ""
        dropdownCaseLength.options = caseLengthNames
        dropdownCaseLength.didSelect { (option, index) in
            self.selectedCaseLength = filteredCaseLengthArray[index]
            self.dropdownCaseLength.title.text = filteredCaseLengthArray[index].title
            let _ = self.dropdownCaseLength.resign()
        }
        self.view.addSubview(dropdownCaseLength)
    }
    
    func loadData() {
        selectedCase = NewCaseVC.caseGlobal.selectedCaseType
        selectedCaseMinTime = NewCaseVC.caseGlobal.selectedCaseMinTime
        selectedCaseLength = NewCaseVC.caseGlobal.selectedCaseLength
        if selectedCase != nil {
            dropdownCaseType.title.text = selectedCase?.case_type ?? "Select case type"
            dropdownCaseMinTime.title.text = selectedCaseMinTime?.minutesToTimestamp() ?? "Select case minimum time"
            dropdownCaseLength.title.text = selectedCaseLength?.title ?? "Select case length"
        }
    }
    
    func getCaseTypeList() {
        let _ = showActivityIndicator()
        if caseTypesListGlobal.count > 0 {
            self.CaseTypeList = caseTypesListGlobal
            self.setupDropdownCaseType()
            hideActivityIndicator()
        } else {
            APIManager.sharedInstance.getCaseTypeList(onSuccess: { casetypes in
                caseTypesListGlobal = casetypes
                self.CaseTypeList = casetypes
                self.setupDropdownCaseType()
                self.hideActivityIndicator()
            }, onFailure: { error in
                print(error)
                self.hideActivityIndicator()
            })
        }
    }
    

}
