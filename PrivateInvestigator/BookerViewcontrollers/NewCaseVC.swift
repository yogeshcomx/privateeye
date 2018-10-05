//
//  NewCaseVC.swift
//  PrivateInvestigator
//
//  Created by apple on 6/22/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class NewCaseVC: UIViewController {

    @IBOutlet weak var btnConditionsAndDetailsCheckbox: UIButton!
    @IBOutlet weak var btnSaveAndFindPI: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    var conditionsAndDetailsStatus:Bool = false
    var showDropDownInCaseDateAndTimeCell:Bool = false
    
    struct caseGlobal {
        //Case Type
       static var selectedCaseType:CaseType?
       static var selectedCaseMinTime:Int?
       static var selectedCaseLength:CaseTime?
        //POI Details
       static var selectedImagesOfPOI: [UIImage] = []
       static var selectedPOIName: String?
       static var selectedPOIType: String?
       static var selectedAge: String?
       static var selectedAgeRange: String?
       static var selectedGenderPOI: GenderPOI = .None
       static var acceptedTermsAndConditions: Bool = false
       static var selectedIdentifyingTags:String?
       static var CaseDescriptionString:String?
        //LocationDetails
       static var locationName:String?
       static var extraAddress:String?
       static var street:String?
       static var city:String?
       static var state:String?
       static var country:String?
       static var zipcode:String?
       static var caseLat:Double?
       static var caseLng:Double?
        //Case Date and time
       static var selectedCaseDate:String?
       static var selectedCaseStartTime:String?
       static var selectedCaseExpectedOutcomes:[String] = []
        //Private Eye Rating
       static var selectedPIRating:Double?
        //Tips For Case Type
       static var selectedTipsIDs:[String] = []
       static var selectedRulesIDs:[String] = []
    }
    
    /*
    
    //Case Type
    var selectedCaseType:CaseType?
    var selectedCaseMinTime:Int?
    var selectedCaseLength:CaseTime?
    //POI Details
    var selectedImagesOfPOI: [UIImage] = []
    var selectedPOIName: String?
    var selectedPOIType: String?
    var selectedAge: String?
    var selectedAgeRange: String?
    var selectedGenderPOI: GenderPOI = .None
    var acceptedTermsAndConditions: Bool = false
    var selectedIdentifyingTags:String?
    var CaseDescriptionString:String?
    //LocationDetails
    var locationName:String?
    var extraAddress:String?
    var street:String?
    var city:String?
    var state:String?
    var country:String?
    var zipcode:String?
    var caseLat:Double?
    var caseLng:Double?
    //Case Date and time
    var selectedCaseDate:String?
    var selectedCaseStartTime:String?
    var selectedCaseExpectedOutcomes:[String] = []
    var showDropDownInCaseDateAndTimeCell:Bool = false
    //Private Eye Rating
    var selectedPIRating:Double?
    //Tips For Case Type
    var selectedTipsIDs:[String] = []
    var selectedRulesIDs:[String] = []
 
 
    */
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
    }
    
    @IBAction func clickBtnConditionsAndDetails(_ sender: Any) {
        selectConditionsAndDetails()
       
    }
    
    @IBAction func clickBtnSaveAndFindPI(_ sender: Any) {
        if caseGlobal.selectedCaseType == nil || caseGlobal.selectedCaseMinTime == nil || caseGlobal.selectedCaseLength == nil {
            showAlert(title: "Error", message: "Please Enter Case Type details")
        } else if caseGlobal.locationName == nil || caseGlobal.extraAddress == nil || caseGlobal.street == nil || caseGlobal.city == nil || caseGlobal.state == nil || caseGlobal.country == nil || caseGlobal.zipcode == nil {
            showAlert(title: "Error", message: "Please Enter Location Details" )
        } else if caseGlobal.selectedPOIName == nil || caseGlobal.selectedPOIType == nil || (caseGlobal.selectedAge == nil && caseGlobal.selectedAgeRange == nil) || caseGlobal.selectedGenderPOI == .None || caseGlobal.acceptedTermsAndConditions == false || caseGlobal.selectedIdentifyingTags == nil || caseGlobal.selectedImagesOfPOI.count == 0 {
            showAlert(title: "Error", message: "Please Enter Person of Interest Details")
        } else if caseGlobal.selectedCaseDate == nil || caseGlobal.selectedCaseStartTime == nil {
            showAlert(title: "Error", message: "Please select case date and time")
        } else if caseGlobal.selectedCaseExpectedOutcomes.count == 0 {
            showAlert(title: "Error", message: "Please select expected outcomes of the case")
        } else if caseGlobal.CaseDescriptionString == nil || caseGlobal.CaseDescriptionString == "" {
            showAlert(title: "Error", message: "Please enter case description")
        } else if caseGlobal.selectedTipsIDs.count == 0 {
            showAlert(title: "Error", message: "Please accept all the tips about case type")
        } else if caseGlobal.selectedRulesIDs.count == 0 {
            showAlert(title: "Error", message: "Please accept all the rules about case type")
        } else if conditionsAndDetailsStatus == false {
            showAlert(title: "Error", message: "Please accept terms and conditions before creating case")
        } else {
            createNewCase()
        }
    }
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        btnSaveAndFindPI.roundAllCorners(radius: 5.0)
        //btnSaveAndFindPI.addBorder(color: UIColor.black.cgColor, width: 1.0)
    }
    
    func setupTableview() {
        tableview.register(UINib(nibName: "NewCaseOptionsCell", bundle: Bundle.main), forCellReuseIdentifier: "NewCaseOptionsCell")
        tableview.register(UINib(nibName: "NewCaseRatingCell", bundle: Bundle.main), forCellReuseIdentifier: "NewCaseRatingCell")
        tableview.register(UINib(nibName: "NewCaseDateAndDropdownCell", bundle: Bundle.main), forCellReuseIdentifier: "NewCaseDateAndDropdownCell")
        tableview.register(UINib(nibName: "NewCaseDescriptionCell", bundle: Bundle.main), forCellReuseIdentifier: "NewCaseDescription")
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func selectConditionsAndDetails() {
        if conditionsAndDetailsStatus {
            conditionsAndDetailsStatus = false
            btnConditionsAndDetailsCheckbox.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
        } else {
            conditionsAndDetailsStatus = true
            btnConditionsAndDetailsCheckbox.setImage(UIImage(named:"checked"), for: UIControlState.normal)
        }
    }
    
    
    func createNewCase() {
        showActivityIndicator()
        let add1 = "\(caseGlobal.extraAddress!), \(caseGlobal.street!),"
        let add2 = "\(caseGlobal.city!), \(caseGlobal.state!),"
        let add3 = "\(caseGlobal.country!), \(caseGlobal.zipcode!)"
        let address:String = add1 + add2 + add3
        let outcomeString:String = caseGlobal.selectedCaseExpectedOutcomes.joined(separator: ",")
        let tipsIdString:String = caseGlobal.selectedTipsIDs.joined(separator: ",")
        var age:String = caseGlobal.selectedAge ?? ""
        if age == "" {
            age = caseGlobal.selectedAgeRange!
        }
        APIManager.sharedInstance.postCreateNewCase(caseTypeId: (caseGlobal.selectedCaseType?.id)!, caseTypeTitle: (caseGlobal.selectedCaseType?.case_type)!, caseMinTime: "\((caseGlobal.selectedCaseMinTime)!)", caseTime: "\((caseGlobal.selectedCaseLength?.minutes)!)", poiName: caseGlobal.selectedPOIName!, poiType: caseGlobal.selectedPOIType!, poiAge: age, poiGender: caseGlobal.selectedGenderPOI.rawValue, poiTargetIdentityTags: caseGlobal.selectedIdentifyingTags!, secondSuspect: "", caseDescription: caseGlobal.CaseDescriptionString!, poiImages: caseGlobal.selectedImagesOfPOI, caseLocationName: caseGlobal.locationName!, caseLocationAddress: address, caseLat: caseGlobal.caseLat ?? 0.0, caseLng: caseGlobal.caseLng ?? 0.0, caseDate: caseGlobal.selectedCaseDate!, caseStartTime: caseGlobal.selectedCaseStartTime!, expectedOutcomes: outcomeString, tipsIds: tipsIdString, onSuccess: { status in
            self.hideActivityIndicator()
            if status {
                self.showAlert(title: "Success", message: "Case Created Successfully!!\n We will notify you once private eye accepts your case.")
                self.clearAllCaseData()
                self.tableview.reloadData()
                self.selectConditionsAndDetails()
            } else {
                self.showAlert(title: "Error", message: "Not able to create new case.")
            }
        }, onFailure: { error  in
            self.hideActivityIndicator()
            self.showAlert(title: "Error", message: "Not able to create new case.")
        })
    }
    
    func clearAllCaseData() {
        caseGlobal.selectedCaseType = nil
        caseGlobal.selectedCaseMinTime = nil
        caseGlobal.selectedCaseLength = nil
        
        caseGlobal.selectedImagesOfPOI = []
        caseGlobal.selectedPOIName = nil
        caseGlobal.selectedPOIType = nil
        caseGlobal.selectedAge = nil
        caseGlobal.selectedAgeRange = nil
        caseGlobal.selectedGenderPOI = .None
        caseGlobal.acceptedTermsAndConditions = false
        caseGlobal.selectedIdentifyingTags = nil
        caseGlobal.CaseDescriptionString = nil
        
        caseGlobal.locationName = nil
        caseGlobal.extraAddress = nil
        caseGlobal.street = nil
        caseGlobal.city = nil
        caseGlobal.state = nil
        caseGlobal.country = nil
        caseGlobal.zipcode = nil
        caseGlobal.caseLat = nil
        caseGlobal.caseLng = nil
        
        
        
        caseGlobal.selectedCaseDate = nil
        caseGlobal.selectedCaseStartTime = nil
        caseGlobal.selectedCaseExpectedOutcomes = []
        
        caseGlobal.selectedPIRating = nil
        
        caseGlobal.selectedTipsIDs = []
        caseGlobal.selectedRulesIDs = []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCaseTypeDetailsFromNewCase" {
            let destVC:CaseTypeDetailsVC = segue.destination as! CaseTypeDetailsVC
            destVC.delegate = self
            if caseGlobal.selectedCaseType != nil {
                destVC.selectedCase = caseGlobal.selectedCaseType
                destVC.selectedCaseMinTime = caseGlobal.selectedCaseMinTime
                destVC.selectedCaseLength = caseGlobal.selectedCaseLength
            }
        } else if segue.identifier == "toPOIDetailsFromNewCase" {
            let destVC:POIDetailsVC = segue.destination as! POIDetailsVC
            destVC.delegate = self
            if caseGlobal.selectedPOIName != nil {
                destVC.selectedPOIName = caseGlobal.selectedPOIName
                destVC.selectedPOIType = caseGlobal.selectedPOIType
                destVC.selectedAge = caseGlobal.selectedAge
                destVC.selectedAgeRange = caseGlobal.selectedAgeRange
                destVC.selectedGenderPOI = caseGlobal.selectedGenderPOI
                destVC.selectedImagesOfPOI = caseGlobal.selectedImagesOfPOI
                destVC.selectedIdentifyingTags = caseGlobal.selectedIdentifyingTags
                destVC.acceptedTermsAndConditions = caseGlobal.acceptedTermsAndConditions
            }
            
        } else if segue.identifier == "toJobLocationDetailsFromNewCase" {
            let destVC:JobLocationDetailsVC = segue.destination as! JobLocationDetailsVC
            destVC.delegate = self
            destVC.locationName = caseGlobal.locationName
            destVC.locationName = caseGlobal.locationName
            destVC.extraAddress = caseGlobal.extraAddress
            destVC.street = caseGlobal.street
            destVC.city = caseGlobal.city
            destVC.state = caseGlobal.state
            destVC.country = caseGlobal.country
            destVC.zipcode = caseGlobal.zipcode
            destVC.lat = caseGlobal.caseLat
            destVC.lng = caseGlobal.caseLng
        } else if segue.identifier == "toTipsAboutCaseTypeFromNewCase" {
            let destVC:TipsAboutCaseTypeVCViewController = segue.destination as! TipsAboutCaseTypeVCViewController
            destVC.delegate = self
            destVC.selectedTipsIds = caseGlobal.selectedTipsIDs
        } else if segue.identifier == "toRulesAboutCaseTypeFromNewCase" {
            let destVC:RulesAboutCaseTypeVC = segue.destination as! RulesAboutCaseTypeVC
            destVC.delegate = self
            destVC.selectedRulesIds = caseGlobal.selectedRulesIDs
        }
    }
}



