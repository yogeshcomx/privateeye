//
//  SettingsPrivateEyeVC.swift
//  PrivateInvestigator
//
//  Created by apple on 7/28/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class SettingsPrivateEyeVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableview()
        
    }
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
    }
    
    func setupTableview() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableview.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func LogoutAccount() {
        let alert = UIAlertController(title: "Logout",
                                      message: "Are you sure you want to log out?",
                                      preferredStyle: .alert)
        let submit = UIAlertAction(title: "YES", style: .default, handler: { (action) -> Void in
            let userDetailsDictionary: [String:String] = ["FirstName": "", "LastName": "", "Gender": "", "DOB" : "", "GoogleID": "", "FacebookID": "", "Email": "", "Phone": "", "Countrycode" : "", "ProfilePicUrl" : "", "Address": "", "Street" : "", "City": "", "State": "", "Country" : "", "ZipCode" : "", "CurrentEmployer" : "", "EquipmentTags" : "", "Latitude" : "", "Longitude" : ""]
            UserDefaults.standard.set(userDetailsDictionary, forKey: userProfileDetailsUserDefaults)
            UserDefaults.standard.set("", forKey: registrationFlowStatusUserDefaults)
            UserDefaults.standard.set(false, forKey: userLoginStatusUserDefaults)
            UserDefaults.standard.set(0, forKey: userRoleIdUserDefaults)
            UserDefaults.standard.set("", forKey: userIdUserDefaults)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.loadViewController(storyBoard: "Main", viewController: nil)
        })
        let cancel = UIAlertAction(title: "CANCEL", style: .default, handler: { (action) -> Void in })
        alert.addAction(cancel)
        alert.addAction(submit)
        present(alert, animated: true, completion: nil)
    }
    
    func DeleteAccount() {
        let alert = UIAlertController(title: "Delete",
                                      message: "Are you sure you want to delete the account?\nAll the details will be deleted.",
                                      preferredStyle: .alert)
        let submit = UIAlertAction(title: "YES", style: .default, handler: { (action) -> Void in
            
        })
        let cancel = UIAlertAction(title: "CANCEL", style: .default, handler: { (action) -> Void in })
        alert.addAction(cancel)
        alert.addAction(submit)
        present(alert, animated: true, completion: nil)
    }
    
    func shareAppInvitationUrl() {
        let info = "Want to hire Private Investigator. Here you can!!  Download the app using following link:"
        let appUrl = URL(string:"http://comxtech.com/")
        let shareAll = [info, appUrl] as [AnyObject]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: [])
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}


extension SettingsPrivateEyeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "General"
        } else if section == 1 {
            return "Security"
        } else if section == 2 {
            return "Account"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.darkGray
        header.textLabel?.font = UIFont(name: "Avenir-Regular", size: 15)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .left
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cellSettings:SettingsBookerTableViewCell = tableview.dequeueReusableCell(withIdentifier: "SettingsBookerTableViewCell", for: indexPath) as! SettingsBookerTableViewCell
                cellSettings.lblTitle.text = "Invite"
                let adduser = UIImage(named:"add-user")?.imageWithColor(UIColor.init(hexString: "F90413"))
                cellSettings.imgOptionIcon.image = adduser
                cellSettings.imgOptionIcon.tintColor = UIColor.init(hexString: "F90413")
                return cellSettings
            } else if indexPath.row == 1 {
                let cellSettings:SettingsBookerTableViewCell = tableview.dequeueReusableCell(withIdentifier: "SettingsBookerTableViewCell", for: indexPath) as! SettingsBookerTableViewCell
                cellSettings.lblTitle.text = "Notifications"
                let notimg = UIImage(named:"notification")?.imageWithColor(UIColor.init(hexString: "F90413"))
                cellSettings.imgOptionIcon.image = notimg
                cellSettings.imgOptionIcon.tintColor = UIColor.init(hexString: "F90413")
                return cellSettings
            }
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cellSettings:SettingsBookerTableViewCell = tableview.dequeueReusableCell(withIdentifier: "SettingsBookerTableViewCell", for: indexPath) as! SettingsBookerTableViewCell
                cellSettings.lblTitle.text = "Change Password"
                let password = UIImage(named:"lock")?.imageWithColor(UIColor.init(hexString: "F90413"))
                cellSettings.imgOptionIcon.image = password
                cellSettings.imgOptionIcon.tintColor = UIColor.init(hexString: "F90413")
                return cellSettings
            } else if indexPath.row == 1 {
                let cellSettings:SettingsBookerTableViewCell = tableview.dequeueReusableCell(withIdentifier: "SettingsBookerTableViewCell", for: indexPath) as! SettingsBookerTableViewCell
                cellSettings.lblTitle.text = "Change Phone Number"
                let phone = UIImage(named:"phoneReceiver")?.imageWithColor(UIColor.init(hexString: "F90413"))
                cellSettings.imgOptionIcon.image = phone
                cellSettings.imgOptionIcon.tintColor = UIColor.init(hexString: "F90413")
                return cellSettings
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cellSettings:SettingsBookerTableViewCell = tableview.dequeueReusableCell(withIdentifier: "SettingsBookerTableViewCell", for: indexPath) as! SettingsBookerTableViewCell
                cellSettings.lblTitle.text = "Logout"
                let exitImg = UIImage(named:"exit")?.imageWithColor(UIColor.init(hexString: "F90413"))
                cellSettings.imgOptionIcon.image = exitImg
                cellSettings.imgOptionIcon.tintColor = UIColor.init(hexString: "F90413")
                return cellSettings
            } else if indexPath.row == 1 {
                let cellSettings:SettingsBookerTableViewCell = tableview.dequeueReusableCell(withIdentifier: "SettingsBookerTableViewCell", for: indexPath) as! SettingsBookerTableViewCell
                cellSettings.lblTitle.text = "Delete"
                let delImg = UIImage(named:"rubbish")?.imageWithColor(UIColor.init(hexString: "F90413"))
                cellSettings.imgOptionIcon.image = delImg
                cellSettings.imgOptionIcon.tintColor = UIColor.init(hexString: "F90413")
                return cellSettings
            } else if indexPath.row == 2 {
                let cellVersion:SettingsBookerVersionTableViewCell = tableview.dequeueReusableCell(withIdentifier: "SettingsBookerVersionTableViewCell", for: indexPath) as! SettingsBookerVersionTableViewCell
                if let versiontext = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
                   cellVersion.lblTitle.text = "App Version \(versiontext)"
                }
                return cellVersion
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                shareAppInvitationUrl()
            } else if indexPath.row == 1 {
                
            }
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                
            } else if indexPath.row == 1 {
                
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                DispatchQueue.main.async {
                    self.LogoutAccount()
                }
            } else if indexPath.row == 1 {
                DispatchQueue.main.async {
                    self.DeleteAccount()
                }
            }
        }
    }
    
    
}

