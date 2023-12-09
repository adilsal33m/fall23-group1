//
//  Student.swift
//  MarkMate
//
//  Created by Macbook on 21/11/2023.
//

import Foundation
class Student:CustomStringConvertible
{
    var name: String
    var erp: Int32
    var sessionsMissed:Int
    
    init(name: String, erp: Int32, sessionsMissed:Int=0) {
        self.name = name
        self.erp = erp
        self.sessionsMissed = sessionsMissed
    }
    
    var description: String {
        return "Student Name: \(self.name), ERP: \(self.erp), Absences: \(self.sessionsMissed)"
      }
}
