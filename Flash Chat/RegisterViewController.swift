//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        
        let alert = UIAlertController(title: "Error", message: "Invalid UserName or Password ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        

        
        //TODO: Set up a new user on our Firbase database
        
        Auth.auth().createUser(withEmail: emailTextfield.text! , password: passwordTextfield.text!) { (user , error ) in
            
            if error != nil
            {
                print(error!)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                self.emailTextfield.text = ""
                self.passwordTextfield.text = ""
                
                
            }
            else {
                print("Registration Success ")
                
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }

        
        
    } 
    
    
}
