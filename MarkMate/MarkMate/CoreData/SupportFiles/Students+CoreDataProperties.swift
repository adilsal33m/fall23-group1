//
//  Students+CoreDataProperties.swift
//  MarkMate
//
//  Created by Macbook on 13/11/2023.
//
//

import Foundation
import CoreData


extension Students {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Students> {
        return NSFetchRequest<Students>(entityName: "Students")
    }

    @NSManaged public var erp: Int32
    @NSManaged public var name: String?
    @NSManaged public var studentsToCourses: NSSet?
    @NSManaged public var studentsToAttendance: NSSet?

}

// MARK: Generated accessors for studentsToCourses
extension Students {

    @objc(addStudentsToCoursesObject:)
    @NSManaged public func addToStudentsToCourses(_ value: Courses)

    @objc(removeStudentsToCoursesObject:)
    @NSManaged public func removeFromStudentsToCourses(_ value: Courses)

    @objc(addStudentsToCourses:)
    @NSManaged public func addToStudentsToCourses(_ values: NSSet)

    @objc(removeStudentsToCourses:)
    @NSManaged public func removeFromStudentsToCourses(_ values: NSSet)

}

// MARK: Generated accessors for studentsToAttendance
extension Students {

    @objc(addStudentsToAttendanceObject:)
    @NSManaged public func addToStudentsToAttendance(_ value: Attendance)

    @objc(removeStudentsToAttendanceObject:)
    @NSManaged public func removeFromStudentsToAttendance(_ value: Attendance)

    @objc(addStudentsToAttendance:)
    @NSManaged public func addToStudentsToAttendance(_ values: NSSet)

    @objc(removeStudentsToAttendance:)
    @NSManaged public func removeFromStudentsToAttendance(_ values: NSSet)

}

extension Students : Identifiable {

}
