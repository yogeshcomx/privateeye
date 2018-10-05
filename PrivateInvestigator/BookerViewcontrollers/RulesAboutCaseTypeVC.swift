//
//  RulesAboutCaseTypeVC.swift
//  PrivateInvestigator
//
//  Created by apple on 8/3/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

protocol RulesSelectionForCaseTypeDelagate: class {
    func selectedAllRules(selectedrulesIdsArray:[String])
}


class RulesAboutCaseTypeVC: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    
    var RulesList:[RulesForCaseType] = []
    var selectedRulesIds:[String] = []
    var delegate:RulesSelectionForCaseTypeDelagate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableview()
        getRulesList()
        loadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    
    
    @IBAction func clickBtnDone(_ sender: Any) {
        var isValid:Bool = true
        for rule in RulesList {
            if rule.selected == false {
                isValid = false
            }
        }
        if isValid {
            selectedRulesIds = []
            selectedRulesIds = RulesList.map{$0.ruleId
            }
            delegate?.selectedAllRules(selectedrulesIdsArray: selectedRulesIds)
            //navigationController?.popViewController(animated: true)
            NewCaseVC.caseGlobal.selectedRulesIDs = selectedRulesIds
            navigationController?.popToRootViewController(animated: true)
        } else {
            showAlert(title: "Error", message: "Please select all the rules")
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
        selectedRulesIds = NewCaseVC.caseGlobal.selectedRulesIDs
        if selectedRulesIds.count > 0 {
            for (index,value) in self.RulesList.enumerated() {
                if selectedRulesIds.contains(value.ruleId) {
                    self.RulesList[index].selected  = true
                }
            }
            tableview.reloadData()
        }
    }
    
    func getRulesList() {
        let _ = showActivityIndicator()
        if rulesListGlobal.count > 0 {
            self.RulesList = rulesListGlobal
            tableview.reloadData()
            hideActivityIndicator()
        } else {
            APIManager.sharedInstance.getRulesList(onSuccess: { rules in
                rulesListGlobal = rules
                self.RulesList = rules
                self.tableview.reloadData()
                self.hideActivityIndicator()
            }, onFailure: { error in
                print(error)
                self.hideActivityIndicator()
            })
        }
    }
    
}

extension RulesAboutCaseTypeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableview.estimatedRowHeight = 55.0
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RulesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TipsTableViewCell = tableview.dequeueReusableCell(withIdentifier: "TipsTableViewCell", for: indexPath) as! TipsTableViewCell
        cell.lblDescription.text = "\(indexPath.row + 1). \(RulesList[indexPath.row].ruleDescription)"
        if RulesList[indexPath.row].selected == true {
            cell.btnSelectCheckbox.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            cell.btnSelectCheckbox.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        cell.delegateRules = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:TipsTableViewCell = tableview.cellForRow(at: indexPath) as! TipsTableViewCell
        if RulesList[indexPath.row].selected == true {
            RulesList[indexPath.row].selected = false
            cell.btnSelectCheckbox.setImage(UIImage(named: "unchecked"), for: .normal)
        } else {
            RulesList[indexPath.row].selected = true
            cell.btnSelectCheckbox.setImage(UIImage(named: "checked"), for: .normal)
        }
        
    }
}

extension RulesAboutCaseTypeVC : RulesSelectionDelegate {
    func ruleSelected(selectedCell: TipsTableViewCell) {
        let indexPath:IndexPath = tableview.indexPath(for: selectedCell)!
        if RulesList[indexPath.row].selected == true {
            RulesList[indexPath.row].selected = false
            selectedCell.btnSelectCheckbox.setImage(UIImage(named: "unchecked"), for: .normal)
        } else {
            RulesList[indexPath.row].selected = true
            selectedCell.btnSelectCheckbox.setImage(UIImage(named: "checked"), for: .normal)
        }
    }
}

