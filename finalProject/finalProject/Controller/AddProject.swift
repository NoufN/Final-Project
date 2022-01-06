//
//  AddProject.swift
//  finalProject
//
//  Created by nouf on 01/01/2022.
//

import UIKit
import Firebase

class AddProject: UIViewController{

    @IBOutlet weak var detalisProject: UITextView!
    @IBOutlet weak var titleProject: UITextField!
    @IBOutlet weak var specializayion: UISegmentedControl!
     var specializayionValue = "applications"
    @IBOutlet weak var connectionTool: UITextField!
    @IBOutlet weak var valueLabel : UILabel!
    @IBOutlet weak var stepper : UIStepper!
    @IBOutlet weak var viewSub: UIView!
    var dateCreated  = ""
    
    var nameImage  : String?
    var nameUser  : String?
    let db = Firestore.firestore()
    let email = Auth.auth().currentUser?.email
    var project = [Projects]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loedUser()
        viewSub.layer.borderWidth = 0.5
        viewSub.layer.borderColor = UIColor.gray.cgColor
        viewSub.layer.masksToBounds = true
        viewSub.layer.cornerRadius = 5
        stepper.wraps = true
          stepper.autorepeat = true
          stepper.maximumValue = 100

        dateCreated = dateToSring()
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        valueLabel.text = Int(sender.value).description
    
    }
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch specializayion.selectedSegmentIndex
        {
        case 0 :
            specializayionValue = "تطبيقات الجوال"
        case 1:
            specializayionValue = "موقع الإلكتروني"
            
        default:
            break;
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if detalisProject.text != ""  && titleProject.text != "" && connectionTool.text != "" {
            addProject()
        } else {
            
            let alert = UIAlertController(title: "عذرًا", message:"يجب عليك ملىء كل الحقول المطلوبة", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "نعم", style: .default) { _ in })

            present(alert, animated: true, completion: nil)
        }
        }
     
    func loedUser(){
        db.collection("Users").whereField("emailUser", isEqualTo: email!).getDocuments { querySnapshot, error in
        
        if let err = error {
            print("Error getting documents: \(err.localizedDescription)")
        } else {
          
            for document in querySnapshot!.documents {
                let data = document.data()
                self.nameImage = data["image"] as? String ?? ""
                self.nameUser = data["userName"] as? String ?? ""
        
             
            }
        
            
        }
        
    }
    }
    
    func  addProject(){
        db.collection("Projects").addDocument(data: [
                        "emailUser"  : email! ,
                        "Title"  : titleProject.text!,
                        "Details" : detalisProject.text! ,
                        "specializayion"  : specializayionValue ,
                        "Deadline" :    valueLabel.text!,
                        "ConnectionTool" : connectionTool.text! ,
                        "nameUser" : nameUser ,
                        "imageProfile" :  nameImage ,
                        "DateCreated" : dateCreated  ,
                        "comments" : ""
                    ]) { [self]  (error) in
                        if let e = error {
                            print(e)
                        } else {
                            print("Successfully saved data")
//                            self.project.append(Projects(nameProject: titleProject.text!, detailsProject: detalisProject.text!, Deadline: valueLabel.text!, ConnectionTool: self.connectionTool.text!, DateCreated: "\(Date.now)", specializayion: ""))
                        }
                    }
    }
            
            
           

}
