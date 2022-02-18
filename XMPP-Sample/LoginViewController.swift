//
//  ViewController.swift
//  XMPP-Sample
//
//  Created by Govindharaj Murugan on 17/02/22.
//  Copyright © 2022 Govind+Vaishu. All rights reserved.
//


import UIKit
import XMPPFramework

class LoginViewController: UIViewController {
    
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSendMessge: UIButton!
    @IBOutlet weak var barBtnContact: UIBarButtonItem!
    
    let server = "modefin.eastasia.cloudapp.azure.com"
    let userJID = "991@modefin.eastasia.cloudapp.azure.com/modefin"
    let pwd = "121"
    
    var xmppController: XMPPController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func btnLogin(sender: AnyObject) {
        UserDefaults.standard.set(self.userJID, forKey: "userID")
        UserDefaults.standard.set(self.pwd, forKey: "userPassword")
        
        do {
            try self.xmppController = XMPPController(hostName: self.server, userJIDString: self.userJID, password: self.pwd)
            self.xmppController.xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
//            self.xmppController.delegate = self
            self.xmppController.connect()
        } catch {
            print("Something went wrong")
        }
        
    }
    @IBAction func btnSendMessge_Click(_ sender: Any) {
        self.xmppController.sendMessage("Message from Govind to Suneel")
    }
    
    @IBAction func barBtnContact_Click(_ sender: Any) {
        let arrContacts = ContactSync().fetchPhoneContacts()
        debugPrint(arrContacts)
    }
    
}


//extension LoginViewController : ChatDelegate {
//
//    func buddyWentOnline(name: String) {
//        print(#function)
////        if !self.onlineBuddies.contains(name) {
////            self.onlineBuddies.add(name)
////            self.tableViewList.reloadData()
////        }
//    }
//
//    func buddyWentOffline(name: String) {
//        print(#function)
////        self.onlineBuddies.remove(name)
////        self.tableViewList.reloadData()
//    }
//
//    func didDisconnect() {
//        print(#function)
////        self.onlineBuddies.removeAllObjects()
////        self.tableViewList.reloadData()
//    }
//}
