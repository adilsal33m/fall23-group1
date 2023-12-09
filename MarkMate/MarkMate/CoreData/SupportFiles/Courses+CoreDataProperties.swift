//
//  Courses+CoreDataProperties.swift
//  MarkMate
//
//  Created by Macbook on 05/12/2023.
//
//

import Foundation
import CoreData


extension Courses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Courses> {
        return NSFetchRequest<Courses>(entityName: "Courses")
    }

    @NSManaged public var class_nbr: Int32
    @NSManaged public var course_name: String?
    @NSManaged public var semester: String?
    @NSManaged public var attendance_requirement: Int32
    @NSManaged public var coursesToAttendance:Set<Attendance>?
    @NSManaged public var coursesToStudents: Set<Students>?

}

// MARK: Generated accessors for coursesToAttendance
extension Courses {

    @objc(addCoursesToAttendanceObject:)
    @NSManaged public func addToCoursesToAttendance(_ value: Attendance)

    @objc(removeCoursesToAttendanceObject:)
    @NSManaged public func removeFromCoursesToAttendance(_ value: Attendance)

    @objc(addCoursesToAttendance:)
    @NSManaged public func addToCoursesToAttendance(_ values: Set<Attendance>)

    @objc(removeCoursesToAttendance:)
    @NSManaged public func removeFromCoursesToAttendance(_ values: Set<Attendance>)

}

// MARK: Generated accessors for coursesToStudents
extension Courses {

    @objc(addCoursesToStudentsObject:)
    @NSManaged public func addToCoursesToStudents(_ value: Students)

    @objc(removeCoursesToStudentsObject:)
    @NSManaged public func removeFromCoursesToStudents(_ value: Students)

    @objc(addCoursesToStudents:)
    @NSManaged public func addToCoursesToStudents(_ values: Set<Students>)

    @objc(removeCoursesToStudents:)
    @NSManaged public func removeFromCoursesToStudents(_ values: Set<Students>)

}

extension Courses : Identifiable {

}
