//
//  ViewController1.swift
//  MarkMate
//
//  Created by Macbook on 14/11/2023.
//

import UIKit
import MultipeerConnectivity
import CVCalendar

struct courseInfo: Codable {
    var courseTitle: String
    var courseERP: Int
    var totalClasses: Int
    var classesAttended: Int
}


struct ColorsConfig {
   static let selectedText = UIColor.white
   static let text = UIColor.black
   static let textDisabled = UIColor.gray
   static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0)
   static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
   static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
   static let sundaySelectionBackground = sundayText
}

class ViewController1: UIViewController , MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var receivedAttendance: [studentInfo] = []
   
   @IBAction func loadPrevious(sender: AnyObject) {
       calendarView.loadPreviousView()
   }
   
   
   @IBAction func loadNext(sender: AnyObject) {
       calendarView.loadNextView()
   }

   @IBOutlet weak var calendarView: CVCalendarView!
   @IBOutlet weak var menuView: CVCalendarMenuView!
   let encoder = JSONEncoder()
   public var myPeerID: MCPeerID!
   public var session: MCSession!
   @IBOutlet weak var monthLabel: UILabel!
   public var shouldShowDaysOut = true
   public var animationFinished = true
   public var selectedDay: DayView!
   public var currentCalendar: Calendar?
   
   var myData: courseInfo = courseInfo(courseTitle: "IOS DEV", courseERP: 3456, totalClasses: 23, classesAttended: 20)
   
   override func awakeFromNib() {
       let timeZoneBias = 480 // (UTC+08:00)
       currentCalendar = Calendar(identifier: .gregorian)
       currentCalendar?.locale = Locale(identifier: "fr_FR")
       if let timeZone = TimeZone(secondsFromGMT: -timeZoneBias * 60) {
           currentCalendar?.timeZone = timeZone
       }
   }
   
   
   var AdvertiserAssisstant: MCNearbyServiceAdvertiser!
   
   @IBOutlet weak var statusLabel: UILabel!
   @IBOutlet weak var myLabel: UILabel!

   @IBOutlet weak var Field: UITextField!
   
   override func viewDidLoad() {
       super.viewDidLoad()

       NotificationCenter.default.addObserver(self, selector: #selector(handleTimeOverNotification), name: .timeOverNotification, object: nil)
       
       NotificationCenter.default.addObserver(self, selector: #selector(handleForcedEndSession), name: .forceEndSessionNotification, object: nil)
   }
    
    @objc func handleForcedEndSession() {
        AdvertiserAssisstant.stopAdvertisingPeer()
        session.disconnect()
        print("Stopped Hosting...")
        statusLabel.text = "Inactive"
        statusLabel.textColor = .red
    }
   
   @objc func handleTimeOverNotification() {
       AdvertiserAssisstant.stopAdvertisingPeer()
       session.disconnect()
       print("Stopped Hosting...")
       statusLabel.text = "Inactive"
       statusLabel.textColor = .red
   }
   
   override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
       menuView.commitMenuViewUpdate()
       calendarView.commitCalendarViewUpdate()
   }
   
   func sendData(data : courseInfo, peer: MCPeerID) throws {
       let jsonData = try encoder.encode(myData)
       if session.connectedPeers.count > 0 {
           do {
               try session.send(jsonData, toPeers: [peer], with: .reliable)
           } catch let error as NSError {
               print(error.localizedDescription)
           }
       }
   }
    
    func sendProxyDetected(data: String, peer: MCPeerID) throws {
        let jsonData = try encoder.encode(data)
        do {
            try session.send(jsonData, toPeers: [peer], with: .reliable)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func sendEnrollmentRequirement(data: String, peer: MCPeerID) throws {
        let jsonData = try encoder.encode(data)
        do {
            try session.send(jsonData, toPeers: [peer], with: .reliable)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
   
   
   
   func startHosting() {
       AdvertiserAssisstant = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: "MarkMateSession")
       AdvertiserAssisstant.delegate = self
       AdvertiserAssisstant.startAdvertisingPeer()
       statusLabel.text = "Active"
       statusLabel.textColor = .green
   }
   
   @IBAction func StartAttendance(_ sender: Any) {
       print("Hosting now...")
       startHosting()
       NotificationCenter.default.post(name: .buttonPressedNotification, object: nil)
   }
   
   @IBAction func FinishAttendance(_ sender: Any) {
       AdvertiserAssisstant.stopAdvertisingPeer()
       session.disconnect()
       NotificationCenter.default.post(name: .attendanceOverNotification, object: nil)
       print("Stopped Hosting...")
       statusLabel.text = "Inactive"
       statusLabel.textColor = .red
   }
   
   
   func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
       switch state {
       case MCSessionState.connected:
           print("Connected: \(myPeerID.displayName)")
           
       case MCSessionState.connecting:
           print("Connecting: \(myPeerID.displayName)")
           
       case MCSessionState.notConnected:
           print("Not Connected: \(myPeerID.displayName)")
       @unknown default:
           fatalError()
       }
   }
   
   func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
       if let text = String(data: data, encoding: .utf8),
          let jsonData = text.data(using: .utf8),
          let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
           
           let name = json["name"] as? String ?? ""
           let erp = json["ERP"] as? String ?? ""
           let uuid = json["uuid"] as? String ?? ""

           let newStudent = studentInfo(name: name, ERP: erp, uuid: uuid)
           var studentEnrolled = true
           // MARK: PERFORM CHECK HERE
           var proxy = false
           
           if studentEnrolled == true {
               DispatchQueue.main.async {
                   for student in self.receivedAttendance {
                       if student.uuid == newStudent.uuid {
                           proxy = true
                           print("detected")
                           break
                       }
                   }
                   if proxy == false {
                       self.receivedAttendance.append(newStudent)
                       NotificationCenter.default.post(name: .newAttendanceReceived, object: nil)
                   }
               }
               if proxy == false {
                   do {
                       try sendData(data: myData, peer: peerID)
                   } catch {
                       
                   }
               }
               else {
                   do {
                       try sendProxyDetected(data: "Proxy is not permitted", peer: peerID)
                   } catch {
                       
                   }
               }
           }
           else{
               do {
                   try sendEnrollmentRequirement(data: "You are not enrolled in this course. Kindly ask the teacher to enroll you.", peer: peerID)
               } catch {
                   
               }
           }

           
       }
   }
   
   func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
       
   }
   
   func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
       
   }
   
   func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

   }
   
   func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
       dismiss(animated: true)
   }
   
   func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
       dismiss(animated: true)
   }
   
   func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
       invitationHandler(true, session)
   }

}

