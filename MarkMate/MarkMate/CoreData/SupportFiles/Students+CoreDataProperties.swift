//
//  Students+CoreDataProperties.swift
//  MarkMate
//
//  Created by Macbook on 22/11/2023.
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
    @NSManaged public var studentsToAttendance: NSSet?
    @NSManaged public var studentsToCourses: Courses?

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
