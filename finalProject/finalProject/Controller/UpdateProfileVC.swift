//
//  UpdateProfileVC.swift
//  finalProject
//
//  Created by nouf on 03/01/2022.
//

import UIKit
import Firebase
class UpdateProfileVC: UIViewController {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameUser: UITextField!
    @IBOutlet weak var JobTitle: UITextField!
    @IBOutlet weak var Bio: UITextField!
    @IBOutlet weak var website: UITextField!
    let imagePicker = UIImagePickerController()
    var imageName = "\(UUID().uuidString).png"
    let db = Firestore.firestore()
    let email = Auth.auth().currentUser?.email
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageProfile.image = UIImage(named: "\(user.image)")
      loadData()
        
        imagePicker.delegate = self
        imageProfile.layer.cornerRadius = imageProfile.frame.width/2
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func save(_ sender: Any) {
        updateData()
    }
    
    func updateData() {
        uploadImage()
        db.collection("Users").document(email!).updateData([
            "image"  : imageName  ,
            "userName" : nameUser.text! ,
            "Bio"  : Bio.text! ,
            "JobTitle" : JobTitle.text! ,
            "website" : website.text! ,
    ]) { err in
        if let err = err {
            print("Error updating document: \(err.localizedDescription)")
        } else {
            print("Document successfully updated")
          
        }
    }
}

    func loadData(){

            db.collection("Users").whereField( "emailUser", isEqualTo: email!).addSnapshotListener{(querySnapshot, error) in
            
        if let err = error {
            print("Error getting documents: \(err.localizedDescription)")
        } else {
         
            for document in querySnapshot!.documents {
                let data = document.data()
                
                self.nameUser.text = data["userName"] as! String
                self.JobTitle.text = data["JobTitle"] as? String ?? ""
                self.Bio.text = data["Bio"] as? String  ?? ""
                self.website.text = data["website"] as? String ?? ""
              
            }
        
            
        }
        
    }
    }

    func uploadImage(){
        let imagefolder = Storage.storage().reference().child("images")
        if let imageData = imageProfile.image?.jpegData(compressionQuality: 0.1) {
            imagefolder.child(imageName).putData(imageData, metadata: nil){
                (metaData , err) in
                if let error = err {
                    print(error.localizedDescription)
                }else {
                    print("تم رفع الصورة بنجاح")
                }
            }
        }
    }
    
    
}


//MARK: -UIImagePickerController
extension UpdateProfileVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageProfile.image = pickedImage
        picker.dismiss(animated: true, completion: nil)
    }
}




