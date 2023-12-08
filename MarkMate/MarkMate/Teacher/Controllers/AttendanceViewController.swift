//
//  AttendanceViewController.swift
//  MarkMate
//
//  Created by Macbook on 14/11/2023.
//

import UIKit
import MultipeerConnectivity
import CVCalendar


class AttendanceViewController: UIViewController {

    @IBOutlet weak var segView: UIView!
    var sessionInfo: attendanceHistory = attendanceHistory(date: "23 October, 2023", time: "2:55 PM")
    var attendanceView: ViewController1!
    var studentsList: SegStudentViewController!
    var History: segHistoryViewController!
    var selectedStudent: studentCellData = studentCellData(name: "random", percentage: 0, Erp: 0)
    
   override func viewDidLoad() {
       super.viewDidLoad()
       segView.isUserInteractionEnabled = true
       segView.autoresizesSubviews = true
       attendanceView = ViewController1()
       studentsList = SegStudentViewController()
       History = segHistoryViewController()
       segView.addSubview(History.view)
       segView.addSubview(studentsList.view)
       segView.addSubview(attendanceView.view)
       attendanceView.myPeerID = MCPeerID(displayName: "Teacher "+UIDevice.current.name)
       
       attendanceView.session = MCSession(peer: attendanceView.myPeerID, securityIdentity: nil, encryptionPreference: .required)
       attendanceView.session.delegate = attendanceView
       
       if let currentCalendar = attendanceView.currentCalendar {
           attendanceView.monthLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
       }
       NotificationCenter.default.addObserver(self, selector: #selector(handleButtonPressedNotification), name: .buttonPressedNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(handleSelectedStudentNotification(_:)), name: .studentSelected, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(handleSessionSelectedNotification), name: .sessionSelected, object: nil)
       

   }
    
    @objc func handleSessionSelectedNotification(_ notification: Notification) {
        sessionInfo = (notification.userInfo?["sessionInfo"] as? attendanceHistory)!
        performSegue(withIdentifier: "MoveToCourseAttRec", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoveToStudentRecord", let svc = segue.destination as? StudentAttRecordViewController {
            svc.NameLabel = selectedStudent.name
            svc.ERPLabel = "\(selectedStudent.Erp)"
        }
        else if segue.identifier == "MoveToCourseAttRec", let svc = segue.destination as? CourseAttRecordViewController {
            svc.date = sessionInfo.date
            svc.time = sessionInfo.time
        }
    }
    
    @objc func handleSelectedStudentNotification(_ notification: Notification) {
        selectedStudent = (notification.userInfo?["studentInfo"] as? studentCellData)!
        performSegue(withIdentifier: "MoveToStudentRecord", sender: self)
    }

    @objc func handleButtonPressedNotification() {
       performSegue(withIdentifier: "MoveToTimer", sender: self)
    }
   
    @IBAction func segmentValueChanged(_ sender: Any) {
       switch (sender as AnyObject).selectedSegmentIndex {
       case 0:
           segView.bringSubviewToFront(attendanceView.view)
           break
       case 1 :
           segView.bringSubviewToFront(studentsList.view)
           break
       case 2 :
           segView.bringSubviewToFront(History.view)
       default:
           break
       }
    }
}



