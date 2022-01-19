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
    @IBOutlet weak var Bio: UITextView!
    @IBOutlet weak var website: UITextField!
    let imagePicker = UIImagePickerController()
    var imageName = "\(UUID().uuidString).png"
    let db = Firestore.firestore()
    let email = Auth.auth().currentUser?.email
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        imageProfile.layer.borderWidth = 1
        imageProfile.layer.masksToBounds = true
        imageProfile.layer.borderColor = UIColor.black.cgColor
        imageProfile.layer.cornerRadius =  imageProfile.frame.height/2
        imageProfile.clipsToBounds = true
        nameUser.customTextfield()
        nameUser.frame = CGRect(x: 0, y: 0, width: 0, height:50)
        JobTitle.customTextfield()
        JobTitle.frame = CGRect(x: 0, y: 0, width: 0, height:50)
        website.customTextfield()
        website.frame = CGRect(x: 0, y: 0, width: 0, height:50)
        
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
        self.navigationController?.popViewController(animated: true)
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
                    self.Bio.text  = data["Bio"] as? String  ?? ""
                    self.website.text = data["website"] as? String ?? ""
                    let name = data["image"] as? String ?? ""
                    
                    self.getImage(imgStr: name )
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
    
    
    func getImage(imgStr: String )  {
        
        let url = "gs://finalproject-46146.appspot.com/images/" + "\(imgStr)"
        let Ref = Storage.storage().reference(forURL: url)
        Ref.getData(maxSize:1 * 1024 * 1024) { data, error in
            if error != nil {
                print("Error: Image could not download!")
            } else {
                
                
                self.imageProfile.image = UIImage(data: data!)!
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