extension NewCaseVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           return 2
        } else if section == 1 {
           return 1
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return 1
        } else if section == 4 {
            return 1
        } else if section == 5 {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return showDropDownInCaseDateAndTimeCell ? 350 : 180
        } else if indexPath.section == 3 {
            return 80
        } else if indexPath.section == 4 {
            return 160
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0 {
            let optionCell: NewCaseOptionsCell = tableview.dequeueReusableCell(withIdentifier: "NewCaseOptionsCell", for: indexPath) as! NewCaseOptionsCell
            if indexPath.row == 0 {
                if caseGlobal.selectedCaseType != nil {
                    let casetypeString:String = caseGlobal.selectedCaseType?.case_type ?? ""
                    let attrString = newCaseTitleAttributedText(boldString: "Case Type: ", normalString: casetypeString)
                    optionCell.lblOptionTitle.attributedText = attrString
                } else {
                    let attrString = newCaseTitleAttributedText(boldString: "Case Type (Minimum time booking)", normalString: "")
                    optionCell.lblOptionTitle.attributedText = attrString
                }
                optionCell.imgIcon.image = UIImage(named:"eye")
            } else if indexPath.row == 1 {
                if caseGlobal.locationName != nil {
                    let attrString = newCaseTitleAttributedText(boldString: "Location: ", normalString: "\(caseGlobal.locationName!)")
                    optionCell.lblOptionTitle.attributedText = attrString
                } else {
                    let attrString = newCaseTitleAttributedText(boldString: "Location Type (Must Choose)", normalString: "")
                    optionCell.lblOptionTitle.attributedText = attrString
                }
                optionCell.imgIcon.image = UIImage(named:"marker")
            }
            return optionCell
        } else if indexPath.section == 1 {
            let optionCell: NewCaseOptionsCell = tableview.dequeueReusableCell(withIdentifier: "NewCaseOptionsCell", for: indexPath) as! NewCaseOptionsCell
            if indexPath.row == 0 {
                if caseGlobal.selectedPOIName != nil {
                    let attrString = newCaseTitleAttributedText(boldString: "POI: ", normalString: "\(caseGlobal.selectedPOIName!)")
                    optionCell.lblOptionTitle.attributedText = attrString
                } else {
                    let attrString = newCaseTitleAttributedText(boldString: "Choose (Person of Intrest) POI & Define", normalString: "")
                    optionCell.lblOptionTitle.attributedText = attrString
                }
                optionCell.imgIcon.image = UIImage(named:"person")
            }
            return optionCell
        } else if indexPath.section == 2 {
            let dateCell: NewCaseDateAndDropdownCell = tableview.dequeueReusableCell(withIdentifier: "NewCaseDateAndDropdownCell", for: indexPath) as! NewCaseDateAndDropdownCell
            dateCell.delegate = self
            dateCell.txtDate.text = "\(caseGlobal.selectedCaseDate ?? "") \(caseGlobal.selectedCaseStartTime ?? "")"
            if caseGlobal.selectedCaseExpectedOutcomes.count > 0 {
                dateCell.dropdownExpectedOutcomes.title.text = caseGlobal.selectedCaseExpectedOutcomes.joined(separator: ",")
            } else {
                dateCell.dropdownExpectedOutcomes.title.text = ""
            }
            return dateCell
            
        } else if indexPath.section == 3 {
            let ratingCell: NewCaseRatingCell = tableview.dequeueReusableCell(withIdentifier: "NewCaseRatingCell", for: indexPath) as! NewCaseRatingCell
            ratingCell.lblTitle.text = "Private Eye Ratings must be"
            ratingCell.viewRating.rating = caseGlobal.selectedPIRating ?? 1.0
            ratingCell.delegate = self
            return ratingCell
        } else if indexPath.section == 4 {
            let descriptionCell: NewCaseDescriptionCell = tableview.dequeueReusableCell(withIdentifier: "NewCaseDescription", for: indexPath) as! NewCaseDescriptionCell
            descriptionCell.txtCaseDescription.addBorder(color: UIColor.black.cgColor, width: 1.0)
            descriptionCell.txtCaseDescription.text = caseGlobal.CaseDescriptionString
            descriptionCell.delegate = self
            return descriptionCell
        } else if indexPath.section == 5 {
            let optionCell: NewCaseOptionsCell = tableview.dequeueReusableCell(withIdentifier: "NewCaseOptionsCell", for: indexPath) as! NewCaseOptionsCell
            if indexPath.row == 0 {
                optionCell.lblOptionTitle.text = "Tips about this type of case"
                optionCell.imgIcon.image = UIImage(named:"safetyTube")
            } else if indexPath.row == 1 {
                optionCell.lblOptionTitle.text = "Important rules using this App to book a PI"
                optionCell.imgIcon.image = UIImage(named:"judgehammer")
            }
            return optionCell
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "toCaseTypeDetailsFromNewCase", sender: self)
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: "toJobLocationDetailsFromNewCase", sender: self)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "toPOIDetailsFromNewCase", sender: self)
            }
        } else if indexPath.section == 2 {
        } else if indexPath.section == 3 {
        } else if indexPath.section == 4 {
        } else if indexPath.section == 5 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "toTipsAboutCaseTypeFromNewCase", sender: self)
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: "toRulesAboutCaseTypeFromNewCase", sender: self)
            }
        }
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



