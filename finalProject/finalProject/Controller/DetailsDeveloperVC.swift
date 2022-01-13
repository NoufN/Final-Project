//
//  DetailsDeveloper.swift
//  finalProject
//
//  Created by nouf on 02/01/2022.
//

import UIKit
import Firebase

class DetailsDeveloper: UIViewController {
    var developer : Developers!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var JobTitle: UILabel!
    @IBOutlet weak var Bio: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var viewSub: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSub.layer.cornerRadius = 20
        getImage(imgStr: developer.image)
        nameUser.text = developer?.userName
        JobTitle.text = developer?.JobTitle
        Bio.text = developer?.Bio
        website.text = developer?.website
        
    }
    
    func getImage(imgStr: String )  {

        let url = "gs://finalproject-46146.appspot.com/images/" + "\(imgStr)"
        let Ref = Storage.storage().reference(forURL: url)
        Ref.getData(maxSize:  1024 * 1024) { data, error in
            if error != nil {
                print("Error: Image could not download!")
            } else {
        
                self.imageUser.image = UIImage(data: data!)!
//                self.imageUser.layer.borderWidth = 1
//                self.imageUser.layer.masksToBounds = true
//                self.imageUser.layer.borderColor = UIColor.gray.cgColor
                self.imageUser.layer.cornerRadius = self.imageUser.frame.width/2
                self.imageUser.clipsToBounds = true
                self.imageUser.contentMode = .scaleToFill
            }
        }

    }


}
