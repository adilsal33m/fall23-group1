//
//  AttendanceViewController.swift
//  MarkMate
//
//  Created by Macbook on 14/11/2023.
//

import UIKit
import MultipeerConnectivity

struct courseInfo: Codable {
    var courseTitle: String
    var courseERP: Int
    var attendance_record: [Int]
}

class AttendanceViewController: UIViewController , MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate {
    
    let encoder = JSONEncoder()
    var myPeerID: MCPeerID!
    var session: MCSession!
    
    var myData: courseInfo = courseInfo(courseTitle: "IOS DEV", courseERP: 3456, attendance_record: [23, 234, 23, 234, 23])
    
    
    
    var AdvertiserAssisstant: MCNearbyServiceAdvertiser!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var myLabel: UILabel!

    @IBOutlet weak var Field: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myPeerID = MCPeerID(displayName: "Teacher "+UIDevice.current.name)
        
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
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
    
    
    
    func startHosting() {
        AdvertiserAssisstant = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: "MarkMateSession")
        AdvertiserAssisstant.delegate = self
        AdvertiserAssisstant.startAdvertisingPeer()
        statusLabel.text = "Active"
        statusLabel.textColor = .green
    }
    
//    func joinSession() {
//        let browser = MCBrowserViewController(serviceType: "demo", session: session)
//        browser.delegate = self
//        present(browser, animated: true)
//    }
    
//    @IBAction func PressJoin(_ sender: Any) {
//        joinSession()
//    }
    
    @IBAction func StartAttendance(_ sender: Any) {
        print("Hosting now...")
        startHosting()
    }
    
    @IBAction func FinishAttendance(_ sender: Any) {
        session.disconnect()
        print("Stopped Hosting...")
        statusLabel.text = "Inactive"
        statusLabel.textColor = .red
    }
    
//    @IBAction func PressSend(_ sender: Any) {
//        sendData(data: (Field?.text) ?? "Demo" )
//    }
    
    
    
    
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
        if let text = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.myLabel.text = text
            }
        }
        do{
            try sendData(data: myData, peer: peerID)
        } catch {
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
