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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
        if let path = dataFilePath{
        print(path)
        }
       loadItems()
        
       
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.selected == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    
      
        itemArray[indexPath.row].selected = !itemArray[indexPath.row].selected
        
          let encoder = PropertyListEncoder()
                 
                 do{
                 let data = try encoder.encode(self.itemArray)
                     try data.write(to: self.dataFilePath!)
                 }catch{
                     
                 }
                 self.tableView.reloadData()
    
        tableView.deselectRow(at: indexPath, animated: true)
       
        
        
}
    
    @IBAction func addClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            let newItem = Items()
            newItem.title = textField.text!
            
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
        let encoder = PropertyListEncoder()
                 
                 do{
                 let data = try encoder.encode(itemArray)
                     try data.write(to: dataFilePath!)
                 }catch{
                     
                 }
                 self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
        
        let decoder = PropertyListDecoder()
        
        do{
            itemArray = try decoder.decode([Items].self, from: data)
        }catch{
            
        }
        
    }
    }
}
