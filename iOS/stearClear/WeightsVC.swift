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
    let url = "http://www.cowcloud.io"
    var animal: Animal = Animal()
    var selected: [UITableViewCell] = []

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
        
        weightTableView.allowsMultipleSelection = true
        
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
    
    func rowSelected(row: UITableViewCell){
        print("ENTERED ROW")
        if (selected.count > 1){
            print("ENTERED")
            selected.removeFirst().accessoryType = UITableViewCellAccessoryType.None
            selected.append(row)
        }
        else{
            selected.append(row)
        }
        
        print(selected)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("# selected rows: \(tableView.indexPathsForSelectedRows?.count)")
            if(tableView.indexPathsForSelectedRows?.count >= 2){
                /*let firstCell = tableView.cellForRowAtIndexPath(tableView.indexPathsForSelectedRows![0])
                let secondCell = tableView.cellForRowAtIndexPath(tableView.indexPathsForSelectedRows![1])
                
                print("WEIGHT: \(firstCell?.textLabel!.text)")
               
                let startWeightString = firstCell?.textLabel!.text
                let endWeightString = secondCell?.textLabel!.text
                let startWeight = startWeightString!.substringWithRange(Range<String.Index>(start: startWeightString!.startIndex, end: startWeightString!.endIndex.advancedBy(-2)))
                let endWeight = endWeightString!.substringWithRange(Range<String.Index>(start: endWeightString!.startIndex, end: endWeightString!.endIndex.advancedBy(-2)))

                let startWeightNum:Float? = Float(startWeight)
                let endWeightNum:Float? = Float(endWeight)
                
                let startDate = firstCell?.detailTextLabel!.text
                let endDate = secondCell?.detailTextLabel!.text
                print("Start Weight: \(startWeight)")
                calculateWeights((startWeightNum!, startDate!), endDate: (endWeightNum!, endDate!))*/
                //print("Start Weight: \(endWeight)")
                self.view.makeToast(message: "Calculated", duration: 1.0, position: "center")
                for path in tableView.indexPathsForSelectedRows! {
                    tableView.deselectRowAtIndexPath(path, animated: false)
                }
            }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
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
    
    func calculateWeights(startDate:(weight: Float, date: String), endDate:(weight: Float, date: String)){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let firstDate = dateFormatter.dateFromString(endDate.date)
        print(firstDate)
        let secondDate = dateFormatter.dateFromString(startDate.date)
        let numDays = dateFormatter.dateFromString(endDate.date)?.timeIntervalSinceDate(dateFormatter.dateFromString(startDate.date)!)
        print("NUM DAYS \(numDays)")
    }
    
    func syncWeights(){
        let parameters = [
            "token":"\(user.token)",
        ]
        
        let route = url+"/api/weights/\(animal.id)"

        
        print("ID: "+animal.id)
        
        Alamofire.request(.GET, route, parameters: parameters) .responseJSON { response in
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
                    let date = String(JSON["data"]!![i]["date"]!!)
                    

                    let formattedDate = dateFormatter.dateFromString(date)
                    

                    dateFormatter.dateFormat = "MM-dd-yyyy"
                    self.animal.weight[i].date = String(dateFormatter.stringFromDate(formattedDate!))

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
        
        let route = url+"/api/weight/\(animal.weight[index]._id)"
        
        Alamofire.request(.DELETE, route, parameters: parameters) .responseJSON { response in
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
                return String(today)
            }
            print(date)
            let parameters = [
                "token":"\(user.token)",
                "weight":"\(addNewWeightTextField!.text!)",
                "date": date
            ]
            addNewWeightTextField.text = ""
            
            let route = url+"/api/weights/\(animal.id)"
            
            Alamofire.request(.POST, route, parameters: parameters) .responseJSON { response in
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
            
            if ((addNewWeightTextField.text!).isEmpty) {
                self.view.makeToast(message: String("Please enter a weight"), duration: 1.0, position: "center")

            }
            else if ((Int(addNewWeightTextField.text!)) == nil || (Float(addNewWeightTextField.text!)) == nil) {
                self.view.makeToast(message: String("Weight must be a number"), duration: 1.0, position: "center")
                
            }
            else{
            let weight = Float(addNewWeightTextField.text!)!
            
                self.animal.weight.append(Weight(weight: weight, date: date))
                self.animal.weight.last?.weight = weight
            
                self.animal.weight.last?.date = date
                addWeighPost()
            }
            
        }
        
    
    
    
}