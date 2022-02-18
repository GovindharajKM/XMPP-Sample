//
//  ContactSync.swift
//  XMPP-Sample
//
//  Created by Govindharaj Murugan on 18/02/22.
//  Copyright © 2022 Govind+Vaishu. All rights reserved.
//

import Foundation
import ContactsUI

public class ContactSync {

    func fetchPhoneContacts() -> [PhoneContact] {
        
        let contactStore = CNContactStore()
        var arrContats = [PhoneContact]()

        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactImageDataKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        
           do {
               try contactStore.enumerateContacts(with: request) { (contact, stop) in
                   let contac = PhoneContact.init(contact: contact)
                   arrContats.append(contac)
               }
           }
           catch {
               print("unable to fetch contacts")
           }
        return arrContats
    }
}

public class PhoneContact: NSObject {

    var name: String?
    var avatarData: Data?
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
    var isSelected: Bool = false
    var isInvited = false

    init(contact: CNContact) {
        self.name        = contact.givenName + " " + contact.familyName
        self.avatarData  = contact.imageData
        for phone in contact.phoneNumbers {
            self.phoneNumber.append(phone.value.stringValue)
        }
        for mail in contact.emailAddresses {
            self.email.append(mail.value as String)
        }
    }

    override init() {
        super.init()
    }
}

enum ContactsFilter {
    case none
    case mail
    case message
}
