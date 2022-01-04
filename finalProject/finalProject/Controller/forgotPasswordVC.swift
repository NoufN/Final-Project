//
//  forgotPasswordVC.swift
//  finalProject
//
//  Created by nouf on 01/01/2022.
//

import UIKit
import Firebase

class forgotPasswordVC: UIViewController {
    @IBOutlet weak var emilUser: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any){
        Auth.auth().sendPasswordReset(withEmail: emilUser.text!, completion: { (error) in
              if error != nil{
                  let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                  resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                  self.present(resetFailedAlert, animated: true, completion: nil)
              }else {
                  let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                  resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                  self.present(resetEmailSentAlert, animated: true, completion: nil)
              }
          })
      }

}
