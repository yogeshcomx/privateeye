//
//  CaseDetailsPrivateEyeVC.swift
//  PrivateInvestigator
//
//  Created by apple on 7/31/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import UIDropDown
import Lightbox

class CaseDetailsPrivateEyeVC: UIViewController {
    @IBOutlet weak var lblCaseTypeHeading: UILabel!
    @IBOutlet weak var lblCaseTypeTitle: UILabel!
    @IBOutlet weak var lblCaseTypeDescription: UILabel!
    @IBOutlet weak var lblLocationHeading: UILabel!
    @IBOutlet weak var lblLocationTitle: UILabel!
    @IBOutlet weak var lblLocationDescription: UILabel!
    @IBOutlet weak var lblTargetHeading: UILabel!
    @IBOutlet weak var lblTargetTitle: UILabel!
    @IBOutlet weak var lblTargetIdentificationTags: UILabel!
    @IBOutlet weak var lblDateTimeHeading: UILabel!
    @IBOutlet weak var lblDateTimeValue: UILabel!
    @IBOutlet weak var lblTimeDescription: UILabel!
    @IBOutlet weak var btnRequestTime: UIButton!
    @IBOutlet weak var lblOutcomeHeading: UILabel!
    @IBOutlet weak var lblOutcomeListValue: UILabel!
    @IBOutlet weak var dropdownLiveStatusUpdate: UIDropDown!
    @IBOutlet weak var txtviewTestimoney: UITextView!
    @IBOutlet weak var btnUpdateCase: UIButton!
    @IBOutlet weak var viewCaseType: UIView!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var viewTarget: UIView!
    @IBOutlet weak var viewDateAndTime: UIView!
    @IBOutlet weak var viewOutcome: UIView!
    @IBOutlet weak var viewStatusUpdateOptions: UIView!
    @IBOutlet weak var imgMarker: UIImageView!
    @IBOutlet weak var lblSendToBooker: UILabel!
    @IBOutlet weak var viewTestimonyAndReport: UIView!
    @IBOutlet weak var btnAttachment: UIButton!
    @IBOutlet weak var tableviewAttachment: UITableView!
    @IBOutlet weak var btnSendFinalReport: UIButton!
    
    
    @IBOutlet weak var viewStatusOptionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableTestimonyHeightConstraint: NSLayoutConstraint!
   
    
    var CurrentCase:CaseDetails?
    var caseStatus:CaseStatusPrivateEye = .None
    var liveStatusOptionsFiltered:[CaseLiveStatus] = []
    var selectedLiveStatusOption:CaseLiveStatus?
    var timerCaseStartingTime: Timer?
    var attachmentsFinalReport: [Attachment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  setupUI()
        loadCaseLiveStatusOptions()
        setupDropDownLiveStatus()
         setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        setupTableview()
        loadUIBasedOnCaseStatus()
        loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        timerCaseStartingTime?.invalidate()
        timerCaseStartingTime = nil
    }
    
    @IBAction func clickBtnExtraTime(_ sender: Any) {
    }
    
    @IBAction func clickBtnTermsCheckbox(_ sender: Any) {
    }
    
    @IBAction func clickBtnAcceptCase(_ sender: Any) {
        let _ = showActivityIndicator()
        let caseID:String = CurrentCase?.id ?? ""
        let userID:String = UserDefaults.standard.string(forKey: userIdUserDefaults) ?? ""
        APIManager.sharedInstance.putAcceptCase(caseid: caseID, userid: userID, onSuccess: { status in
            self.hideActivityIndicator()
            if status {
                self.showAlert(title: "Success", message: "Case Accepted!!")
            } else {
                self.showAlert(title: "Error", message: "Case is already taken by other Private Eye")
            }
        }, onFailure: { error  in
            self.hideActivityIndicator()
            self.showAlert(title: "Error", message: "Case is already taken by other Private Eye")
        })
    }
    
