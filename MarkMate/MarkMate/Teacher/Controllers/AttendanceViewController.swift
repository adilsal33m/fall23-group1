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
    var attendanceView: ViewController1!
    override func viewDidLoad() {
        super.viewDidLoad()
        segView.isUserInteractionEnabled = true
        segView.autoresizesSubviews = true
        attendanceView = ViewController1()
        segView.addSubview(attendanceView.view)
        attendanceView.myPeerID = MCPeerID(displayName: "Teacher "+UIDevice.current.name)
        
        attendanceView.session = MCSession(peer: attendanceView.myPeerID, securityIdentity: nil, encryptionPreference: .required)
        attendanceView.session.delegate = attendanceView
        
        if let currentCalendar = attendanceView.currentCalendar {
            attendanceView.monthLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
    }
    @IBAction func segmentValueChanged(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            segView.bringSubviewToFront(attendanceView.view)
            break
        default:
            break
        }
    }
}