extension NewCaseVC: CaseTypeSelectionDelegate {
    func caseSelected(caseTpe: CaseType, caseMinTime: Int, caseLength: CaseTime) {
        caseGlobal.selectedCaseType =  caseTpe
        caseGlobal.selectedCaseMinTime = caseMinTime
        caseGlobal.selectedCaseLength = caseLength
        let indexPath = IndexPath(row: 0, section: 0)
        tableview.reloadRows(at: [indexPath], with: .fade)
    }
}



extension NewCaseVC: POIDetailsSelectionDelegate {
    func POIDetailsSelected(poiName: String, poiType: String, poiGender: GenderPOI, poiAge: String, poiAgeRange: String, poiImages: [UIImage], poiIdentifyingTags: String, acceptedTermsAndConditions: Bool) {
        caseGlobal.selectedPOIName =  poiName
        caseGlobal.selectedPOIType = poiType
        caseGlobal.selectedGenderPOI = poiGender
        caseGlobal.selectedAge = poiAge
        caseGlobal.selectedAgeRange = poiAgeRange
        caseGlobal.selectedImagesOfPOI = poiImages
        caseGlobal.selectedIdentifyingTags = poiIdentifyingTags
        caseGlobal.acceptedTermsAndConditions = acceptedTermsAndConditions
        let indexPath = IndexPath(row: 0, section: 1)
        tableview.reloadRows(at: [indexPath], with: .fade)
    }
}



