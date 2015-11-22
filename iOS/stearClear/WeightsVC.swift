//
//  AnimalViewController.swift
//  stearClear
//
import UIKit
import Alamofire

class WeightsVC:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var startDateTextField: UITextField!
    
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
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.weightTableView?.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
        
        //addNewWeightTextField = UITextField()
    }
   

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func refresh(sender:AnyObject) {
        self.syncWeights()
    }

    
    @IBAction func startDatePicker(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        startDateTextField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
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
            delWeight(indexPath.row)
            animal.weight.removeAtIndex(indexPath.row)

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
        
        let url = "http://ec2-52-88-233-238.us-west-2.compute.amazonaws.com:8080/api/weights/\(animal.id)"
        
        Alamofire.request(.GET, url, parameters: parameters) .responseJSON { response in
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                
                self.animal.weight.removeAll()
                self.animal.addWeights(JSON["data"]!!.count)
                
                for i in 0..<JSON["data"]!!.count{
                    
                    self.animal.weight[i]._id = String(JSON["data"]!![i]["_id"]!!)
                    self.animal.weight[i].weight = Float(String(JSON["data"]!![i]["weight"]!!))
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    // This is the input string.
                    var date = String(JSON["data"]!![i]["date"]!!)
                    

                    let formattedDate = dateFormatter.dateFromString(date)
                    

 
                    let correctedDate = NSCalendar.currentCalendar().dateByAddingUnit(
                        .Day,
                        value: -1,
                        toDate: formattedDate!,
                        options: NSCalendarOptions(rawValue: 0))
                    

                    dateFormatter.dateFormat = "MM-dd-yyyy"
                    self.animal.weight[i].date = String(dateFormatter.stringFromDate(correctedDate!))

                }
                
                if self.refreshControl.refreshing
                {
                    self.refreshControl.endRefreshing()
                }
                self.weightTableView.reloadData()
                
                
              
            }
        }
    }
    func delWeight(index: Int){
        
        let parameters = [
            "token":"\(user.token)",
            
        ]
        addNewWeightTextField.text = ""
        
        let url = "http://ec2-52-88-233-238.us-west-2.compute.amazonaws.com:8080/api/weight/\(animal.weight[index]._id)"
        
        Alamofire.request(.DELETE, url, parameters: parameters) .responseJSON { response in
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print(JSON)
                if String(JSON["success"]!!) == "1"{
                    dispatch_async(dispatch_get_main_queue()){
                        self.view.makeToast(message: String(JSON["message"]!!), duration: 1.0, position: "center")
                    self.weightTableView.reloadData()
                    }
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
    
        
        func addWeighPost(){

            var date: String {
                let today = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                return dateFormatter.stringFromDate(NSCalendar.currentCalendar().dateByAddingUnit(
                    .Day,
                    value: 1,
                    toDate: today,
                    options: NSCalendarOptions(rawValue: 0))!)
            }

            let parameters = [
                "token":"\(user.token)",
                "weight":"\(addNewWeightTextField!.text!)",
                "date": date
            ]
            addNewWeightTextField.text = ""
            
            let url = "http://ec2-52-88-233-238.us-west-2.compute.amazonaws.com:8080/api/weights/\(animal.id)"
            
            Alamofire.request(.POST, url, parameters: parameters) .responseJSON { response in
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print(JSON)
                    if String(JSON["success"]!!) == "1"{
                        self.animal.weight.last?._id = String(JSON["data"]!!)
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
            //self.view.makeToast(message: animal.id, duration: 1.0, position: "center")
            let weight = Float(addNewWeightTextField.text!)!
            
            self.animal.weight.append(Weight(weight: weight, date: date))
            self.animal.weight.last?.weight = weight
            
            self.animal.weight.last?.date = date
            addWeighPost()
            
            
        }
        
    
    
    
}