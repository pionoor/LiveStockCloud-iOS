//
//  AnimalViewController.swift
//  stearClear
//
//  Created by Noor Thabit on 10/25/15.
//  Copyright © 2015 4H. All rights reserved.
//

import UIKit

class AnimalViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var animal:Animal = Animal()
    
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
    
    
    
    @IBAction func AddNewWeight(sender: UIButton) {
        self.animal.weight[Int(addNewWeightTextField.text!)!] = " today!"
        addNewWeightTextField.text = ""
        //self.weightTableView.reloadData()

        
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
