//
//  DetailsDeveloper.swift
//  finalProject
//
//  Created by nouf on 02/01/2022.
//

import UIKit

class DetailsDeveloper: UIViewController {
    var developer : Developers!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var JobTitle: UILabel!
    @IBOutlet weak var Bio: UILabel!
    @IBOutlet weak var website: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
      
        imageUser.image = UIImage(named: "\(developer.image)")
        nameUser.text = developer.userName
        JobTitle.text = developer.JobTitle
        Bio.text = developer.Bio
        website.text = developer.website
        
    }
    



}
