//
//  AttendanceViewController.swift
//  MarkMate
//
//  Created by Macbook on 14/11/2023.
//

import UIKit
import MultipeerConnectivity

class MarkViewController: UIViewController , MCSessionDelegate, MCBrowserViewControllerDelegate{
   
    
    
    
    var myPeerID: MCPeerID!
    var session: MCSession!
    
    var myData: String = ""
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
    
    func sendData(data : String) {
        var teacher: MCPeerID!
        for peer in session.connectedPeers {
            if peer.displayName.hasPrefix("Teacher") {
                teacher = peer
                break
            }
        }
        if session.connectedPeers.count > 0 {
            if let textData = data.data(using: .utf8){
                do {
                    try session.send(textData, toPeers: [teacher], with: .reliable)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
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
        sendData(data: (Field?.text) ?? "Demo" )
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
