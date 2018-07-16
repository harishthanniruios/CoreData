//
//  ViewController.swift
//  DemoCoreData
//
//  Created by Kav Interactive on 09/07/18.
//  Copyright © 2018 Kav Interactive. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var tableVw: UITableView!
    
    var people: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableVw.delegate = self as? UITableViewDelegate
        tableVw.register(UITableViewCell.self,
                         forCellReuseIdentifier: "Cell")
        nameTextField.delegate = self 
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
    	    }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        nameTextField.resignFirstResponder()

        return true;
    }
    
    @IBAction func onClickSaveButton(_ sender: UIButton) {
        
        self.save(name: self.nameTextField.text!)
         tableVw.reloadData()
    }
    
    func save(name: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
//        let nameToSave = nameTextField.text
//        save(name: nameToSave!)
//        tableVw.reloadData()
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Person",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(name, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let person = people[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            cell.textLabel?.text = person.value(forKeyPath: "name") as? String
            return cell
    }
}
