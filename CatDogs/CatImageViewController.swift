//
//  CatImageViewController.swift
//  CatDogs
//
//  Created by Alua Zhakieva on 10/14/20.
//  Copyright © 2020 Alua Zhakieva. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class CatImageViewController: UIViewController {

    var cat = [CatsRandomImage]()
    
    @IBOutlet weak var catImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCat()
        self.configConstraints()
    }
    
    
    func getCat() {
        Alamofire.request("https://api.thecatapi.com/v1/images/search", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { (responseData ) in
            if let data = responseData.data {
                do {
                    self.cat = try JSONDecoder().decode([CatsRandomImage].self, from: data)
                    print("photos = \(self.cat)")
                    self.activityView.stopAnimating()
                    let linkImage = self.cat[0].url!
                    self.catImage.downloaded(from: linkImage)
            }
            catch {
                print("error = \(error)")
                }
            }
        }
    }
    
    @IBAction func anotherImage(_ sender: Any) {
        Alamofire.request("https://api.thecatapi.com/v1/images/search", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { (responseData ) in
            if let data = responseData.data {
                do {
                    self.cat = try JSONDecoder().decode([CatsRandomImage].self, from: data)
                    print("photos = \(self.cat)")
                    self.activityView.stopAnimating()
                    let linkImage = self.cat[0].url!
                    self.catImage.downloaded(from: linkImage)
            }
            catch {
                print("error = \(error)")
                }
            }
        }
    }
    
    lazy var activityView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        view.addSubview(activityView)
        return activityView
    }()

    lazy var stackView: UIStackView = {
        let mainStackView: UIStackView = UIStackView(arrangedSubviews: [self.catImage])
        // Расстояние между элементами понадобиться во второй части
        mainStackView.spacing = 50
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        self.view.addSubview(mainStackView)
        return mainStackView
    }()
    
    func configConstraints() {
       self.activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.activityView.centerXAnchor.constraint(equalTo: self.catImage.centerXAnchor),
            self.activityView.centerYAnchor.constraint(equalTo: self.catImage.centerYAnchor)
            ])
    }
    
    
    
}
