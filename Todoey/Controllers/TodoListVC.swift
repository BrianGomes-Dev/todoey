//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListVC: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     loadItems()
        
       
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added."
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        //REALM
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    //realm delete functionality
                   // realm.delete(item)
                    
                    
                    //realm update functionality
                    item.done = !item.done
                }
                
            }catch{
                print("error Saving done status,",error)
            }
            }
        tableView.reloadData()
        
        
        
        
        //CORE DATA:
        //delete functionality
       // context.delete(itemArray[indexPath.row])
     //itemArray.remove(at: indexPath.row)
        
        //update functinality
       // itemArray[indexPath.row].setValue("Completed :", forKey: "title")
        
      //  todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
     //saveItems()
    
        tableView.deselectRow(at: indexPath, animated: true)
     
}
    
    @IBAction func addClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory{
            
                do{
                    try self.realm.write{
            let newItem = Item()
            newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    }catch{
                        print("Error saving new Items ",error)
                    }
                }
            self.tableView.reloadData()
        }
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertAction.Style.cancel,
                                            handler: {(_: UIAlertAction!) in
              }))
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    func saveItems(){
    
                 
             //    do{
             //       try context.save()
             //    }catch{
             //        print("Error saving context :",error)
              //   }
              //   self.tableView.reloadData()
    }
    
    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

// MARK :- Search bar Methods
extension TodoListVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
        
   
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            
           loadItems()
            
           DispatchQueue.main.async {
               searchBar.resignFirstResponder()
           }
            
       }
    }
    
}
