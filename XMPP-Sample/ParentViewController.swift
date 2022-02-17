//
//  ParentViewController.swift
//  XMPPSample
//
//  Created by Govindharaj Murugan on 17/02/22.
//

import UIKit
import XMPPFramework


class ParentViewController: UIViewController {
    
   /* @IBOutlet weak var tableViewList: UITableView!
    var onlineBuddies = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        XMPPManager.shared.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "userID") != nil {
            if XMPPManager.shared.connect() {
                self.title = XMPPManager.shared.xmppStream.myJID?.bare
                XMPPManager.shared.xmppRoster.fetch()
            }
        } else {
            self.performSegue(withIdentifier: "Home.To.Login", sender: self)
        }
    }
    
   
}

extension ParentViewController : ChatDelegate {
    
    func buddyWentOnline(name: String) {
        if !self.onlineBuddies.contains(name) {
            self.onlineBuddies.add(name)
            self.tableViewList.reloadData()
        }
    }
    
    func buddyWentOffline(name: String) {
        self.onlineBuddies.remove(name)
        self.tableViewList.reloadData()
    }
    
    func didDisconnect() {
        self.onlineBuddies.removeAllObjects()
        self.tableViewList.reloadData()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ParentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.onlineBuddies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        cell.textLabel?.text = self.onlineBuddies[indexPath.row] as? String
        
        return cell
    }
    */
    
}