extension ViewController1: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
   func presentationMode() -> CVCalendar.CalendarMode {
       return .monthView
   }
   
   func firstWeekday() -> CVCalendar.Weekday {
       return .saturday
   }
   
   // MARK: Optional methods
   
   func calendar() -> Calendar? { return currentCalendar }
   
   func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
       return weekday == .sunday ? UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0) : UIColor.white
   }
   
   func shouldShowWeekdaysOut() -> Bool { return shouldShowDaysOut }
   
   // Defaults to true
   func shouldAnimateResizing() -> Bool { return true }
   
   private func shouldSelectDayView(dayView: DayView) -> Bool {
       return arc4random_uniform(3) == 0 ? true : false
   }
   
   func shouldAutoSelectDayOnMonthChange() -> Bool { return true }
   
   func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
       selectedDay = dayView
       print(selectedDay.date.commonDescription)
   }
   
   
   func presentedDateUpdated(_ date: CVDate) {
       if monthLabel.text != date.globalDescription && self.animationFinished {
           let updatedMonthLabel = UILabel()
           updatedMonthLabel.textColor = monthLabel.textColor
           updatedMonthLabel.font = monthLabel.font
           updatedMonthLabel.textAlignment = .center
           updatedMonthLabel.text = date.globalDescription
           updatedMonthLabel.sizeToFit()
           updatedMonthLabel.alpha = 0
           updatedMonthLabel.center = self.monthLabel.center
           
           let offset = CGFloat(48)
           updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
           updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
           
           UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
               self.animationFinished = false
               self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
               self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
               self.monthLabel.alpha = 0
               
               updatedMonthLabel.alpha = 1
               updatedMonthLabel.transform = CGAffineTransform.identity
               
           }) { _ in
               
               self.animationFinished = true
               self.monthLabel.frame = updatedMonthLabel.frame
               self.monthLabel.text = updatedMonthLabel.text
               self.monthLabel.transform = CGAffineTransform.identity
               self.monthLabel.alpha = 1
               updatedMonthLabel.removeFromSuperview()
           }
           
           self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
       }
   }
   
   func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool { return true }
   
   func shouldHideTopMarkerOnPresentedView() -> Bool {
       return true
   }
   
   func weekdaySymbolType() -> WeekdaySymbolType { return .short }
   
   func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
       return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
   }
   
   func shouldShowCustomSingleSelection() -> Bool { return false }
   
   func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
       let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
       circleView.fillColor = .colorFromCode(0xCCCCCC)
       return circleView
   }
   
   func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
       if (dayView.isCurrentDay) {
           return true
       }
       return false
   }

   
   func dayOfWeekTextColor() -> UIColor { return .white }
   
   func dayOfWeekBackGroundColor() -> UIColor { return .orange }
   
   //func disableScrollingBeforeDate() -> Date { return Date() }
   
   //func maxSelectableRange() -> Int { return 14 }
   
   //func earliestSelectableDate() -> Date { return Date() }
   
   func latestSelectableDate() -> Date {
       var dayComponents = DateComponents()
       dayComponents.day = 70
       let calendar = Calendar(identifier: .gregorian)
       if let lastDate = calendar.date(byAdding: dayComponents, to: Date()) {
           return lastDate
       }
       
       return Date()
   }
}

