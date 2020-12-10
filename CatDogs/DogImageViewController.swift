//
//  DogImageViewController.swift
//  CatDogs
//
//  Created by Alua Zhakieva on 10/14/20.
//  Copyright © 2020 Alua Zhakieva. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class DogImageViewController: UIViewController {
    
    var dogIm = [DogImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getImage()
        self.configConstraints()
    }
    
    @IBAction func MoreImages(_ sender: Any) {
        Alamofire.request("https://api.thedogapi.com/v1/images/search", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { (responseData ) in
            if let data = responseData.data {
                do {
                    self.dogIm = try JSONDecoder().decode([DogImage].self, from: data)
                    print("photos = \(self.dogIm)")
                    self.activityView.stopAnimating()
                    let linkImage = self.dogIm[0].url!
                    self.randomImage.downloaded(from: linkImage)
            }
            catch {
                print("error = \(error)")
                }
            }
        }
    }
    
    @IBOutlet weak var randomImage: UIImageView!
    
    func getImage() {
        Alamofire.request("https://api.thedogapi.com/v1/images/search", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { (responseData ) in
            if let data = responseData.data {
                do {
                    self.dogIm = try JSONDecoder().decode([DogImage].self, from: data)
                    print("photos = \(self.dogIm)")
                    self.activityView.stopAnimating()
                    let linkImage = self.dogIm[0].url!
                    self.randomImage.downloaded(from: linkImage)
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
        let mainStackView: UIStackView = UIStackView(arrangedSubviews: [self.randomImage])
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
            self.activityView.centerXAnchor.constraint(equalTo: self.randomImage.centerXAnchor),
            self.activityView.centerYAnchor.constraint(equalTo: self.randomImage.centerYAnchor)
            ])
    }
    
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
