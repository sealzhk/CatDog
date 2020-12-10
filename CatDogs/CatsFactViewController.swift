//
//  CatsFactViewController.swift
//  CatDogs
//
//  Created by Alua Zhakieva on 10/14/20.
//  Copyright © 2020 Alua Zhakieva. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class CatsFactTableViewCell: UITableViewCell {
    @IBOutlet weak var factsTextLabel: UILabel!
}

class CatsFactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catFacts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  factsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CatsFactTableViewCell
       cell.factsTextLabel.text = catFacts[indexPath.row].fact
       return cell
    }

    var catFacts = [CatFact]()
    
    @IBOutlet weak var factsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.factsTableView.delegate = self
        self.factsTableView.dataSource = self
        self.getCatFacts()
    }
    

    func getCatFacts() {
        Alamofire.request("https://catfact.ninja/facts?limit=10", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<CatFacts>) in
            if let result = response.result.value {
                self.catFacts = result.data ?? []
                self.factsTableView.reloadData()
            }
        }
    }
    

}
