//
//  Contact.swift
//  icollect
//
//  Created by user231414 on 2/25/23.
//

import UIKit
import MessageUI

class Contact: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    

    
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var subject: UITextField!
    var toast: Toast! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toast = Toast(view: view)
    }
    
    @IBAction func send(_ sender: Any) {
        if name.text == "" {
            toast.showToast(message: "Please Enter Name")
        }
        else if email.text == "" {
            toast.showToast(message: "Please Enter Email")
        }
        else if subject.text == "" {
            toast.showToast(message: "Please Enter Subject")
        }
        else if desc.text == "" {
            toast.showToast(message: "Please Enter Desctiption")
        }
        else {
            if MFMailComposeViewController.canSendMail() {
                let vc = MFMailComposeViewController()
                vc.delegate = self
                vc.setSubject( "Feedback: \(String(describing: subject.text))")
                vc.setToRecipients(["jksapps246@gmail.com"])
                vc.setMessageBody(
                    "<h1>Name: \(String(describing: name.text)) \nReplyTo: \(String(describing: email.text)) \nDescription: \(String(describing: desc.text))", isHTML: true)
                
                present(UINavigationController(rootViewController: vc), animated: true)
            }
            else {
                toast.showToast(message: "No Email Account")
            }
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
