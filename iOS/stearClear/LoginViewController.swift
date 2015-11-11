//
//  ViewController.swift
//  stearClear
//
//  Created by Noor Thabit on 10/4/15.
//  Copyright © 2015 4H. All rights reserved.
//

import Alamofire
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var newUserbutton = UIButton()
    @IBOutlet weak var usernameTextField = UITextField()
    @IBOutlet weak var passwordTextField = UITextField()
    
    @IBOutlet weak var singInButton = UIButton()
    
    let url = NSURL(string: "http://ec2-52-88-233-238.us-west-2.compute.amazonaws.com:8080/api/authenticate")
    
    var user: User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let paddingUsernameTextField = UIView(frame: CGRectMake(0, 0, 15, self.usernameTextField!.frame.height))
        usernameTextField!.leftView = paddingUsernameTextField
        usernameTextField!.leftViewMode = UITextFieldViewMode.Always
        
        let paddingPasswordTextField = UIView(frame: CGRectMake(0, 0, 15, self.passwordTextField!.frame.height))
        passwordTextField!.leftView = paddingPasswordTextField
        passwordTextField!.leftViewMode = UITextFieldViewMode.Always
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier!{
            
        case "signUp":
            
            let signUp: RegistrationViewController = segue.destinationViewController as! RegistrationViewController
            //dashboard.user = user
            
        case "dashboard":
            let dashboard: DashbordTableViewController = segue.destinationViewController as! DashbordTableViewController
            dashboard.user = self.user
            
        default:
            break
        }
    }
    
    @IBAction func signIn(sender: UIButton) {
        authenticate()
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        
    }
    
    func syncUserData(){
        let parameters = [
            "token":"\(user.token)"
        ]
        let url = "http://ec2-52-88-233-238.us-west-2.compute.amazonaws.com:8080/api/animals/\(user.username)"
        Alamofire.request(.GET, url, parameters: parameters).responseJSON { response in
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                if JSON.count == 0 {
                    self.performSegueWithIdentifier("dashboard", sender: self)
                    
                    return }
                self.user.addAnimal(JSON.count)
                print(JSON[0])
                dispatch_async(dispatch_get_main_queue()){
                    for i in 0..<JSON.count{
                        self.user.animals[i].name = String(JSON[i]["name"]!!)
                        self.user.animals[i].breed = String(JSON[i]["breed"]!!)
                        self.user.animals[i].type = String(JSON[i]["type"]!!)
                        self.user.animals[i].managedBy = String(JSON[i]["managedBy"]!!)
                        self.user.animals[i].date = Int(String(JSON[i]["type"]!!))
                        
                        
                        
                        self.performSegueWithIdentifier("dashboard", sender: self)
                    }
                }
            }
        }
    }
    
    
    func authenticate(){
        
        let parameters = [
            "username":"\(usernameTextField!.text!)",
            "password":"\(passwordTextField!.text!)"
        ]
        
        let url = "http://ec2-52-88-233-238.us-west-2.compute.amazonaws.com:8080/api/authenticate"
        
        Alamofire.request(.POST, url, parameters: parameters) .responseJSON { response in
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print(JSON)
                if String(JSON["success"]!!) == "1"{
                    self.user.username = String(JSON["username"]!!)
                    self.user.email = String(JSON["email"]!!)
                    self.user.fname = String(JSON["fname"]!!)
                    self.user.lname = String(JSON["lname"]!!)
                    self.user.token = String(JSON["token"]!!)
                    self.syncUserData()
                }
                else if String(JSON["success"]!!) == "0" {
                    self.view.makeToast(message: "Wrong Username or Password!", duration: 1.0, position: "center")
                    return
                }
                else{
                    
                }
                //self.user.username = self.usernameTextField!.text
            }
        }
    }
    
}
