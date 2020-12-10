//
//  DogNewViewController.swift
//  CatDogs
//
//  Created by Alua Zhakieva on 10/14/20.
//  Copyright © 2020 Alua Zhakieva. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class DogNewViewController: UIViewController {

    @IBOutlet weak var newFact: UITextField!
    @IBOutlet weak var backgroundDog: UIImageView!
    
    @IBAction func sendNewFact(_ sender: Any) {
        let newFacts = [
            "facts" : newFact.text
        ]
        
        Alamofire.request("https://jsonplaceholder.typicode.com/comments", method: .post, parameters: newFacts as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
        response in
          switch response.result {
          case .success:
            print(response)
            self.alertView(title: "Thank You!", message: "New Fact is sended", printMes: "Success. New Fact is sended")
            break
          case .failure(let error):
            print(error)
            self.alertView(title: "Error", message: "New Fact isn't sended", printMes: "Error. New Fact isn't sended")
            break
            }
        }
    }
        
    func alertView(title: String, message: String, printMes: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print(printMes)
             })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundDog.loadGif(name: "dog3")
        // Do any additional setup after loading the view.
    }

}
