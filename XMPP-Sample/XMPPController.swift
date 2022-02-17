//
//  XMPPController.swift
//  CrazyMessages
//
//  Created by Andres on 7/21/16.
//  Copyright © 2016 Andres. All rights reserved.
//

import Foundation
import XMPPFramework

enum XMPPControllerError: Error {
	case wrongUserJID
}

class XMPPController: NSObject {
	
    var xmppStream: XMPPStream
    var delegate:ChatDelegate!
    let xmppRosterStorage = XMPPRosterCoreDataStorage()
    
	let hostName: String
	let userJID: XMPPJID
	let hostPort: UInt16
	let password: String
	
	init(hostName: String, userJIDString: String, hostPort: UInt16 = 5222, password: String) throws {
        guard let userJID = XMPPJID(string: userJIDString) else {
			throw XMPPControllerError.wrongUserJID
		}
		
		self.hostName = hostName
		self.userJID = userJID
		self.hostPort = hostPort
		self.password = password
		
		// Stream Configuration
		self.xmppStream = XMPPStream()
		self.xmppStream.hostName = hostName
		self.xmppStream.hostPort = hostPort
		self.xmppStream.startTLSPolicy = XMPPStreamStartTLSPolicy.allowed
		self.xmppStream.myJID = userJID
		
        super.init()
        
        self.xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
        
	}
	
	func connect() {
        if !self.xmppStream.isDisconnected {
			return
		}

        do {
            try self.xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
            print("Connection success")
        } catch {
            print("Something went wrong!")
        }
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
    
    func disconnect() {
        self.goOffline()
        self.xmppStream.disconnect()
    }
    
}

//MARK: - Messages
extension XMPPController {
    
    func sendMessage(_ message: String) {
        let xMessage = XMPPMessage(type: "chat", to: XMPPJID(string: "992@modefin.eastasia.cloudapp.azure.com"))
        xMessage.addBody(message)
        xMessage.addOriginId(self.xmppStream.generateUUID)
        self.xmppStream.send(xMessage)
    }
}

extension XMPPController: XMPPStreamDelegate, XMPPRosterDelegate {
	
    func xmppStreamDidSecure(_ sender: XMPPStream) {
        print(#function)
    }
    
    func xmppStreamDidRegister(_ sender: XMPPStream) {
        print(#function)
    }
    
    func xmppStreamDidConnect(_ stream: XMPPStream) {
		print("Stream: Connected")
		try! stream.authenticate(withPassword: self.password)
	}
	
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
		self.xmppStream.send(XMPPPresence())
        self.goOnline()
		print("Stream: Authenticated")
	}
	
    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement) {
		print("Stream: Fail to Authenticate")
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
                self.delegate.buddyWentOnline(name: "\(String(describing: presenceFromUser))@gmail.com")
            } else if presenceType == "unavailable" {
                self.delegate.buddyWentOffline(name: "\(String(describing: presenceFromUser))@gmail.com")
            }
        }
    }
    
    func xmppRoster(_ sender: XMPPRoster, didReceiveRosterItem item: DDXMLElement) {
        print("Did receive Roster item")
    }
}


