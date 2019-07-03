//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework


class ChatViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate {

    var messArr : [Message] = [Message]()
    
    // Declare instance variables here

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO: Set yourself as the delegate and datasource here:
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:

        messageTextfield.delegate = self
        
        //TODO: Set the tapGesture here:
        
        let tapGeasture = UITapGestureRecognizer(target: self , action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGeasture)
        

        //TODO: Register your MessageCell.xib file here:

        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil ), forCellReuseIdentifier: "customMessageCell" )
        
        configure()
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath ) as! CustomMessageCell
        
        cell.messageBody.text = self.messArr[indexPath.row].messageBody
        
        cell.senderUsername.text = self.messArr[indexPath.row].sender
        
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String!
        {
            
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.avatarImageView.backgroundColor = UIColor.flatSkyBlue()
            
        }
        
        else
        {
            
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.avatarImageView.backgroundColor = UIColor.flatGray()
        }
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messArr.count
    }
    
    
    //TODO: Declare tableViewTapped here:
    
    @objc func tableViewTapped() {
        
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    
    func configure()
    {
        messageTableView.rowHeight =  UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
        
        
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
     
        
        UIView.animate(withDuration: 0.5) {
            
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
    }
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    func retrieveMessages()
    {
        
       let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (Snapshot) in
            
            let snapshotValue = Snapshot.value as! Dictionary<String , String>
            
            let text = snapshotValue["MessageBody"]!
            
            let sender = snapshotValue["Sender"]!
            
            print(text , sender )
            
            let message = Message()
            
            message.messageBody = text
            message.sender = sender
            
            self.messArr.append(message)
            
            self.configure()
            
            self.messageTableView.reloadData()
            
        }
    }
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        
        //TODO: Send the message to Firebase and save it in our database
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        
        let messageDictionarry = ["Sender" :  Auth.auth().currentUser?.email , "MessageBody" : messageTextfield.text!]
        
        messageDB.childByAutoId().setValue(messageDictionarry) {
            
            (error , reference) in
            
            if error != nil {
                
                print(error)
            }
            else
            {
                print("Message Saved Successfully")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
            
        }
        
    }
    
    //TODO: Create the retrieveMessages method here:
  
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch
        {
            print("there is a problem")
        }
    }
    


}
