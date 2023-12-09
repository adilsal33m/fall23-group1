//
//  AttendanceViewController.swift
//  MarkMate
//
//  Created by Macbook on 14/11/2023.
//

import UIKit
import MultipeerConnectivity

struct studentInfo: Codable{
    let name: String
    let ERP: String
    var uuid: String = UIDevice.current.identifierForVendor!.uuidString
}

class MarkViewController: UIViewController , MCSessionDelegate, MCBrowserViewControllerDelegate{
   
    let myData = studentInfo(name: "Abdur Rafae", ERP: "22828")
    
    let encoder = JSONEncoder()
    var myPeerID: MCPeerID!
    var session: MCSession!

    var AdvertiserAssisstant: MCNearbyServiceAdvertiser!
    
    @IBOutlet weak var myLabel: UILabel!

    @IBOutlet weak var Field: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myPeerID = MCPeerID(displayName: "Student "+UIDevice.current.name)
        
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
    }
    
    func sendData(data : studentInfo) throws {
        let jsonData = try encoder.encode(data)
        var teacher: MCPeerID!
        for peer in session.connectedPeers {
            if peer.displayName.hasPrefix("Teacher") {
                teacher = peer
                break
            }
        }
        if session.connectedPeers.count > 0 {
            do {
                try session.send(jsonData, toPeers: [teacher], with: .reliable)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func joinSession() {
        let browser = MCBrowserViewController(serviceType: "MarkMateSession", session: session)
        browser.delegate = self
        present(browser, animated: true)
    }
    
    @IBAction func PressJoin(_ sender: Any) {
        joinSession()
    }

    @IBAction func PressSend(_ sender: Any) {
        do{
            try sendData(data: myData)
        } catch {
            
        }
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
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let text = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.myLabel.text = text
                print(text)
            }
        }
        session.disconnect()
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }

}
