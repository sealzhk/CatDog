//
//  DogsFactViewController.swift
//  CatDogs
//
//  Created by Alua Zhakieva on 10/14/20.
//  Copyright © 2020 Alua Zhakieva. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class DogsFactTableViewCell: UITableViewCell {
    @IBOutlet weak var dogFactTextLabel: UILabel!
}

class DogsFactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogFacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = factsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DogsFactTableViewCell
        cell.dogFactTextLabel.text = dogFacts[indexPath.row].fact
        return cell
    }
    
    
    var dogFacts = [DogFacts]()

    @IBOutlet weak var factsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.factsTableView.delegate = self
        self.factsTableView.dataSource = self
        self.getDogFacts()
        self.factsTableView.reloadData()
    }
    
    func getDogFacts() {
        Alamofire.request("https://dog-facts-api.herokuapp.com/api/v1/resources/dogs?number=10", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { (responseData ) in
            if let data = responseData.data {
                do {
                    self.dogFacts = try JSONDecoder().decode([DogFacts].self, from: data)
                    print("facts = \(self.dogFacts)")
            }
            catch {
                print("error = \(error)")
            }
                DispatchQueue.main.async {
                    self.factsTableView.reloadData()
                }
            }
        }
    }
    
}

