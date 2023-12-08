//
//  NotificationNames.swift
//  MarkMate
//
//  Created by Abdur Rafae on 01/12/2023.
//

import Foundation

extension Notification.Name {
    static let buttonPressedNotification = Notification.Name("ButtonPressedNotification")
    static let timeOverNotification = Notification.Name("TimeOverNotification")
    static let attendanceOverNotification = Notification.Name("AttendanceOverNotification")
    static let studentSelected = Notification.Name("StudentSelectedNotification")
    static let sessionSelected = Notification.Name("SessionSelectedNotification")
    static let forceEndSessionNotification = Notification.Name("ForceEndSessionNotification")
    static let newAttendanceReceived = Notification.Name("NewAttendanceReceived")
    static let newCourseAdded = Notification.Name("NewCourseAdded")
    static let studentCountSending = Notification.Name("StudentCountSendingNotification")
    static let teacherHomeScreenMovement = Notification.Name("TeacherHomeScreenRequired")
}
