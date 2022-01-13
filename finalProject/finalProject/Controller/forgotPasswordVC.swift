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
        emilUser.customTextfield()
        emilUser.frame = CGRect(x: 0, y: 0, width: 0, height: 28)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any){
        Auth.auth().sendPasswordReset(withEmail: emilUser.text!, completion: { (error) in
              if error != nil{
                  let resetFailedAlert = UIAlertController(title: "فشل", message: "خطاء \(String(describing: error!.localizedDescription))", preferredStyle: .alert)
                  resetFailedAlert.addAction(UIAlertAction(title: "نعم", style: .default, handler: nil))
                  self.present(resetFailedAlert, animated: true, completion: nil)
              }else {
                  let resetEmailSentAlert = UIAlertController(title: "تم ", message: "تاكد من بريدك الالكتروني", preferredStyle: .alert)
                  resetEmailSentAlert.addAction(UIAlertAction(title: "نعم", style: .default, handler: nil))
                  self.present(resetEmailSentAlert, animated: true, completion: nil)
              }
          })
      }

}
