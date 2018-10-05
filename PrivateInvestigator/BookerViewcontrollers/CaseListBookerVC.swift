//
//  CaseListBookerVC.swift
//  PrivateInvestigator
//
//  Created by apple on 7/23/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class CaseListBookerVC: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var caseListOfBooker:[CaseDetails] = []
    var selectedIndex:Int = 0
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableview()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCaseListOfBookerFromServer()
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
    
    func getCaseListOfBookerFromServer() {
        showActivityIndicator()
        APIManager.sharedInstance.postGettingCaseListOfBooker(onSuccess: { caselist in
            self.caseListOfBooker = caselist
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
        getCaseListOfBookerFromServer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCaseDetailsFromCaseListBooker" {
            let destVC:CaseDetailsBookerVC = segue.destination as! CaseDetailsBookerVC
            destVC.CurrentCase = caseListOfBooker[selectedIndex]
        }
    }

}


extension CaseListBookerVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return caseListOfBooker.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CaseListBookerCell = tableview.dequeueReusableCell(withIdentifier: "CaseListBookerCell", for: indexPath) as! CaseListBookerCell
        cell.lblPOIName.text = caseListOfBooker[indexPath.row].person_of_interest
        cell.lblPOIType.text = caseListOfBooker[indexPath.row].case_type
        cell.lblPOIAddress.text = caseListOfBooker[indexPath.row].case_location_address
        cell.lblCaseDateTime.text = "\(caseListOfBooker[indexPath.row].case_date) \(caseListOfBooker[indexPath.row].case_start_time)"
        cell.lblStatus.text = caseListOfBooker[indexPath.row].live_status_of_job
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "toCaseDetailsFromCaseListBooker", sender: self)
    }
    
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if (editingStyle == UITableViewCellEditingStyle.delete) {
                showAlert(title: "Warning", message: "Its just Demo, Will update soon")
            }
        }
    
    
}
