//
//  ViewController.swift
//  finalProject
//
//  Created by nouf on 30/12/2021.
//

import UIKit
import Firebase
import SwiftUI

class ViewController: UIViewController {
    @IBOutlet weak var nameUser: UITextField!
    @IBOutlet weak var emilUser: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    @IBOutlet weak var userType: UISegmentedControl!
    
    var user : String =  "Developers"
    var client = [Client]()
    var developers = [Developers]()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch userType.selectedSegmentIndex
        {
        case 0:
            user = "Developers"
            
        case 1:
            user = "Client"
            
        default:
            break;
        }
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        if emilUser.text != "" && passwordUser.text != "" {
            Auth.auth().createUser(withEmail: emilUser.text!, password: passwordUser.text!) { user, error in
                
                if let error = error {
                    print("Error: ",error.localizedDescription)
                    let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    if self.user == "Client" {
                        self.addUser(taypUser: self.user , emailUser: self.self.emilUser.text!)
                        let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "ClientTabBar")
                        as! ClientTabBar
                        tabBar.modalPresentationStyle = .fullScreen
                        self.present( tabBar, animated: true , completion: nil)
                        
                    } else if self.user == "Developers"  {
                        
                        self.addUser(taypUser: self.user , emailUser: self.self.emilUser.text!)
                        let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "DeveloperTabBar")
                        as! DeveloperTabBar
                        tabBar.modalPresentationStyle = .fullScreen
                        self.present( tabBar, animated: true , completion: nil)
                    }
                }
            }
        }else {
            let alert = UIAlertController(title: "عذرًا", message:"يجب عليك ملىء كل الحقول المطلوبة", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "نعم", style: .default) { _ in })

            present(alert, animated: true, completion: nil)
        }
        }
        
    
    

    func addUser(taypUser: String , emailUser : String) {
    
        if taypUser == "Client" {
            
            db.collection("Users").document(emailUser).setData(
                [
                    "emailUser"  : emilUser.text! ,
                    "image"  : "kindpng_248253.png",
                    "userName" : nameUser.text! ,
                    "Bio"  : "" ,
                    "JobTitle" : "",
                    "website" : "" ,
                    "taypUser" : taypUser ,
                    "Projects" : []
                ]
            )
            { (error) in
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    print("new document has created..")
                    
                    let user = Client(emailUser: self.emilUser.text! , image:"kindpng_248253.png" ?? "", userName: self.nameUser.text!, Bio: "" ,JobTitle: "", website: "")
                    self.client.append(user)
                    
                }
                
            }
        }
        
        else if  taypUser == "Developers"  {
            
            
            db.collection("Users").document(emailUser).setData(
                [
                    "emailUser"  : emilUser.text! ,
                    "image"  : "kindpng_248253.png" ,
                    "userName" : nameUser.text! ,
                    "Bio"  : "" ,
                    "JobTitle" : "" ,
                    "website" : "" ,
                    "taypUser" : taypUser
                ]
            )
            { (error) in
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    print("new document has created..")
                    
                    let user = Developers(emailUser: self.emilUser.text! , image: "kindpng_248253.png" ?? "" , userName: self.nameUser.text!, Bio: "" ,  JobTitle: "", website: "")
                    self.developers.append(user)
                    
                    
                }
            }
        }
    }
    
}


