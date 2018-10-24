//
//  POIDetailsVC.swift
//  PrivateInvestigator
//
//  Created by apple on 7/14/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import DKImagePickerController
import UIDropDown
import KSTokenView
import IQKeyboardManagerSwift

protocol POIDetailsSelectionDelegate: class {
    func POIDetailsSelected(poiName:String, poiType:String, poiGender: GenderPOI, poiAge:String, poiAgeRange:String, poiImages:[UIImage], poiIdentifyingTags:String,acceptedTermsAndConditions:Bool)
}


class POIDetailsVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var txtPOIName: UITextField!
    @IBOutlet weak var dropdownPOIType: UIDropDown!
    @IBOutlet weak var lblGenderTitle: UILabel!
    @IBOutlet weak var lblMaleTitle: UILabel!
    @IBOutlet weak var lblGroupTitle: UILabel!
    @IBOutlet weak var lblFemaleTitle: UILabel!
    @IBOutlet weak var lblGenderBottomBorder: UILabel!
    @IBOutlet weak var btnMaleCheckbox: UIButton!
    @IBOutlet weak var btnFemaleCheckbox: UIButton!
    @IBOutlet weak var btnGroupCheckbox: UIButton!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var dropdownAgeRange: UIDropDown!
    @IBOutlet weak var collectionviewPOIImages: UICollectionView!
    @IBOutlet weak var viewPOIProfieDetails: UIView!
    @IBOutlet weak var identifyingTags: KSTokenView!
    @IBOutlet weak var btnTermsAndConditionCheckbox: UIButton!
    
    
    @IBOutlet weak var constraintBtnMaleCheckboxTopToDropDownPOI: NSLayoutConstraint!
    
    var selectedImagesOfPOI: [UIImage] = []
    var selectedPOIName: String?
    var selectedPOIType: String?
    var selectedAge: String?
    var selectedAgeRange: String?
    var selectedGenderPOI: GenderPOI = .None
    var acceptedTermsAndConditions: Bool = false
    var selectedIdentifyingTags:String?
    var delegate:POIDetailsSelectionDelegate?
    
    fileprivate var hashtagSearchMap: [String : Int64] = [:]
    fileprivate let tableCellFont = UIFont(name: "AvenirNext-Medium", size: 14)!
    private let textColor = UIColor.init(red: 106/255.0, green: 118/255.0, blue: 130/255.0, alpha: 1.0)
    var tokensIdentifyingTags:[String] =  []//["suit", "beard" , "tall" , "short", "black", "white" , "longhair", "shorthair", "moustache", "blackshoe", "tie"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDropdownPOITypes()
        setupDropdownAgeRange()
        setupIdentifyingTagsField()
        loadData()
        getTagsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 220
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10
    }
    
    @IBAction func clickBtnMaleCheckbox(_ sender: Any) {
        selectMaleOption()
    }
    @IBAction func clickBtnFemaleCheckbox(_ sender: Any) {
        selectFemaleOption()
    }
    @IBAction func clickBtnGroupCheckbox(_ sender: Any) {
        selectGroupOption()
    }
    @IBAction func clickBtnTermsAndConditionCheckbox(_ sender: Any) {
        selectTermsAndConditions()
    }
    
    @IBAction func clickBtnDone(_ sender: Any) {
        selectedIdentifyingTags = ""
        let tokens = identifyingTags.tokens()
        for (index, value) in (tokens?.enumerated())! {
            if index == 0 {
                selectedIdentifyingTags = selectedIdentifyingTags! + value.title
            } else {
                selectedIdentifyingTags = selectedIdentifyingTags! + ",\(value.title)"
            }
        }

        if txtPOIName.text! == "" {
            showAlert(title: "Error", message: "Please enter POI name")
        } else if selectedPOIType == nil {
            showAlert(title: "Error", message: "Please select POI type")
        } else if selectedGenderPOI == .None {
            showAlert(title: "Error", message: "Please select POI gender")
        } else if txtAge.text! == "" && selectedAgeRange == nil {
            showAlert(title: "Error", message: "Please enter POI age or select age range")
        } else if selectedImagesOfPOI.count == 0 {
            showAlert(title: "Error", message: "Please upload POI Images")
        } else if selectedIdentifyingTags == nil || identifyingTags.text == "" {
            showAlert(title: "Error", message: "Please enter POI identifying tags")
        } else if acceptedTermsAndConditions == false {
            showAlert(title: "Error", message: "Please accept terms and conditions")
        } else {
            delegate?.POIDetailsSelected(poiName: txtPOIName.text!, poiType: selectedPOIType!, poiGender: selectedGenderPOI, poiAge: txtAge.text!, poiAgeRange: selectedAgeRange ?? "", poiImages: selectedImagesOfPOI, poiIdentifyingTags: selectedIdentifyingTags!, acceptedTermsAndConditions: acceptedTermsAndConditions)
            //navigationController?.popViewController(animated: true)
            NewCaseVC.caseGlobal.selectedPOIName = txtPOIName.text!
            NewCaseVC.caseGlobal.selectedPOIType = selectedPOIType!
            NewCaseVC.caseGlobal.selectedGenderPOI = selectedGenderPOI
            NewCaseVC.caseGlobal.selectedAge = txtAge.text!
            NewCaseVC.caseGlobal.selectedAgeRange = selectedAgeRange ?? ""
            NewCaseVC.caseGlobal.selectedImagesOfPOI = selectedImagesOfPOI
            NewCaseVC.caseGlobal.selectedIdentifyingTags = selectedIdentifyingTags!
            NewCaseVC.caseGlobal.acceptedTermsAndConditions = acceptedTermsAndConditions
            performSegue(withIdentifier: "toJobLocationDetailsFromPOIDetails", sender: self)
        }
        
    }
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        txtPOIName.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtAge.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtPOIName.delegate = self
        txtAge.delegate = self
        dropdownPOIType.borderColor = UIColor.black
        dropdownAgeRange.borderColor = UIColor.black
        dropdownPOIType.title.text = "Select POI type"
        dropdownAgeRange.title.text = "Select Age range"
        collectionviewPOIImages.addBorder(color: UIColor.black.cgColor, width: 1.0)
        collectionviewPOIImages.roundAllCorners(radius: 2.0)
        identifyingTags.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        identifyingTags.delegate = self
        identifyingTags.promptText = "Top 5: "
        identifyingTags.placeholder = "Type to search"
        identifyingTags.descriptionText = "Languages"
        identifyingTags.maxTokenLimit = 15 //default is -1 for unlimited number of tokens
        identifyingTags.style = .squared
        
        identifyingTags.font = UIFont(name: "AvenirNext-Medium", size: 13)!
        identifyingTags.promptText = ""
        identifyingTags.placeholder = "Begin typing for hastag suggestions"
        identifyingTags.placeholderColor = textColor
        identifyingTags.descriptionText = ""
        identifyingTags.maxTokenLimit = 15
        identifyingTags.minimumCharactersToSearch = 1
        identifyingTags.activityIndicatorColor = UIColor.init(red: 25/255.0, green: 137/255.0, blue: 171/255.0, alpha: 1.0)
        identifyingTags.removesTokensOnEndEditing = false
        identifyingTags.searchResultBackgroundColor = textColor
        identifyingTags.tokenizingCharacters = [",", ".", " "]
        identifyingTags.direction = .vertical
        identifyingTags.delegate = self
        collectionviewPOIImages.dataSource = self
        collectionviewPOIImages.delegate = self
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(self.handleImageViewTap))
        tapImage.delegate = self
        collectionviewPOIImages.addGestureRecognizer(tapImage)
    }
    
    func setupDropdownPOITypes() {
        dropdownPOIType.borderWidth = 1.0
        dropdownPOIType.tableHeight = 200.0
        dropdownPOIType.extraWidth = 0.0
        dropdownPOIType.tableWillAppear {
            self.view.endEditing(true)
            self.viewPOIProfieDetails.bringSubview(toFront: self.dropdownPOIType)
            self.viewPOIProfieDetails.sendSubview(toBack: self.dropdownAgeRange)
        }
        dropdownPOIType.title.text = "Select POI type"
        dropdownPOIType.textAlignment = .center
        dropdownPOIType.textColor = UIColor.black
        dropdownPOIType.placeholder = "Select POI type"
        dropdownPOIType.options = POITypesListGlobal
        dropdownPOIType.didSelect { (option, index) in
            self.selectedPOIType = POITypesListGlobal[index]
            self.dropdownPOIType.title.text = POITypesListGlobal[index]
            if self.selectedPOIType?.lowercased().range(of:"male") != nil {
                self.selectMaleOption()
                self.ShowHideGenderOptions(show: false)
            }
            else if self.selectedPOIType?.lowercased().range(of:"female") != nil {
                self.selectFemaleOption()
                self.ShowHideGenderOptions(show: false)
            }
            else if self.selectedPOIType?.lowercased().range(of:"group") != nil {
                self.selectGroupOption()
                self.ShowHideGenderOptions(show: false)
            } else {
                self.ShowHideGenderOptions(show: true)
            }
            let _ = self.dropdownPOIType.resign()
        }
        self.viewPOIProfieDetails.addSubview(dropdownPOIType)
    }
    
    func setupDropdownAgeRange() {
        dropdownAgeRange.borderWidth = 1.0
        dropdownAgeRange.tableHeight = 160.0
        dropdownAgeRange.extraWidth = 0.0
        dropdownAgeRange.tableWillAppear {
            self.view.endEditing(true)
            self.viewPOIProfieDetails.bringSubview(toFront: self.dropdownAgeRange)
            self.viewPOIProfieDetails.sendSubview(toBack: self.dropdownPOIType)
        }
        dropdownAgeRange.title.text = "Select age range"
        dropdownAgeRange.textAlignment = .center
        dropdownAgeRange.textColor = UIColor.black
        dropdownAgeRange.placeholder = "Select age range"
        dropdownAgeRange.options = ageRangeListGlobal
        dropdownAgeRange.didSelect { (option, index) in
            self.selectedAgeRange = ageRangeListGlobal[index]
            self.dropdownAgeRange.title.text = ageRangeListGlobal[index]
            let _ = self.dropdownAgeRange.resign()
        }
        self.viewPOIProfieDetails.addSubview(dropdownAgeRange)
    }
    
    func setupIdentifyingTagsField() {
        identifyingTags.delegate = self
        identifyingTags.promptText = ""
        identifyingTags.placeholder = "Type to search"
        identifyingTags.descriptionText = "Languages"
        identifyingTags.maxTokenLimit = 15
        identifyingTags.style = .squared
    }
    
    func loadData() {
        selectedPOIName = NewCaseVC.caseGlobal.selectedPOIName
        selectedPOIType = NewCaseVC.caseGlobal.selectedPOIType
        selectedAge = NewCaseVC.caseGlobal.selectedAge
        selectedAgeRange = NewCaseVC.caseGlobal.selectedAgeRange
        selectedGenderPOI = NewCaseVC.caseGlobal.selectedGenderPOI
        selectedImagesOfPOI = NewCaseVC.caseGlobal.selectedImagesOfPOI
        selectedIdentifyingTags = NewCaseVC.caseGlobal.selectedIdentifyingTags
        acceptedTermsAndConditions = NewCaseVC.caseGlobal.acceptedTermsAndConditions
        
        if selectedPOIName != nil {
            txtPOIName.text = selectedPOIName!
            dropdownPOIType.title.text = selectedPOIType ?? "Select POI type"
            switch selectedGenderPOI {
            case .Male: selectMaleOption()
            case .Female: selectFemaleOption()
            case .Group: selectGroupOption()
            case .None: print("none")
            }
            txtAge.text = selectedAge ?? ""
            dropdownAgeRange.title.text = selectedAgeRange ?? "Select age range"
          //  identifyingTags.text = selectedIdentifyingTags ?? ""
            acceptedTermsAndConditions = !acceptedTermsAndConditions
            selectTermsAndConditions()
            let stringTag:String = selectedIdentifyingTags ?? ""
            let identifyingTagsArray = stringTag.components(separatedBy: ",")
            for identity in identifyingTagsArray {
                identifyingTags.addToken(KSToken(title: identity))
            }
        }
    }
    
    func selectMaleOption() {
        self.view.endEditing(true)
        selectedGenderPOI = .Male
        btnMaleCheckbox.setImage(UIImage(named:"checked"), for: UIControlState.normal)
        btnFemaleCheckbox.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
        btnGroupCheckbox.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
    }
    
    func selectFemaleOption() {
        self.view.endEditing(true)
        selectedGenderPOI = .Female
        btnMaleCheckbox.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
        btnFemaleCheckbox.setImage(UIImage(named:"checked"), for: UIControlState.normal)
        btnGroupCheckbox.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
    }
    
    func selectGroupOption() {
        self.view.endEditing(true)
        selectedGenderPOI = .Group
        btnMaleCheckbox.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
        btnFemaleCheckbox.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
        btnGroupCheckbox.setImage(UIImage(named:"checked"), for: UIControlState.normal)
    }
    
    func ShowHideGenderOptions(show:Bool) {
        if show {
            lblGenderTitle.isHidden = false
            btnMaleCheckbox.isHidden = false
            lblMaleTitle.isHidden = false
            btnFemaleCheckbox.isHidden = false
            lblFemaleTitle.isHidden = false
            btnGroupCheckbox.isHidden = false
            lblGroupTitle.isHidden = false
            lblGenderBottomBorder.isHidden = false
            constraintBtnMaleCheckboxTopToDropDownPOI.constant = 50.0
        } else {
            lblGenderTitle.isHidden = true
            btnMaleCheckbox.isHidden = true
            lblMaleTitle.isHidden = true
            btnFemaleCheckbox.isHidden = true
            lblFemaleTitle.isHidden = true
            btnGroupCheckbox.isHidden = true
            lblGroupTitle.isHidden = true
            lblGenderBottomBorder.isHidden = true
            constraintBtnMaleCheckboxTopToDropDownPOI.constant = -25.0
            
        }
    }
    
    func selectTermsAndConditions() {
        self.view.endEditing(true)
        if acceptedTermsAndConditions {
            acceptedTermsAndConditions = false
            btnTermsAndConditionCheckbox.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
        } else {
            acceptedTermsAndConditions = true
            btnTermsAndConditionCheckbox.setImage(UIImage(named:"checked"), for: UIControlState.normal)
        }
    }
    
    func loadImagePickerViewController() {
        self.view.endEditing(true)
        let pickerController = DKImagePickerController()
        pickerController.assetType = .allPhotos
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            if assets.count > 0 {
                self.selectedImagesOfPOI = []
                for asset:DKAsset in assets {
                    asset.fetchOriginalImage(true, completeBlock: {img,arg2  in
                        self.selectedImagesOfPOI.append(img!)
                    })
                }
                self.collectionviewPOIImages.reloadData()
            }
        }
        self.present(pickerController, animated: true) {}
    }
    
    @objc func handleImageViewTap() {
        loadImagePickerViewController()
    }
    
    
    func getTagsList() {
        let _ = showActivityIndicator()
        APIManager.sharedInstance.getTagsList(onSuccess: { tags in
            self.tokensIdentifyingTags = tags
            self.hideActivityIndicator()
        }, onFailure: { error in
            print(error)
            self.hideActivityIndicator()
        })
    }
    
}

