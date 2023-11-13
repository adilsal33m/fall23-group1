//
//  Attendance+CoreDataProperties.swift
//  MarkMate
//
//  Created by Macbook on 13/11/2023.
//
//

import Foundation
import CoreData


extension Attendance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attendance> {
        return NSFetchRequest<Attendance>(entityName: "Attendance")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var attendanceToCourses: Courses?
    @NSManaged public var attendanceToStudents: Students?

}

extension Attendance : Identifiable {

}
