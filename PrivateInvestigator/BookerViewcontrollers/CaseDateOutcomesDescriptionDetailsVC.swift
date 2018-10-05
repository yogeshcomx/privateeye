//
//  CaseDateOutcomesDescriptionDetailsVC.swift
//  PrivateInvestigator
//
//  Created by apple on 9/20/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class CaseDateOutcomesDescriptionDetailsVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    
    //Case Date and time
    var selectedCaseDate:String?
    var selectedCaseStartTime:String?
    var selectedCaseExpectedOutcomes:[String] = []
    var showDropDownInCaseDateAndTimeCell:Bool = false
    //Private Eye Rating
    var selectedPIRating:Double?
    
    var CaseDescriptionString:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableview()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }

    
    @IBAction func clickBtnNext(_ sender: Any) {
        if selectedCaseDate == nil || selectedCaseStartTime == nil {
            showAlert(title: "Error", message: "Please select case date and time")
        } else if selectedCaseExpectedOutcomes.count == 0 {
            showAlert(title: "Error", message: "Please select expected outcomes of the case")
        } else if CaseDescriptionString == nil || CaseDescriptionString == "" {
            showAlert(title: "Error", message: "Please enter case description")
        } else {
            NewCaseVC.caseGlobal.selectedCaseDate = selectedCaseDate
            NewCaseVC.caseGlobal.selectedCaseStartTime = selectedCaseStartTime
            NewCaseVC.caseGlobal.selectedCaseExpectedOutcomes = selectedCaseExpectedOutcomes
            NewCaseVC.caseGlobal.selectedPIRating = selectedPIRating
            NewCaseVC.caseGlobal.CaseDescriptionString = CaseDescriptionString
            
           performSegue(withIdentifier: "toTipsDetailsFromCaseDateOutcomeDescriptionDetails", sender: self)
        }
        
    }
    
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
    }
    
    
    func setupTableview() {
        tableview.register(UINib(nibName: "NewCaseOptionsCell", bundle: Bundle.main), forCellReuseIdentifier: "NewCaseOptionsCell")
        tableview.register(UINib(nibName: "NewCaseRatingCell", bundle: Bundle.main), forCellReuseIdentifier: "NewCaseRatingCell")
        tableview.register(UINib(nibName: "NewCaseDateAndDropdownCell", bundle: Bundle.main), forCellReuseIdentifier: "NewCaseDateAndDropdownCell")
        tableview.register(UINib(nibName: "NewCaseDescriptionCell", bundle: Bundle.main), forCellReuseIdentifier: "NewCaseDescription")
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func loadData() {
        selectedCaseDate = NewCaseVC.caseGlobal.selectedCaseDate
        selectedCaseStartTime = NewCaseVC.caseGlobal.selectedCaseStartTime
        selectedCaseExpectedOutcomes = NewCaseVC.caseGlobal.selectedCaseExpectedOutcomes
        selectedPIRating = NewCaseVC.caseGlobal.selectedPIRating
        CaseDescriptionString = NewCaseVC.caseGlobal.CaseDescriptionString
    }
}


extension CaseDateOutcomesDescriptionDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return showDropDownInCaseDateAndTimeCell ? 350 : 180
        } else if indexPath.section == 1 {
            return 80
        } else if indexPath.section == 2 {
            return 160
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0 {
            let dateCell: NewCaseDateAndDropdownCell = tableview.dequeueReusableCell(withIdentifier: "NewCaseDateAndDropdownCell", for: indexPath) as! NewCaseDateAndDropdownCell
            dateCell.delegate = self
            dateCell.txtDate.text = "\(selectedCaseDate ?? "") \(selectedCaseStartTime ?? "")"
            if selectedCaseExpectedOutcomes.count > 0 {
                dateCell.dropdownExpectedOutcomes.title.text = selectedCaseExpectedOutcomes.joined(separator: ",")
            }
            return dateCell
            
        } else if indexPath.section == 1 {
            let ratingCell: NewCaseRatingCell = tableview.dequeueReusableCell(withIdentifier: "NewCaseRatingCell", for: indexPath) as! NewCaseRatingCell
            ratingCell.lblTitle.text = "Private Eye Ratings must be"
            ratingCell.viewRating.rating = selectedPIRating ?? 1.0
            ratingCell.delegate = self
            return ratingCell
            
        } else if indexPath.section == 2 {
            let descriptionCell: NewCaseDescriptionCell = tableview.dequeueReusableCell(withIdentifier: "NewCaseDescription", for: indexPath) as! NewCaseDescriptionCell
            descriptionCell.txtCaseDescription.addBorder(color: UIColor.black.cgColor, width: 1.0)
            descriptionCell.txtCaseDescription.text = CaseDescriptionString
            descriptionCell.delegate = self
            return descriptionCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func newCaseTitleAttributedText( boldString: String, normalString: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: boldString,
                                                         attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 16.0)])
        let normalString = NSMutableAttributedString(string: normalString,
                                                     attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 15.0)])
        attributedString.append(normalString)
        return attributedString
    }
}

extension CaseDateOutcomesDescriptionDetailsVC: CaseDateAndTimeSelectionDelegate {
    func caseDateSelected(caseDate:Date) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy"
        selectedCaseDate = dateformatter.string(from: caseDate)
        NewCaseVC.caseGlobal.selectedCaseDate = dateformatter.string(from: caseDate)
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        selectedCaseStartTime = timeformatter.string(from: caseDate)
        NewCaseVC.caseGlobal.selectedCaseStartTime = timeformatter.string(from: caseDate)
        let indexPath = IndexPath(row: 0, section: 0)
        tableview.reloadRows(at: [indexPath], with: .fade)
    }
    
    func expandCell() {
        showDropDownInCaseDateAndTimeCell = true
        let indexPath = IndexPath(row: 0, section: 0)
        tableview.beginUpdates()
        tableview.endUpdates()
        tableview.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func collapseCell() {
        showDropDownInCaseDateAndTimeCell = false
        tableview.beginUpdates()
        tableview.endUpdates()
    }
    
    func caseExpectedOutcomesSelected(selectedOutcomes: [String]) {
        selectedCaseExpectedOutcomes = selectedOutcomes
        NewCaseVC.caseGlobal.selectedCaseExpectedOutcomes = selectedOutcomes
        let indexPath = IndexPath(row: 0, section: 0)
        tableview.reloadRows(at: [indexPath], with: .fade)
        
    }
}



extension CaseDateOutcomesDescriptionDetailsVC: RatingSelectionDelegate {
    func ratingSelected(piRating: Double) {
        selectedPIRating = piRating
        NewCaseVC.caseGlobal.selectedPIRating = piRating
        // let indexPath = IndexPath(row: 0, section: 3)
        // tableview.reloadRows(at: [indexPath], with: .fade)
    }
}




extension CaseDateOutcomesDescriptionDetailsVC: CaseDescriptionTextDelegate {
    func caseDescriptionTextChanged(descriptionText: String) {
        CaseDescriptionString = descriptionText
        NewCaseVC.caseGlobal.CaseDescriptionString = descriptionText
    }
}


