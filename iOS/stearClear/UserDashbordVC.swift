//
//  DashbordTableViewController.swift
//  stearClear
//
//  Created by Noor Thabit on 10/24/15.
//  Copyright © 2015 4H. All rights reserved.
//

import UIKit
import Alamofire


class UserDashbordVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var user = User()
    
    @IBOutlet weak var numAnimalsLabel: UILabel!
    
    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var animalsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       updateLabels()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //self.animalsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func updateLabels(){
        nameLable.text = String("\(user.fname) \(user.lname)")
        numAnimalsLabel.text = "You have \(user.animals.count) animals"
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        syncUserData()
        updateLabels()


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier!{
        case "addAnimal":
            
            let addAnimalView: AddAnimalVC = segue.destinationViewController as! AddAnimalVC
            addAnimalView.token = user.token
            
        case "weights":
            let weighsView: WeightsVC = segue.destinationViewController as! WeightsVC
            if let animalIndex = animalsTableView.indexPathForSelectedRow?.row {
                weighsView.animal = self.user.animals[animalIndex]
                weighsView.user = self.user

            }
        case "login": break
            
        default:
            break
        }
        
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
  
        return user.animals.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Animal Cell", forIndexPath: indexPath)
        let animal = user.animals[indexPath.row]
        cell.detailTextLabel?.text = animal.name
        cell.textLabel?.text = animal.type
        cell.separatorInset = UIEdgeInsetsZero
        return cell
    }
    
    
    
    func syncUserData(){
        let parameters = [
            "token":"\(self.user.token)"
        ]
        let url = "http://ec2-52-88-233-238.us-west-2.compute.amazonaws.com:8080/api/animals/\(user.username)"
        
        Alamofire.request(.GET, url, parameters: parameters).responseJSON { response in
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                if JSON.count == 0 {
                    
                    return }

                self.user.animals.removeAll()
                self.user.addAnimal(JSON.count)
                print(JSON[0])
                dispatch_async(dispatch_get_main_queue()){
                    for i in 0..<JSON.count{
                        self.user.animals[i].name = String(JSON[i]["name"]!!)
                        self.user.animals[i].breed = String(JSON[i]["breed"]!!)
                        self.user.animals[i].type = String(JSON[i]["type"]!!)
                        self.user.animals[i].managedBy = String(JSON[i]["managedBy"]!!)
                        self.user.animals[i].date = Int(String(JSON[i]["type"]!!))

                    }
                    self.animalsTableView.reloadData()
                }
            }
        }
    }
    
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    switch segue.identifier!{
    case "add Animal":
    
    let addAnimalView: AddAnimalViewController = segue.destinationViewController as! AddAnimalViewController
    addAnimalView.token = user.token
    default:
    break
    }
    }*/
    
    
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
