//
//  TipsAboutCaseTypeVCViewController.swift
//  PrivateInvestigator
//
//  Created by apple on 7/19/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

protocol TipsSelectionForCaseTypeDelagate: class {
    func selectedAllTips(selectedtipsIdsArray:[String])
}


class TipsAboutCaseTypeVCViewController: UIViewController {
   
    @IBOutlet weak var tableview: UITableView!
    
    
    var TipsList:[TipsForCaseType] = []
    var selectedTipsIds:[String] = []
    var delegate:TipsSelectionForCaseTypeDelagate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableview()
        getTipsList()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }

    @IBAction func clickBtnDone(_ sender: Any) {
        var isValid:Bool = true
       for tip in TipsList {
        if tip.selected == false {
            isValid = false
        }
        }
        if isValid {
            selectedTipsIds = []
            selectedTipsIds = TipsList.map{$0.tipId
            }
            delegate?.selectedAllTips(selectedtipsIdsArray: selectedTipsIds)
            //navigationController?.popViewController(animated: true)
            NewCaseVC.caseGlobal.selectedTipsIDs = selectedTipsIds
            performSegue(withIdentifier: "toRulesDetailsFromTipsDetails", sender: self)
        } else {
            showAlert(title: "Error", message: "Please select all the tips")
        }
    }
    
    
    func setupUI() {
    }
    
    func setupTableview() {
        tableview.register(UINib(nibName: "TipsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TipsTableViewCell")
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableview.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func loadData() {
        selectedTipsIds = NewCaseVC.caseGlobal.selectedTipsIDs
        
        if selectedTipsIds.count > 0 {
            for (index,value) in self.TipsList.enumerated() {
                if selectedTipsIds.contains(value.tipId) {
                    self.TipsList[index].selected  = true
                }
            }
            tableview.reloadData()
        }
    }

    func getTipsList() {
        let _ = showActivityIndicator()
        if tipsListGlobal.count > 0 {
            self.TipsList = tipsListGlobal
            tableview.reloadData()
            hideActivityIndicator()
        } else {
            APIManager.sharedInstance.getTipsListList(onSuccess: { tips in
                tipsListGlobal = tips
                self.TipsList = tips
                self.tableview.reloadData()
                self.hideActivityIndicator()
            }, onFailure: { error in
                print(error)
                self.hideActivityIndicator()
            })
        }
    }

}

extension TipsAboutCaseTypeVCViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableview.estimatedRowHeight = 55.0
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TipsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TipsTableViewCell = tableview.dequeueReusableCell(withIdentifier: "TipsTableViewCell", for: indexPath) as! TipsTableViewCell
        cell.lblDescription.text = "\(indexPath.row + 1). \(TipsList[indexPath.row].tipDescription)"
        if TipsList[indexPath.row].selected == true {
            cell.btnSelectCheckbox.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            cell.btnSelectCheckbox.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        cell.delegateTips = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:TipsTableViewCell = tableview.cellForRow(at: indexPath) as! TipsTableViewCell
        if TipsList[indexPath.row].selected == true {
            TipsList[indexPath.row].selected = false
            cell.btnSelectCheckbox.setImage(UIImage(named: "unchecked"), for: .normal)
        } else {
            TipsList[indexPath.row].selected = true
            cell.btnSelectCheckbox.setImage(UIImage(named: "checked"), for: .normal)
        }
        
    }
}

extension TipsAboutCaseTypeVCViewController : TipsSelectionDelegate {
    func tipSelected(selectedCell: TipsTableViewCell) {
        let indexPath:IndexPath = tableview.indexPath(for: selectedCell)!
        if TipsList[indexPath.row].selected == true {
            TipsList[indexPath.row].selected = false
            selectedCell.btnSelectCheckbox.setImage(UIImage(named: "unchecked"), for: .normal)
        } else {
            TipsList[indexPath.row].selected = true
            selectedCell.btnSelectCheckbox.setImage(UIImage(named: "checked"), for: .normal)
        }
    }
}
