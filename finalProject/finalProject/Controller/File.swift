//
//  File.swift
//  finalProject
//
//  Created by nouf on 04/01/2022.
//

import Foundation
func date() -> String{
let date = Date()

let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = date.getElapsedInterval()
let dateString = dateFormatter.string(from: date)
    return dateString
}
