//
//  Users.swift
//  finalProject
//
//  Created by nouf on 30/12/2021.
//

import Foundation
import UIKit

class User {
    var emailUser: String
    var image : String
    var userName: String
    var Bio : String
    var JobTitle : String
    var website : String
        init(emailUser: String , image: String ,userName: String ,Bio : String , JobTitle :String , website : String) {
            
            self.emailUser = emailUser
            self.image = image
            self.userName = userName
            self.Bio = Bio
            self.website = website
            self.JobTitle = JobTitle
        }
}

class Client : User {
    var projects :[String] = []
    
}


class Developers : User {
    
    
}
