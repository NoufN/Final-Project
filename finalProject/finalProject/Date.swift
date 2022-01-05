//
//  Date.swift
//  finalProject
//
//  Created by nouf on 04/01/2022.
//

import Foundation
extension Date {

func getElapsedInterval() -> String {

    let interval = Calendar.current.dateComponents([.year, .month, .day , .hour  ], from: self, to: Date())

    if let year = interval.year, year > 0 {
        
        switch (year){
        case 1 :
        return  "نُشر منذ سنة"
        case 2 :
            return  "نُشر منذ سنتين"
        default:
            return
        "نُشر منذ \(year)" + " " + "سنوات"

        }
    } else if let month = interval.month, month > 0 {
        
        switch (month){
        case 1 :
        return  "نُشر منذ شهر"
        case 2 :
            return  "نُشر منذ شهرين"
        default:
            return "نُشر منذ \(month)" + " " + "أشهر"
        }
    } else if let day = interval.day, day > 0 {
        switch (day){
        case 1 :
        return  "نُشر منذ يوم"
        case 2 :
            return  "نُشر منذ يومين"
        default:
            return "نُشر منذ \(day)" + " " + "أيام"
        }
        
    }else if let hour = interval.hour, hour > 0 {
            switch (hour){
            case 1 :
            return  "نُشر منذ ساعة"
            case 2 :
                return  "نُشر منذ ساعتين"
            default:
                return "نُشر منذ \(hour)" + " " + "ساعات"
            }
    } else {
        return "نُشر منذ قليل"
    }

}
}