// MARK: - CVCalendarViewAppearanceDelegate

extension ViewController1: CVCalendarViewAppearanceDelegate {
   
   func dayLabelWeekdayDisabledColor() -> UIColor { return .lightGray }
   
   func dayLabelPresentWeekdayInitallyBold() -> Bool { return false }
   
   func spaceBetweenDayViews() -> CGFloat { return 0 }
   
   func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.systemFont(ofSize: 14) }
   
   func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
       switch (weekDay, status, present) {
       case (_, .selected, _), (_, .highlighted, _): return ColorsConfig.selectedText
       case (.sunday, .in, _): return ColorsConfig.sundayText
       case (.sunday, _, _): return ColorsConfig.sundayTextDisabled
       case (_, .in, _): return ColorsConfig.text
       default: return ColorsConfig.textDisabled
       }
   }
   
   func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
       switch (weekDay, status, present) {
       case (.sunday, .selected, _), (.sunday, .highlighted, _): return ColorsConfig.sundaySelectionBackground
       case (_, .selected, _), (_, .highlighted, _): return ColorsConfig.selectionBackground
       default: return nil
       }
   }
}

extension ViewController1 {
   func toggleMonthViewWithMonthOffset(offset: Int) {
       guard let currentCalendar = currentCalendar else { return }
       
       var components = Manager.componentsForDate(Date(), calendar: currentCalendar) // from today
       
       components.month! += offset
       
       let resultDate = currentCalendar.date(from: components)!
       
       self.calendarView.toggleViewWithDate(resultDate)
   }
   
   
   func didShowNextMonthView(_ date: Date) {
       guard let currentCalendar = currentCalendar else { return }
       
       let components = Manager.componentsForDate(date, calendar: currentCalendar) // from today
       
       print("Showing Month: \(components.month!)")
   }
   
   
   func didShowPreviousMonthView(_ date: Date) {
       guard let currentCalendar = currentCalendar else { return }
       
       let components = Manager.componentsForDate(date, calendar: currentCalendar) // from today
       
       print("Showing Month: \(components.month!)")
   }
   
}

