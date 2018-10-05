//
//  CaseListPrivateEyeVC.swift
//  PrivateInvestigator
//
//  Created by apple on 7/31/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class CaseListPrivateEyeVC: UIViewController {

    
    
    @IBOutlet weak var segmentCaseCategories: UISegmentedControl!
    @IBOutlet weak var tableview: UITableView!
    
    var caseListOfPrivateEye:[CaseDetails] = []
    var selectedIndex:Int = 0
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableview()
       // getCaseListOfPrivateEyeFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCaseListOfPrivateEyeFromServer()
    }

    @IBAction func clickSegmentCaseCategories(_ sender: Any) {
    }
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
    }
    
    func setupTableview() {
        tableview.register(UINib(nibName: "CaseListBookerCell", bundle: Bundle.main), forCellReuseIdentifier: "CaseListBookerCell")
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableview.tableFooterView = UIView(frame: CGRect.zero)
        tableview.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        
    }
    
    func getCaseListOfPrivateEyeFromServer() {
        showActivityIndicator()
        APIManager.sharedInstance.postGettingCaseListOfPrivateEye(onSuccess: { caselist in
            self.caseListOfPrivateEye = caselist
            self.tableview.reloadData()
            self.hideActivityIndicator()
            self.refreshControl.endRefreshing()
        }, onFailure: { error in
            print(error)
            self.hideActivityIndicator()
            self.refreshControl.endRefreshing()
        })
        
    }
    
    @objc func refreshTableData() {
        getCaseListOfPrivateEyeFromServer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCaseDetailsPIFromCaseListPI" {
            let destVC:CaseDetailsPrivateEyeVC = segue.destination as! CaseDetailsPrivateEyeVC
            destVC.CurrentCase = caseListOfPrivateEye[selectedIndex]
            destVC.caseStatus = .Accepted
        }
    }

}

extension CaseListPrivateEyeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return caseListOfPrivateEye.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CaseListBookerCell = tableview.dequeueReusableCell(withIdentifier: "CaseListBookerCell", for: indexPath) as! CaseListBookerCell
        cell.lblPOIName.text = caseListOfPrivateEye[indexPath.row].person_of_interest
        cell.lblPOIType.text = caseListOfPrivateEye[indexPath.row].case_type
        cell.lblPOIAddress.text = caseListOfPrivateEye[indexPath.row].case_location_address
        cell.lblCaseDateTime.text = "\(caseListOfPrivateEye[indexPath.row].case_date) \(caseListOfPrivateEye[indexPath.row].case_start_time)"
        cell.lblStatus.text = caseListOfPrivateEye[indexPath.row].live_status_of_job
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "toCaseDetailsPIFromCaseListPI", sender: self)
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//        }
//    }
    
    
}
