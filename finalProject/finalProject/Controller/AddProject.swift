//
//  AddProject.swift
//  finalProject
//
//  Created by nouf on 01/01/2022.
//

import UIKit
import Firebase

class AddProject: UIViewController , UITextViewDelegate{
    
    @IBOutlet weak var detalisProject: UITextView!
    @IBOutlet weak var titleProject: UITextField!
    @IBOutlet weak var specializayion: UISegmentedControl!
    var specializayionValue = "تطبيقات الجوال"
    @IBOutlet weak var connectionTool: UITextField!
    @IBOutlet weak var value : UITextField!
    
    @IBOutlet weak var stepper : UIStepper!
    
    var dateCreated  = ""
    
    var nameImage  : String?
    var nameUser  : String?
    let db = Firestore.firestore()
    let email = Auth.auth().currentUser?.email
    var project = [Projects]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loedUser()
        hideKeyboardWhenTappedAround()
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 100
        detalisProject.delegate = self
//        detalisProject.isScrollEnabled = false
        detalisProject.text = "اكتب تفاصيل مشروعك ليتمكن المبرمج من فمهمه"
        detalisProject.textColor = UIColor.lightGray
        detalisProject.textAlignment = .right
        dateCreated = dateToSring()
    }
    
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        value.text = Int(sender.value).description
        
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
            self.navigationController?.popViewController(animated: true)
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
        
        let Ref = self.db.collection("Projects")
        let Doc = Ref.document()
        let data = [
            "ProjectID":Doc.documentID ,
            "emailUser"  : email! ,
            "Title"  : titleProject.text!,
            "Details" : detalisProject.text! ,
            "specializayion"  : specializayionValue ,
            "Deadline" :    value.text!,
            "ConnectionTool" : connectionTool.text! ,
            "nameUser" : nameUser ,
            "imageProfile" :  nameImage ,
            "DateCreated" : dateCreated  ,
            //                    "Likes" : []
        ] as [String : Any]
        Doc.setData(data) { error in
            if let error = error {
                print("Error: ",error.localizedDescription)
            }else {
                
                print("Successfully saved data")
            
            }
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = detalisProject.sizeThatFits(size)
        detalisProject.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if detalisProject.textColor == UIColor.lightGray {
            detalisProject.text = nil
            detalisProject.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if detalisProject.text.isEmpty {
            detalisProject.text = "اكتب تفاصيل مشروعك ليتمكن المبرمج من فمهمه"
            detalisProject.textColor = UIColor.lightGray
        }
    }
}





