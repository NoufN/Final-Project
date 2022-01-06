//
//  File.swift
//  finalProject
//
//  Created by nouf on 04/01/2022.
//

import Foundation
func dateToSring() -> String{
let date = Date()
let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
let dateString = dateFormatter.string(from: date)
    return dateString
}

func stringToDate(Date: String) -> String{

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = dateFormatter.date(from:Date)
    
    return  date!.getElapsedInterval()
}
