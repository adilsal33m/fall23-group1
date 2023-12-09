//
//  Course.swift
//  MarkMate
//
//  Created by Macbook on 21/11/2023.
//

import Foundation

class Course:CustomStringConvertible
{
    var course_nbr: Int32
    var semester:String
    var course_name: String
    var attendance_req: Int32
    var totalStudents: Int
    var totalSessions: Int
    
    init(course_nbr: Int32, semester: String, course_name: String, attendance_req:Int32, totalStudents:Int = 0, totalSessions:Int = 0)
    {
        self.course_nbr = course_nbr
        self.semester = semester
        self.course_name = course_name
        self.attendance_req = attendance_req
        self.totalStudents = totalStudents
        self.totalSessions = totalSessions
    }
    
    var description: String {
        return "Course Name: \(self.course_name), Course_Nbr: \(self.course_nbr), Total Students: \(self.totalStudents), Total Sessions: \(self.totalSessions)"
      }
    
    
}
