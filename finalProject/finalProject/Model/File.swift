//
//  File.swift
//  finalProject
//
//  Created by nouf on 02/01/2022.
//

import Foundation
import Firebase
import UIKit

func getImage(imgStr: String , image : UIImageView) {
    let url = "gs://finalproject-46146.appspot.com/images/" + "\(imgStr)"
    let Ref = Storage.storage().reference(forURL: url)
    Ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
        if error != nil {
            print("Error: Image could not download!")
        } else {
         image.image = UIImage(data: data!)
        }
    }
}
