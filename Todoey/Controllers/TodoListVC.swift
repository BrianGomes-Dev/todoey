//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UITableViewController {

    var itemArray = [Items]()
  //  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     loadItems()
        
       
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        //delete functionality
       // context.delete(itemArray[indexPath.row])
     //   itemArray.remove(at: indexPath.row)
        
        //update functinality
       // itemArray[indexPath.row].setValue("Completed :", forKey: "title")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
     saveItems()
    
        tableView.deselectRow(at: indexPath, animated: true)
     
}
    
    @IBAction func addClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in

            let newItem = Items(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            self.saveItems()
         
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    func saveItems(){
    
                 
                 do{
                    try context.save()
                 }catch{
                     print("Error saving context :",error)
                 }
                 self.tableView.reloadData()
    }
    
    func loadItems(){

        let request : NSFetchRequest<Items> = Items.fetchRequest()
        
        do{
        itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context: ",error)
        }
    }
}
