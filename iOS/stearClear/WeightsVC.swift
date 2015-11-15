//
//  AnimalViewController.swift
//  stearClear
//
import UIKit
import Alamofire

class WeightsVC:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    var user = User()
    var animal: Animal = Animal()
    @IBOutlet weak var typeAnimalTextField: UILabel!
    @IBOutlet weak var breedAnimalTextField: UILabel!
    @IBOutlet weak var animalNameTextField: UILabel!
    
    @IBOutlet var addNewWeightTextField: UITextField! = UITextField()
    @IBOutlet var weightTableView: UITableView! =  UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextFields()
        syncWeights()
        
        // Do any additional setup after loading the view.
        
        //addNewWeightTextField = UITextField()
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            animal.weight.removeAtIndex(indexPath.row)
            weightTableView.reloadData()
        }
    }
    
    @IBAction func backToDashboard(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("backToDashboard", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Weight Cell", forIndexPath: indexPath)
        cell.detailTextLabel?.text = String(animal.weight[indexPath.row].date )
        cell.textLabel?.text = String("\(animal.weight[indexPath.row].weight)lb")
        return cell
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier!{
        case "backToDashboard":
            let dashboard: UserDashbordVC = segue.destinationViewController as! UserDashbordVC
            dashboard.user = self.user
            
        default:
            break
        }
    }
    
    
    func syncWeights(){
        let parameters = [
            "token":"\(user.token)",
        ]
        
        let url = "http://ec2-52-88-233-238.us-west-2.compute.amazonaws.com:8080/api/weights/\(animal.name)"
        
        Alamofire.request(.GET, url, parameters: parameters) .responseJSON { response in
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print(JSON)
                self.animal.weight.removeAll()
                self.animal.addWeights(JSON.count)
                
                for i in 0..<JSON.count{
                    
                    self.animal.weight[i]._id = String(JSON[i]["_id"]!!)
                    self.animal.weight[i].weight = Float(String(JSON[i]["weight"]!!))
                    
                    self.animal.weight[i].date = String(JSON[i]["date"]!!)
                }
                self.weightTableView.reloadData()
                
                
                /*if String(JSON["success"]!!) == "1"{
                self.weightTableView.reloadData()
                
                }
                else if String(JSON["success"]!!) == "0" {
                self.view.makeToast(message: String(JSON["message"]!!), duration: 1.0, position: "center")
                return
                }
                else{
                
                }*/
            }
        }
    }
    
    func addWeighPost(){
        
        let parameters = [
            "token":"\(user.token)",
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
    
    @IBAction func AddNewWeight(sender: UIButton) {
        var date: String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            return dateFormatter.stringFromDate(NSDate())
        }
        
        let weight = Float(addNewWeightTextField.text!)!
        self.animal.weight.insert(<#T##newElement: Element##Element#>, atIndex: 0)
        self.animal.weight.last?.weight = weight
        
        self.animal.weight.last?.date = date
        //self.weightTableView.reloadData()
        addWeighPost()
        
        
    }
    
    
    
    
}