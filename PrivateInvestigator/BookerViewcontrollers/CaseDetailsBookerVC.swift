//
//  CaseDetailsBookerVC.swift
//  PrivateInvestigator
//
//  Created by apple on 7/23/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class CaseDetailsBookerVC: UIViewController {

    
    @IBOutlet weak var lblLiveStatus: UILabel!
    @IBOutlet weak var lblCaseDetails: UILabel!
    @IBOutlet weak var lblPOIDetails: UILabel!
    @IBOutlet weak var lblCaseLocName: UILabel!
    @IBOutlet weak var lblCaseLocAddress: UILabel!
    @IBOutlet weak var lblCaseDateTime: UILabel!
    @IBOutlet weak var lblRemainingTime: UILabel!
    @IBOutlet weak var btnExtendTime: UIButton!
    @IBOutlet weak var btnCancelJob: UIButton!
    @IBOutlet weak var viewExtendJobTime: UIView!
    
    @IBOutlet weak var imgLiveIcon: UIImageView!
    
    @IBOutlet weak var imgCaseIcon: UIImageView!
    
    @IBOutlet weak var imgPoiIcon: UIImageView!
    
    @IBOutlet weak var imgLocationIcon: UIImageView!
    
    @IBOutlet weak var imgTimeIcon: UIImageView!
    
    @IBOutlet weak var viewCaseBasicDetails: UIView!
    
    var CurrentCase:CaseDetails?
    var timerRemainingTime: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timerRemainingTime?.invalidate()
        timerRemainingTime = nil
    }
    
    @IBAction func clickBtnExtendTime(_ sender: Any) {
    }
    
    @IBAction func clickBtnCancelJob(_ sender: Any) {
    }
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        btnExtendTime.roundAllCorners(radius: 5.0)
        btnCancelJob.roundAllCorners(radius: 5.0)
        viewCaseBasicDetails.layer.addBorder(edge: .bottom, color: UIColor.init(hexString: "FC0D1B"), thickness: 1.0)
//        let youtubeimg = UIImage(named:"youtube")?.imageWithColor(UIColor.white)
//        imgLiveIcon.image = youtubeimg
//        imgLiveIcon.tintColor = UIColor.white
//        let briefcaseimg = UIImage(named:"briefcase")?.imageWithColor(UIColor.white)
//        imgCaseIcon.image = briefcaseimg
//        imgCaseIcon.tintColor = UIColor.white
//        let imgPoi = UIImage(named:"location")?.imageWithColor(UIColor.white)
//        imgPoiIcon.image = imgPoi
//        imgPoiIcon.tintColor = UIColor.white
        let markerImage = UIImage(named:"marker")?.imageWithColor(UIColor.black)
        imgLocationIcon.image = markerImage
        imgLocationIcon.tintColor = UIColor.black
//        let imgTimer = UIImage(named:"timer")?.imageWithColor(UIColor.white)
//        imgTimeIcon.image = imgTimer
//        imgTimeIcon.tintColor = UIColor.white
        
        
    }
    
    func loadData() {
        navigationController?.navigationBar.topItem?.title = "Case: \(CurrentCase?.id ?? "")"
        lblLiveStatus.text = CurrentCase?.live_status_of_job ?? "Looking for Private Eye"
        lblCaseDetails.text = CurrentCase?.case_type ?? ""
        lblPOIDetails.text = "\(CurrentCase?.person_of_interest  ?? "") > \(CurrentCase?.poiGender ?? "") > \(CurrentCase?.poiAge ?? "") years "
        lblCaseLocName.text = CurrentCase?.case_location_name
        lblCaseLocAddress.text = CurrentCase?.case_location_address
        lblCaseDateTime.text = "\(CurrentCase?.case_date ?? "") \(CurrentCase?.case_start_time ?? "")"
        showRemainigTime()
        timerRemainingTime = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.showRemainigTime), userInfo: nil, repeats: true)
    }
    
    @objc func showRemainigTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date1 = dateFormatter.date(from: lblCaseDateTime.text!)
        let now = Date()
        let daysoffset = date1?.days(from: now)
        let houroffset = date1?.hours(from: now)
        let minuteoffset = date1?.minutes(from: now)
        if (daysoffset ?? 0) > 0 {
            let days = daysoffset!
            let hours = (houroffset ?? 0)-(daysoffset! * 24)
            let minutes = (minuteoffset ?? 0) - (daysoffset! * 1440) - (hours * 60)
            if days > 1 {
                
            }
            let timeString = "\(days) days \(hours) hour \(minutes) minutes"
            lblRemainingTime.text = timeString
        } else if (houroffset ?? 0) > 0 {
            let hours = houroffset ?? 0
            let minutes = (minuteoffset ?? 0) - (hours * 60)
            let timeString = "\(hours) hour \(minutes) minutes"
            lblRemainingTime.text = timeString
        } else if (minuteoffset ?? 0) > 0 {
            let timeString = "\(minuteoffset ?? 0) minutes"
            lblRemainingTime.text = timeString
        } else {
            lblRemainingTime.text = "Expired"
        }
    }

}