extension POIDetailsVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
       IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 220
    }
}

extension POIDetailsVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedImagesOfPOI.count == 0 {
            return 1
        } else {
            return selectedImagesOfPOI.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageViewCollectionCell = collectionviewPOIImages.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageViewCollectionCell
        if selectedImagesOfPOI.count != 0 {
            cell.imgPOI.image = selectedImagesOfPOI[indexPath.row]
        } else {
            cell.imgPOI.image = UIImage(named:"defaultProfile")
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionviewPOIImages.frame.width, height: collectionviewPOIImages.frame.height)
    }
    
}

extension POIDetailsVC : KSTokenViewDelegate {
    func tokenView(_ tokenView: KSTokenView, performSearchWithString string: String, completion: ((Array<AnyObject>) -> Void)?) {
        if (string.isEmpty){
            completion!(tokensIdentifyingTags as Array<AnyObject>)
            return
        }
        let filtered = tokensIdentifyingTags.filter { $0.localizedCaseInsensitiveContains(string)}
        if filtered.count == 0 {
            completion!(tokensIdentifyingTags as Array<AnyObject>)
            return
        }
        completion!(filtered as Array<AnyObject>)
    }
    
    
    func tokenView(_ tokenView: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return "\(object)"
    }
    
    func tokenView(_ tokenView: KSTokenView, willAddToken token: KSToken) {
        token.title = "\(token.title.replacingOccurrences(of: "#", with: ""))".uppercased()
        
        token.tokenBackgroundColor = UIColor.init(red: 0/255.0, green: 132/255.0, blue: 233/255.0, alpha: 1.0)
    }
    
    func tokenView(_ tokenView: KSTokenView, withObject object: AnyObject, tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "KSSearchTableCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as UITableViewCell?
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        }
        
        cell?.textLabel?.font = tableCellFont
        cell?.textLabel?.textColor = UIColor.white
        cell?.backgroundColor = tokenView.searchResultBackgroundColor
        cell?.textLabel?.text = "\(object)"   //" (\(hashtagSearchMap[object as! String] ?? 0))"
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
