//
//  Course.swift
//  MarkMate
//
//  Created by Macbook on 21/11/2023.
//

import Foundation

class Course
{
    var class_nbr: Int32
    var semester:String
    var course_name: String
    var roster:[Student]?
    
    init(class_nbr: Int32, semester: String, course_name: String, roster:[Student]?)
    {
        self.class_nbr = class_nbr
        self.semester = semester
        self.course_name = course_name
        self.roster = roster
    }
    
    
}
