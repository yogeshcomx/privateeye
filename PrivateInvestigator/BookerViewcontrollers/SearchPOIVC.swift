//
//  SearchPOIVC.swift
//  PrivateInvestigator
//
//  Created by apple on 6/22/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class SearchPOIVC: UIViewController {

    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        setupUI()
    }
    
    func setupUI() {
        
    }
    
    func setupTableview() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        tableview.register(UINib(nibName: "POIProfileDetailsCell", bundle: Bundle.main), forCellReuseIdentifier: "POIProfileDetailsCell")
        tableview.delegate = self
        tableview.dataSource = self
    }

}

extension SearchPOIVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:POIProfileDetailsCell = tableview.dequeueReusableCell(withIdentifier: "POIProfileDetailsCell", for: indexPath) as! POIProfileDetailsCell
        return cell
    }
}
