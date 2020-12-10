//
//  FindCat.swift
//  CatDogs
//
//  Created by Alua Zhakieva on 12/10/20.
//  Copyright © 2020 Alua Zhakieva. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import ContactsUI

var cats: Results<Cats>!
var realm = try! Realm()

class Cats: Object {
    @objc dynamic var catName = ""
    @objc dynamic var catAge = ""
    @objc dynamic var image: NSData?
    @objc dynamic var sellerName = ""
    @objc dynamic var sellerContact = ""
}

class catsCell: UICollectionViewCell {
    @IBOutlet weak var catImageCell: UIImageView!
    @IBOutlet weak var catNameCell: UILabel!
    @IBOutlet weak var catAgeCell: UILabel!
    @IBOutlet weak var sellerNameCell: UILabel!
    @IBOutlet weak var sellerContactCell: UILabel!
    
}

class FindCat: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var catColView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! catsCell
        let cat = cats[indexPath.row]
        cell.catNameCell.text = cat.catName
        cell.catAgeCell.text = cat.catAge
        let image: UIImage = UIImage(data: cat.image! as Data)!
        cell.catImageCell.image = image
        cell.sellerNameCell.text = cat.sellerName
        cell.sellerContactCell.text = cat.sellerContact
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cats = realm.objects(Cats.self)
        self.catColView.delegate = self
        self.catColView.dataSource = self
        reload()
    }
    
    func reload() {
        catColView.reloadData()
    }
    
}

class NewCat: UIViewController {
    let contactsController = CNContactPickerViewController()
    @IBOutlet weak var catNameText: UITextField!
    @IBOutlet weak var catAgeText: UITextField!
    @IBOutlet weak var catImageNew: UIImageView!
    @IBOutlet weak var sellerNameText: UITextField!
    @IBOutlet weak var sellerContactNew: UITextField!
    @IBAction func getImageCat(_ sender: Any) {
         self.chooseDir()
    }
    
    @IBAction func getContactSeller(_ sender: Any) {
        contactsController.delegate = self
        self.present(contactsController, animated: true, completion: nil)
    }
    
    @IBAction func saveInfo(_ sender: Any) {
        let image = NSData(data: catImageNew.image!.jpegData(compressionQuality: 0.9)!)
        let newCat = Cats()
        newCat.catName = catNameText.text!
        newCat.catAge = catAgeText.text!
        newCat.image = image
        newCat.sellerName = sellerNameText.text!
        newCat.sellerContact = sellerContactNew.text!
        try! realm.write {
            realm.add(newCat)
        }
    }
}

extension NewCat: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        print("Phone number: \(contact.phoneNumbers[0].value.stringValue)")
        print("Name: \(contact.givenName) \(contact.familyName)")
        self.sellerContactNew.text = contact.phoneNumbers[0].value.stringValue
        self.sellerNameText.text = "\(contact.givenName) \(contact.familyName)"
    }
}

extension NewCat: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseDir() {
        let libraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
               self.showImage(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Choose from Camera", style: .default) { (action) in
               self.showImage(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        AlertService.showAlert(style: .actionSheet, title: "Choose image from:", message: nil, actions:
            [libraryAction, cameraAction, cancelAction], completion: nil)
       }
       
       func showImage(sourceType: UIImagePickerController.SourceType) {
           let imagesController = UIImagePickerController()
           imagesController.delegate = self
           imagesController.sourceType = sourceType
           present(imagesController, animated: true, completion: nil)
       }
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
           if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
               catImageNew.image = editedImage
           }
           else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               catImageNew.image = originalImage
           }
           
           dismiss(animated: true, completion: nil)
       }
}

class AlertService {
    
    static func showAlert(style: UIAlertController.Style, title: String?, message: String?, actions:
        [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        if let topVC = UIApplication.getTopMostViewController() {
            alert.popoverPresentationController?.sourceView = topVC.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
            topVC.present(alert, animated: true, completion: completion)
        }
    }
    
}

extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}