extension NewCaseVC : LocationDetailsSelectionDelegate {
    func LocationDetailsSelected(locName: String, locExtraAddress: String, locStreet: String, locCity: String, locState: String, locCountry: String, locZipcode: String, locLat: Double, locLng: Double) {
         caseGlobal.locationName = locName
         caseGlobal.extraAddress = locExtraAddress
         caseGlobal.street = locStreet
         caseGlobal.city = locCity
         caseGlobal.state = locState
         caseGlobal.country = locCountry
         caseGlobal.zipcode = locZipcode
         caseGlobal.caseLat = locLat
         caseGlobal.caseLng = locLng
        let indexPath = IndexPath(row: 1, section: 0)
        tableview.reloadRows(at: [indexPath], with: .fade)
    }
}



extension NewCaseVC: CaseDateAndTimeSelectionDelegate {
    func caseDateSelected(caseDate:Date) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy"
        caseGlobal.selectedCaseDate = dateformatter.string(from: caseDate)
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        caseGlobal.selectedCaseStartTime = timeformatter.string(from: caseDate)
        let indexPath = IndexPath(row: 0, section: 2)
        tableview.reloadRows(at: [indexPath], with: .fade)
    }
    
    func expandCell() {
        showDropDownInCaseDateAndTimeCell = true
        let indexPath = IndexPath(row: 0, section: 2)
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
        caseGlobal.selectedCaseExpectedOutcomes = selectedOutcomes
        let indexPath = IndexPath(row: 0, section: 2)
        tableview.reloadRows(at: [indexPath], with: .fade)
        
    }
}



extension NewCaseVC: RatingSelectionDelegate {
    func ratingSelected(piRating: Double) {
        caseGlobal.selectedPIRating = piRating
       // let indexPath = IndexPath(row: 0, section: 3)
       // tableview.reloadRows(at: [indexPath], with: .fade)
    }
}


extension NewCaseVC: TipsSelectionForCaseTypeDelagate {
    func selectedAllTips(selectedtipsIdsArray: [String]) {
        caseGlobal.selectedTipsIDs = selectedtipsIdsArray
    }
}

extension NewCaseVC: RulesSelectionForCaseTypeDelagate {
    func selectedAllRules(selectedrulesIdsArray: [String]) {
        caseGlobal.selectedRulesIDs = selectedrulesIdsArray
    }
}

extension NewCaseVC: CaseDescriptionTextDelegate {
    func caseDescriptionTextChanged(descriptionText: String) {
        caseGlobal.CaseDescriptionString = descriptionText
    }
}
