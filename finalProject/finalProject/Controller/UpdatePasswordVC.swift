//
//  UpdatePasswordVC.swift
//  finalProject
//
//  Created by nouf on 04/01/2022.
//

import UIKit
import Firebase

class UpdatePasswordVC: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        password.customTextfield()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updatePassword(_ sender: Any) {
        Auth.auth().currentUser?.updatePassword(to: password.text!) { error in
            
            if let error = error {
                print("Error: ",error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
}
