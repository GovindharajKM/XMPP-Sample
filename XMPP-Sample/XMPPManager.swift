//
//  XMPPManager.swift
//  XMPP-Sample
//
//  Created by Govindharaj Murugan on 17/02/22.
//

import UIKit
import XMPPFramework

protocol ChatDelegate {
    func buddyWentOnline(name: String)
    func buddyWentOffline(name: String)
    func didDisconnect()
}

class XMPPManager: NSObject {

    static let shared = XMPPManager()
    var delegate:ChatDelegate! = nil
    let xmppStream = XMPPStream()
    let xmppRosterStorage = XMPPRosterCoreDataStorage()
    var xmppRoster: XMPPRoster
    
//    let domain = "991@modefin.eastasia.cloudapp.azure.com/modefin"
    let hostName = "991@modefin.eastasia.cloudapp.azure.com/modefin"
    let userJID = "991"
    let hostPort = 5222
    let password = "121"
    
    override init() {
//        self.xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
        // Stream Configuration
//        self.xmppStream = XMPPStream()
//        self.xmppStream.hostName = hostName
//        self.xmppStream.hostPort = UInt16(hostPort)
//        self.xmppStream.startTLSPolicy = XMPPStreamStartTLSPolicy.allowed
//        self.xmppStream.myJID = XMPPJID(string: self.userJID)
        
        self.xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
    }
    
    public func connectStream() {
        self.setupStream()
    }
    
     func setupStream() {
        self.xmppRoster.activate(xmppStream)
        self.xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
        self.xmppRoster.addDelegate(self, delegateQueue: DispatchQueue.main)

    }
    
    private func goOnline() {
        let presence = XMPPPresence()
        let domain = self.xmppStream.myJID?.domain
        
        if domain == "gmail.com" || domain == "gtalk.com" || domain == "talk.google.com" {
            let priority = DDXMLElement.element(withName: "priority", stringValue: "24") as! DDXMLElement
            presence.addChild(priority)
        }
        self.xmppStream.send(presence)
    }
    
    private func goOffline() {
        let presence = XMPPPresence(type: "unavailable")
        self.xmppStream.send(presence)
    }
    
    func connect() -> Bool {
        if !self.xmppStream.isConnected {
            let jabberID = UserDefaults.standard.value(forKey: "userID")
            let myPassword = UserDefaults.standard.value(forKey: "userPassword")
            
            if !self.xmppStream.isDisconnected {
                return true
            }
            if jabberID == nil && myPassword == nil {
                return false
            }
            
            self.xmppStream.hostName = hostName
            self.xmppStream.hostPort = UInt16(hostPort)
            self.xmppStream.startTLSPolicy = XMPPStreamStartTLSPolicy.allowed
            self.xmppStream.myJID = XMPPJID(string: self.userJID)
            
            do {
                try self.xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
                print("Connection success")
                return true
            } catch {
                print("Something went wrong!")
                return false
            }
        } else {
            return true
        }
    }
    
    fileprivate func authentictae() {
        do {
            try self.xmppStream.authenticate(withPassword: self.password)
        }
        catch {
            print("not authenticate")
        }
    }

    
    func disconnect() {
        self.goOffline()
        self.xmppStream.disconnect()
    }
    
}

//MARK: - Messaging
extension XMPPManager {
    
    func sendMessage(_ message: String) {
        let xMessage = XMPPMessage(type: "chat", to: XMPPJID(string: "992"))
        xMessage.addBody(message)
        xMessage.addOriginId(self.xmppStream.generateUUID)
        self.xmppStream.send(xMessage)
    }
}


//Mark: -  XMPPRosterDelegate, XMPPStreamDelegate
extension XMPPManager : XMPPRosterDelegate, XMPPStreamDelegate {
    
    func xmppStreamDidConnect(sender: XMPPStream!) {
        do {
            try self.xmppStream.authenticate(withPassword: UserDefaults.standard.value(forKey: "userPassword") as! String)
        } catch {
            print("Could not authenticate")
        }
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        self.goOnline()
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveIQ iq: XMPPIQ!) -> Bool {
        print("Did receive IQ")
        return false
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        print("Did receive message \(String(describing: message))")
    }
    
    func xmppStream(sender: XMPPStream!, didSendMessage message: XMPPMessage!) {
        print("Did send message \(String(describing: message))")
    }
    
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        let presenceType = presence.type
        let myUsername = sender.myJID?.user
        let presenceFromUser = presence.from?.user
        
        if presenceFromUser != myUsername {
            print("Did receive presence from \(String(describing: presenceFromUser))")
            if presenceType == "available" {
//                delegate.buddyWentOnline(name: "\(String(describing: presenceFromUser))@gmail.com")
            } else if presenceType == "unavailable" {
                delegate.buddyWentOffline(name: "\(String(describing: presenceFromUser))@gmail.com")
            }
        }
    }
    
    func xmppRoster(_ sender: XMPPRoster, didReceiveRosterItem item: DDXMLElement) {
        print("Did receive Roster item")
    }
}


//MARK: - XMPPOutgoingFileTransferDelegate
extension XMPPManager : XMPPOutgoingFileTransferDelegate {
    
    func xmppOutgoingFileTransfer(_ sender: XMPPOutgoingFileTransfer!, didFailWithError error: Error!) {
        debugPrint(#function)
    }
    
    func xmppOutgoingFileTransferDidSucceed(_ sender: XMPPOutgoingFileTransfer!) {
        debugPrint(#function)
    }
    
    func xmppOutgoingFileTransferIBBClosed(_ sender: XMPPOutgoingFileTransfer!) {
        debugPrint(#function)
    }
 
}



//    [16:09, 17/02/2022] Suneel: in connect
//    991@modefin.eastasia.cloudapp.azure.com
//    [16:10, 17/02/2022] Suneel: 991@modefin.eastasia.cloudapp.azure.com/modefin
//    [16:11, 17/02/2022] Suneel: this is called JID , 991 is the user  modefin.eastasia.cloudapp.azure.com is domain and modefin is the resource
