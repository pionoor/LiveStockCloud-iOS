//
//  WeightTableViewController.swift
//  stearClear
//
//  Created by Noor Thabit on 11/8/15.
//  Copyright © 2015 4H. All rights reserved.
//

import UIKit
import Alamofire

class WeightTableViewController: UITableViewController {

    var animal: Animal = Animal()
    var token: String = String()
    
    @IBOutlet var weightTableView: UITableView! =  UITableView()

    @IBOutlet var addNewWeightTextField: UITextField! = UITextField()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    func addWeighPost(){
        
        let parameters = [
            "token":"\(token)",
            "weight":"\(addNewWeightTextField!.text!)",
            "date":"10/10/2015"
        ]
        addNewWeightTextField.text = ""
        
        let url = "http://ec2-52-88-233-238.us-west-2.compute.amazonaws.com:8080/api/weights/\(animal.name)"
        
        Alamofire.request(.POST, url, parameters: parameters) .responseJSON { response in
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print(JSON)
                if String(JSON["success"]!!) == "1"{
                    self.weightTableView.reloadData()
                    
                }
                else if String(JSON["success"]!!) == "0" {
                    self.view.makeToast(message: String(JSON["message"]!!), duration: 1.0, position: "center")
                    return
                }
                else{
                    
                }
            }
        }
    }
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
