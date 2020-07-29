//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {

    var itemArray = [Items]()
     var udefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Items()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Items()
               newItem2.title = "Find Mike23432"
               itemArray.append(newItem2)
        
        let newItem3 = Items()
               newItem3.title = "Find Mike9999999"
        newItem3.selected = true
               itemArray.append(newItem3)
        
        
        
        
      //  if let items = udefs.array(forKey: "TodoListArray") as? [String]{
       //     itemArray = items
       // }
        
       
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        if item.selected == true{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    
      
        itemArray[indexPath.row].selected = !itemArray[indexPath.row].selected
        
        tableView.reloadData()
        
    
        tableView.deselectRow(at: indexPath, animated: true)
       
        
        
}
    
    @IBAction func addClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            let newItem = Items()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.udefs.set(self.itemArray, forKey: "TodoListArray")
           
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    

}
