//
//  AnimalViewController.swift
//  stearClear
//
//  Created by Noor Thabit on 10/25/15.
//  Copyright © 2015 4H. All rights reserved.
//

import UIKit
import Alamofire

class AnimalViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var animal: Animal = Animal()
    var token: String = String()
    @IBOutlet weak var typeAnimalTextField: UITextField!
    @IBOutlet weak var breedAnimalTextField: UITextField!
    @IBOutlet weak var animalNameTextField: UITextField!
    @IBOutlet weak var addNewWeightTextField: UITextField!
    @IBOutlet var weightTableView: UITableView! =  UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextFields()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func updateTextFields(){
        animalNameTextField.text = animal.name
        breedAnimalTextField.text = animal.breed
        typeAnimalTextField.text = animal.type
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return animal.weight.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Weight Cell", forIndexPath: indexPath)
        let index = animal.weight.startIndex.advancedBy(indexPath.row)
        cell.detailTextLabel?.text = animal.weight[0]
        cell.textLabel?.text = animal.weight[0]
        return cell
        
    }
    
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier!{
        case "dashboard":
            let dashboard: DashbordTableViewController = segue.destinationViewController as! DashbordTableViewController
         dashboard.syncUserData()
            
        default:
            break
        }
        
        
    }
    
    
    
    func addWeighPost(){
        
        let parameters = [
            "token":"\(token)",
            "weight":"\(addNewWeightTextField!.text!)",
            "date":"2015/10/10"
        ]
        
        let url = "http://ec2-52-88-233-238.us-west-2.compute.amazonaws.com:8080/api/weights/\(animal.name)"
        
        Alamofire.request(.POST, url, parameters: parameters) .responseJSON { response in
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print(JSON)
                if String(JSON["success"]!!) == "1"{
                
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

    @IBAction func AddNewWeight(sender: UIButton) {
        self.animal.weight[Int(addNewWeightTextField.text!)!] = " today!"
        addNewWeightTextField.text = ""
        //self.weightTableView.reloadData()
        addWeighPost()

        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
