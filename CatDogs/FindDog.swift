//
//  FindDog.swift
//  CatDogs
//
//  Created by Alua Zhakieva on 12/10/20.
//  Copyright © 2020 Alua Zhakieva. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import ContactsUI

var dogs: Results<Dogs>!

class Dogs: Object {
    @objc dynamic var dogName = ""
    @objc dynamic var dogAge = ""
    @objc dynamic var image: NSData?
    @objc dynamic var sellerName = ""
    @objc dynamic var sellerContact = ""
}

class dogsCell: UICollectionViewCell {
    @IBOutlet weak var dogImageCell: UIImageView!
    @IBOutlet weak var dogNameCell: UILabel!
    @IBOutlet weak var dogAgeCell: UILabel!
    @IBOutlet weak var sellerNameCell: UILabel!
    @IBOutlet weak var sellerContactCell: UILabel!
}

class FindDog: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var DogsColView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! dogsCell
        let dog = dogs[indexPath.row]
        cell.dogNameCell.text = dog.dogName
        cell.dogAgeCell.text = dog.dogAge
        let image: UIImage = UIImage(data: dog.image! as Data)!
        cell.dogImageCell.image = image
        cell.sellerNameCell.text = dog.sellerName
        cell.sellerContactCell.text = dog.sellerContact
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dogs = realm.objects(Dogs.self)
        self.DogsColView.delegate = self
        self.DogsColView.dataSource = self
        reload()
    }
    
    func reload() {
        DogsColView.reloadData()
    }
}

class NewDog: UIViewController {
    let contactsController = CNContactPickerViewController()
    
    @IBOutlet weak var dogNameText: UITextField!
    @IBOutlet weak var dogNameAge: UITextField!
    @IBOutlet weak var dogImageIn: UIImageView!
    @IBOutlet weak var sellerNameText: UITextField!
    @IBOutlet weak var sellerContactText: UITextField!
    
    @IBAction func getDocImage(_ sender: Any) {
        self.chooseDir()
    }
    
    @IBAction func getDogContact(_ sender: Any) {
        contactsController.delegate = self
        self.present(contactsController, animated: true, completion: nil)
    }
    
    @IBAction func dogSave(_ sender: Any) {
        let image = NSData(data: dogImageIn.image!.jpegData(compressionQuality: 0.9)!)
        let newDog = Dogs()
        newDog.dogName = dogNameText.text!
        newDog.dogAge = dogNameAge.text!
        newDog.image = image
        newDog.sellerName = sellerNameText.text!
        newDog.sellerContact = sellerContactText.text!
        try! realm.write {
            realm.add(newDog)
        }
    }
}

extension NewDog: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        print("Phone number: \(contact.phoneNumbers[0].value.stringValue)")
        print("Name: \(contact.givenName) \(contact.familyName)")
        self.sellerContactText.text = contact.phoneNumbers[0].value.stringValue
        self.sellerNameText.text = "\(contact.givenName) \(contact.familyName)"
    }
}

extension NewDog: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
               dogImageIn.image = editedImage
           }
           else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               dogImageIn.image = originalImage
           }
           
           dismiss(animated: true, completion: nil)
       }
}
