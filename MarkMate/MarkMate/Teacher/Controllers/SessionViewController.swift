//
//  SessionViewController.swift
//  MarkMate
//
//  Created by Abdur Rafae on 01/12/2023.
//

import UIKit

class Counter {
    static let shared = Counter()
    var timer: Timer?
    let initialCountdownTime: TimeInterval = 300  // 5 minutes in this example
    var remainingTime: TimeInterval = 300
    var updateClosure: ((String) -> Void)?

    private init() {}

    func startTimer(updateClosure: @escaping (String) -> Void) {
        self.updateClosure = updateClosure
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }

    @objc func updateTimer() {
        remainingTime -= 1
        let formattedTime = updateCountdownLabel()
        updateClosure?(formattedTime)

        if remainingTime == 0 {
            timer?.invalidate()
            timer = nil
            remainingTime = initialCountdownTime
            NotificationCenter.default.post(name: .timeOverNotification, object: nil)
        }
    }

    func updateCountdownLabel() -> String {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

class SessionViewController: UIViewController {
    static var totalCount = 0
    static var markedCount = 0
    
    @IBAction func finishAttendance(_ sender: Any) {
        NotificationCenter.default.post(name: .forceEndSessionNotification, object: nil)
        timer!.remainingTime = timer!.initialCountdownTime
        timer = nil
        navigationController?.popViewController(animated: true)
    }
    
    var timer: Counter?

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var menuBar: UIView!
    @IBOutlet weak var UnMarkedLabel: UILabel!
    @IBOutlet weak var MarkedLabel: UILabel!
    @IBOutlet weak var TotalCountLabel: UILabel!
    @IBOutlet weak var CountView: UIView!
    @IBOutlet weak var Timer: TimerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var unmarkedCount = SessionViewController.totalCount - SessionViewController.markedCount
        TotalCountLabel.text = "\(SessionViewController.totalCount)"
        MarkedLabel.text = "\(SessionViewController.markedCount)"
        UnMarkedLabel.text = "\(unmarkedCount)"
        UnMarkedLabel.textColor = .red
        MarkedLabel.textColor = menuBar.backgroundColor
        TotalCountLabel.textColor = menuBar.backgroundColor
        Timer.backgroundColor = .clear//outside the circle
        Timer.addDashedCircle()
        CountView.layer.cornerRadius = 10
        CountView.layer.masksToBounds = true
        CountView.layer.borderColor = UIColor.black.cgColor
        CountView.layer.borderWidth = 1.0
        CountView.layer.shadowColor = UIColor.black.cgColor
        CountView.layer.shadowOpacity = 0.8
        CountView.layer.shadowOffset = CGSize(width: 2, height: 5)
        CountView.layer.shadowRadius = 5.0
        CountView.clipsToBounds = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAttendanceOverNotification), name: .attendanceOverNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewStudent), name: .newAttendanceReceived, object: nil)
        
        
        timer = Counter.shared

        timer?.startTimer { [weak self] formattedTime in
            self?.timerLabel.text = formattedTime
        }
    }
    
    @objc func handleNewStudent() {
        SessionViewController.markedCount = Int(self.MarkedLabel.text!)!
        SessionViewController.markedCount+=1
        self.MarkedLabel.text = "\(SessionViewController.markedCount)"
    }
    
    @objc func handleAttendanceOverNotification() {
        timer!.remainingTime = timer!.initialCountdownTime
        timer = nil
    }
}
