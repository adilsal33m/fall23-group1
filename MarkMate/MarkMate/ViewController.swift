//  ViewController.swift
//  MarkMate
//
//  Created by Macbook on 05/11/2023.
//

import UIKit
import MultipeerConnectivity

enum AccountType {
    case Student, Teacher
}

class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate {

    var myPeerID: MCPeerID!
    var session: MCSession!
    
    var myData: String = ""
    var AdvertiserAssisstant: MCNearbyServiceAdvertiser!
    
    @IBOutlet weak var myLabel: UILabel!

    @IBOutlet weak var Field: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myPeerID = MCPeerID(displayName: UIDevice.current.name)
        
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
    }
    
    func sendData(data : String) {
        if session.connectedPeers.count > 0 {
            if let textData = data.data(using: .utf8){
                do {
                    try session.send(textData, toPeers: session.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    
    func startHosting() {
        AdvertiserAssisstant = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: "demo")
        AdvertiserAssisstant.delegate = self
        AdvertiserAssisstant.startAdvertisingPeer()
    }
    
    func joinSession() {
        let browser = MCBrowserViewController(serviceType: "demo", session: session)
        browser.delegate = self
        present(browser, animated: true)
    }
    
    @IBAction func PressJoin(_ sender: Any) {
        joinSession()
    }
    @IBAction func PressHost(_ sender: Any) {
        print("Hosting now...")
        startHosting()
    }
    @IBAction func PressSend(_ sender: Any) {
        sendData(data: (Field?.text) ?? "Demo" )
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
        if let text = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.myLabel.text = text
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


