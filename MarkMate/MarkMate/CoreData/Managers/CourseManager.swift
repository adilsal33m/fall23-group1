//
//  CourseManager.swift
//  MarkMate
//
//  Created by Macbook on 05/12/2023.
//

import Foundation

struct CourseManager
{
    private var courseRepo = CourseRepository()
    
    func createCourse(course:Course, students:[Student]) -> Bool
    {
        let response = courseRepo.create(record: course, list: students)
        if response == false
        {
            debugPrint("Error creating course. Courses cannot have similar Nbr")
            return false
        }
    
        return true
    }
    
    func addStudentToCourse(course_nbr:Int32, student:Student) -> Bool
    {
        let response = courseRepo.addStudent(course_nbr: course_nbr, student: student)
        if response == false
        {
            debugPrint("Error occurred while adding student to course \(course_nbr)")
            return false
        }
        return true
    }
    
    func removeStudentFromCourse(course_nbr : Int32, erp:Int32) -> Bool
    {
        let response = courseRepo.removeStudent(course_nbr: course_nbr, erp:erp)
        if response == false
        {
            debugPrint("Error occurred while removing student from course \(course_nbr)")
            return false
        }
        return true
    }
    
    func deleteCourse(course_nbr : Int32) -> Bool
    {
        let response = courseRepo.deleteCourse(course_nbr: course_nbr)
        if response == false
        {
            debugPrint("Error occurred while deleting course \(course_nbr)")
            return false
        }
        return true
    }
    
    func updateCourse(course:Course) -> Bool
    {
        let response = courseRepo.updateCourse(course: course)
        if response == false
        {
            debugPrint("Error occurred while updating course \(course.course_nbr)")
            return false
        }
        return true
    }
    
    func getAllCourses() -> [Course]
    {
        var courses : [Course] = []
        if let response = courseRepo.getAll()
        {
            response.forEach({ (cdCourse) in
                courses.append(convertToCourse(cdCourse))
            })
        }
        return courses
    }
    
    func getRoster(course_nbr : Int32) -> [Student]
    {
        var roster : [Student] = []

        if let response = courseRepo.getStudents(course_nbr: course_nbr)
        {
            response.forEach({ (cdStudent) in
                roster.append(Student(name: cdStudent.name!, erp: cdStudent.erp, sessionsMissed: cdStudent.studentsToAttendance?.count ?? 0))
            })
        }
            
        return roster
    }
    
    func getSessions(course_nbr : Int32) -> [Session]
    {
        var sessions : [Session] = []

        if let response = courseRepo.getSessions(course_nbr: course_nbr)
        {
            response.forEach({ (cdAttendance) in
                sessions.append(Session(id: cdAttendance.id, date: cdAttendance.date!))
            })
        }
            
        return sessions
    }
    
    func addSession(course_nbr : Int32, session:Session, absentees: [Int32]) -> Bool
    {
        if (courseRepo.addSession(course_nbr: course_nbr, session: session, absentees: absentees))
        {
            return true
        }
        else
        {
            debugPrint("Error recording attendance for \(session.date)")
            return false
        }
    }
    
    //converts the Core Data instance of Courses into Course class
    func convertToCourse(_ course: Courses) -> Course
    {
        return Course(
            course_nbr: course.class_nbr,
            semester: course.semester!,
            course_name: course.course_name!,
            attendance_req: course.attendance_requirement,
            totalStudents: course.coursesToStudents?.count ?? 0,
            totalSessions: course.coursesToAttendance?.count ?? 0
        )
    }
}