    @IBAction func clickBtnShowlocationMap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "PrivateInvestigator", bundle: nil)
        let mapController:CaseLocationMapWithDirectionsVC = storyboard.instantiateViewController(withIdentifier: "MapWithDirection") as! CaseLocationMapWithDirectionsVC
        mapController.caselat = Double(CurrentCase?.case_latitude ?? "") ?? 0.0
        mapController.caselng = Double(CurrentCase?.case_longitude ?? "") ?? 0.0
        present(mapController, animated: true, completion: nil)
    }
    
    @IBAction func clickBtnUpdateCase(_ sender: Any) {
        if selectedLiveStatusOption == nil {
            showAlert(title: "Error", message: "Please select live status")
        } else {
            let _ = showActivityIndicator()
            let caseID:String = CurrentCase?.id ?? ""
            let userID:String = UserDefaults.standard.string(forKey: userIdUserDefaults) ?? ""
            APIManager.sharedInstance.putUpdateCaseLiveStatusFeed(caseid: caseID, userid: userID, liveStatus: selectedLiveStatusOption!, onSuccess: { status in
                self.hideActivityIndicator()
                if status {
                    self.showAlert(title: "Success", message: "Case Live Status Updated Successfully!!")
                } else {
                    self.showAlert(title: "Error", message: "Unable to update case Status. Try Again")
                }
            }, onFailure: { error  in
                self.hideActivityIndicator()
                self.showAlert(title: "Error", message: "Unable to update case Status. Try Again")
            })
        }
    }
    
    @IBAction func clickBtnSave(_ sender: Any) {
    }
    
    @IBAction func clickBtnShowPOIImages(_ sender: Any) {
        let images = [
            LightboxImage(
                image: UIImage(named: "icon167")!,
                text: "This is an example of a local image."
            ), LightboxImage(
                image: UIImage(named: "Camera_Icon")!,
                text: "This is an example of a local image."
            ), LightboxImage(
                image: UIImage(named: "icon167")!,
                text: "This is an example of a local image."
            )
        ]
        let controller = LightboxController(images: images)
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        controller.dynamicBackground = true
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func clickBtnAttachment(_ sender: Any) {
        AttachmentManager.shared.showAttachmentActionSheet(vc: self, displayViewForIpad: viewTestimonyAndReport)
        AttachmentManager.shared.imagePickedBlock = { (imagesAttachment) in
            for attachment in imagesAttachment {
            self.attachmentsFinalReport.append(attachment)
            }
            self.setupAttachmentTableview()
            self.tableviewAttachment.reloadData()
        }
        AttachmentManager.shared.videoPickedBlock = {(url) in
            self.attachmentsFinalReport.append(url)
            self.setupAttachmentTableview()
            self.tableviewAttachment.reloadData()
        }
        AttachmentManager.shared.filePickedBlock = {(filePath) in
            self.attachmentsFinalReport.append(filePath)
            self.setupAttachmentTableview()
            self.tableviewAttachment.reloadData()
        }
    }
    
    @IBAction func clickBtnFinalReport(_ sender: Any) {
    }
    
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        viewCaseType.layer.addBorder(edge: .bottom, color: UIColor.init(hexString: "FC0D1B"), thickness: 1.0)
        viewLocation.layer.addBorder(edge: .bottom, color: UIColor.init(hexString: "FC0D1B"), thickness: 1.0)
        viewTarget.layer.addBorder(edge: .bottom, color: UIColor.init(hexString: "FC0D1B"), thickness: 1.0)
        viewDateAndTime.layer.addBorder(edge: .bottom, color: UIColor.init(hexString: "FC0D1B"), thickness: 1.0)
        viewOutcome.layer.addBorder(edge: .bottom, color: UIColor.init(hexString: "FC0D1B"), thickness: 1.0)
        viewStatusUpdateOptions.layer.addBorder(edge: .bottom, color: UIColor.init(hexString: "FC0D1B"), thickness: 1.0)
//        lblCaseTypeHeading.layer.addBorder(edge: .bottom, color: UIColor.init(hexString: "FC0D1B"), thickness: 1.0)
//        lblLocationHeading.layer.addBorder(edge: .bottom, color: UIColor.init(hexString: "FC0D1B"), thickness: 1.0)
//        lblTargetHeading.layer.addBorder(edge: .bottom, color: UIColor.init(hexString: "FC0D1B"), thickness: 1.0)
//        lblDateTimeHeading.layer.addBorder(edge: .bottom, color: UIColor.init(hexString: "FC0D1B"), thickness: 1.0)
//        lblOutcomeHeading.layer.addBorder(edge: .bottom, color: UIColor.init(hexString: "FC0D1B"), thickness: 1.0)
        let markerImage = UIImage(named:"marker")?.imageWithColor(UIColor.black)
        imgMarker.image = markerImage
        imgMarker.tintColor = UIColor.black
        btnRequestTime.roundAllCorners(radius: 5.0)
        btnSendFinalReport.roundAllCorners(radius: 5.0)
        btnUpdateCase.roundAllCorners(radius: 5.0)
        txtviewTestimoney.roundAllCorners(radius: 5.0)
        txtviewTestimoney.addBorder(color: UIColor.black.cgColor, width: 1.5)
        txtviewTestimoney.delegate = self
    }
    
    
    func setupTableview() {
        tableviewAttachment.delegate = self
        tableviewAttachment.dataSource = self
    }
    
    func setupDropDownLiveStatus() {
        let liveStatusOptionsString:[String] = liveStatusOptionsFiltered.map{$0.liveStatusDescription}
        dropdownLiveStatusUpdate.extraWidth = 0.0
        dropdownLiveStatusUpdate.title.text = "Live Status Update"
        dropdownLiveStatusUpdate.borderWidth = 1.0
        dropdownLiveStatusUpdate.tableHeight = 155.0
        dropdownLiveStatusUpdate.extraWidth = 0.0
        dropdownLiveStatusUpdate.tableWillAppear {
            self.viewStatusUpdateOptions.bringSubview(toFront: self.dropdownLiveStatusUpdate)
        }
        dropdownLiveStatusUpdate.title.text = "Live Status Update"
        dropdownLiveStatusUpdate.textAlignment = .center
        dropdownLiveStatusUpdate.textColor = UIColor.black
        dropdownLiveStatusUpdate.placeholder = "Select Live Status Update"
        dropdownLiveStatusUpdate.options = liveStatusOptionsString
        dropdownLiveStatusUpdate.didSelect { (option, index) in
            self.dropdownLiveStatusUpdate.title.text = liveStatusOptionsString[index]
            self.selectedLiveStatusOption = self.liveStatusOptionsFiltered[index]
            let _ = self.dropdownLiveStatusUpdate.resign()
        }
        self.viewStatusUpdateOptions.addSubview(dropdownLiveStatusUpdate)
    }
    
    func loadUIBasedOnCaseStatus() {
//        let userid = UserDefaults.standard.string(forKey: userIdUserDefaults) ?? ""
//        if CurrentCase?.privateeye_Id == "" || CurrentCase?.privateeye_Id == nil {
//            caseStatus = .WaitingForAcceptance
//            viewAcceptCaseHeightConstraint.constant = 120
//            viewTermsAndAcceptOption.isHidden = false
//            dropdownLiveStatusUpdate.isHidden = true
//            txtviewTestimoney.isHidden = true
//            lblSendToBooker.isHidden = true
//            btnUpdateCase.isHidden = true
//            btnRequestTime.isHidden = true
//            self.view.layoutIfNeeded()
//
//
//
//        } else if CurrentCase?.privateeye_Id == userid {
//            caseStatus = .Accepted
//            viewAcceptCaseHeightConstraint.constant = 0
//            viewTermsAndAcceptOption.isHidden = true
//            dropdownLiveStatusUpdate.isHidden = false
//            txtviewTestimoney.isHidden = false
//            lblSendToBooker.isHidden = false
//            btnUpdateCase.isHidden = false
//            btnRequestTime.isHidden = false
//            self.view.layoutIfNeeded()
//
//        } else {
//            caseStatus = .Closed
//            self.view.layoutIfNeeded()
//        }
        
        if caseStatus == .Accepted {
            viewStatusOptionsHeightConstraint.constant = 200.0
            viewStatusUpdateOptions.isHidden = false
            dropdownLiveStatusUpdate.isHidden = false
            txtviewTestimoney.isHidden = false
            lblSendToBooker.isHidden = false
            btnUpdateCase.isHidden = false
            btnRequestTime.isHidden = false
            tableTestimonyHeightConstraint.constant = attachmentsFinalReport.count > 0 ? 150.0 : 0.0
            self.view.layoutIfNeeded()
        } else if caseStatus == .Closed {
            viewStatusOptionsHeightConstraint.constant = 0.0
            viewStatusUpdateOptions.isHidden = true
            dropdownLiveStatusUpdate.isHidden = true
            txtviewTestimoney.isHidden = true
            lblSendToBooker.isHidden = true
            btnUpdateCase.isHidden = true
            btnRequestTime.isHidden = true
            tableTestimonyHeightConstraint.constant = attachmentsFinalReport.count > 0 ? 150.0 : 0.0
            self.view.layoutIfNeeded()
        } else {
            viewStatusOptionsHeightConstraint.constant = 0.0
            viewStatusUpdateOptions.isHidden = true
            dropdownLiveStatusUpdate.isHidden = true
            txtviewTestimoney.isHidden = true
            lblSendToBooker.isHidden = true
            btnUpdateCase.isHidden = true
            btnRequestTime.isHidden = true
            tableTestimonyHeightConstraint.constant = attachmentsFinalReport.count > 0 ? 150.0 : 0.0
            self.view.layoutIfNeeded()
        }
        
    }
    
    func setupAttachmentTableview() {
        tableTestimonyHeightConstraint.constant = attachmentsFinalReport.count > 0 ? 150.0 : 0.0
        self.viewTestimonyAndReport.layoutIfNeeded()
    }
    
    func loadCaseLiveStatusOptions() {
        if caseLiveStatusFeedOptionsGlobal.count == 0 {
            self.liveStatusOptionsFiltered = caseLiveStatusFeedOptionsGlobal.filter{$0.statusType != "pre"}
        } else {
            APIManager.sharedInstance.getCaseLiveStatusOptionsList(onSuccess: { caseLiveStatusOptions in
                caseLiveStatusFeedOptionsGlobal = caseLiveStatusOptions
                self.liveStatusOptionsFiltered = caseLiveStatusFeedOptionsGlobal.filter{$0.statusType != "pre"}
                DispatchQueue.main.async {
                    self.setupDropDownLiveStatus()
                }
            }, onFailure: { error in
                print(error)
            })
        }
        
    }
    
    func loadData() {
        navigationController?.navigationBar.topItem?.title = "Case: \(CurrentCase?.id ?? "" )"
        lblCaseTypeTitle.text = CurrentCase?.case_type ?? ""
        lblCaseTypeDescription.text = CurrentCase?.job_description ?? ""
        lblLocationTitle.text = CurrentCase?.case_location_name ?? ""
        lblLocationDescription.text = CurrentCase?.case_location_address ?? ""
        lblTargetTitle.text = "\(CurrentCase?.person_of_interest ?? "") > \(CurrentCase?.poiAge ?? "Unknown") years > \(CurrentCase?.poiGender ?? "Unknown")"
        lblTargetIdentificationTags.text = CurrentCase?.target_identification ?? ""
        lblOutcomeListValue.text = CurrentCase?.outcome_required ?? ""
        dropdownLiveStatusUpdate.title.text = CurrentCase?.live_status_of_job ?? ""
        lblDateTimeValue.text = "\(CurrentCase?.case_date ?? "") \(CurrentCase?.case_start_time ?? "")"
        showStartingTime()
        timerCaseStartingTime = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.showStartingTime), userInfo: nil, repeats: true)
    }
    
    @objc func showStartingTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date1 = dateFormatter.date(from: lblDateTimeValue.text!)
        let now = Date()
        if now >= date1 ?? now {
            lblTimeDescription.text = "Case Started"
            timerCaseStartingTime = nil
            timerCaseStartingTime?.invalidate()
            return
        }
        let daysoffset = (date1 ?? now).days(from: now)
        let houroffset = (date1 ?? now).hours(from: now)
        let minuteoffset = (date1 ?? now).minutes(from: now)
        if daysoffset > 0 {
            let days = daysoffset
            let hours = houroffset - (daysoffset * 24)
            let minutes = minuteoffset - (daysoffset * 1440) - (hours * 60)
            if days > 1 {
                let timeString = "\(days) days \(hours) hour \(minutes) minutes"
                lblTimeDescription.text = "Case Starts in \(timeString)"
            } else {
                let timeString = "\(days) day \(hours) hour \(minutes) minutes"
                lblTimeDescription.text = "Case Starts in \(timeString)"
            }
        } else if houroffset > 0 {
            let hours = houroffset
            let minutes = minuteoffset  - (hours * 60)
            let timeString = "\(hours) hour \(minutes) minutes"
            lblTimeDescription.text = "Case Starts in \(timeString)"
        } else if minuteoffset  > 0 {
            let timeString = "\(minuteoffset) minutes"
            lblTimeDescription.text = "Case Starts in \(timeString)"
        } else {
            lblTimeDescription.text = "Case Started"
            timerCaseStartingTime = nil
            timerCaseStartingTime?.invalidate()
        }
    }
}


extension CaseDetailsPrivateEyeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.attachmentsFinalReport.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FileAttachmentCell = tableviewAttachment.dequeueReusableCell(withIdentifier: "FileAttachmentCell", for: indexPath) as! FileAttachmentCell
        cell.lblTitle.text = self.attachmentsFinalReport[indexPath.row].name
        cell.delegate = self
        return cell
    }
}

extension CaseDetailsPrivateEyeVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Testimoney (only facts)" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Testimoney (only facts)"
        }
    }
}

extension CaseDetailsPrivateEyeVC : FileAttachmentCellDelegate {
    func removeAttachment(selectedCell: FileAttachmentCell) {
        let indexPath:IndexPath = tableviewAttachment.indexPath(for: selectedCell)!
        if attachmentsFinalReport.count > indexPath.row {
            self.attachmentsFinalReport.remove(at: indexPath.row)
            tableviewAttachment.reloadData()
        }
        setupAttachmentTableview()
    }
}

extension CaseDetailsPrivateEyeVC: LightboxControllerPageDelegate {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
}

extension CaseDetailsPrivateEyeVC: LightboxControllerDismissalDelegate {
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        // ...
    }
}
