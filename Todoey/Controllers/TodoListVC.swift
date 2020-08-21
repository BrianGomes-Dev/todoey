//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListVC: SwipeTableVC {

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
        tableView.separatorStyle = .none
        
   
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
             if let  colorHex = selectedCategory?.color{
                title = selectedCategory?.name
               navigationController?.navigationBar.barTintColor = UIColor(hexString: colorHex)
                
                guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
                  
                
                if let navBarColor = UIColor(hexString: colorHex){
                    
                    navBar.barTintColor = navBarColor
                    
                    navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                    navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                    
                    searchBar.barTintColor = navBarColor
                    searchBar.searchTextField.backgroundColor = ContrastColorOf(navBarColor, returnFlat: true)
                    
                    
                }
           }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                
                cell.backgroundColor = color
                
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                
            }
            
            
        }
        
        cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No items added yet."
        
        
         
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        print("Tapped")
        //REALM
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    //realm delete functionality
                   // realm.delete(item)
                    
                    
                    //realm update functionality
                    item.done = !item.done
                       print("Tapped")
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
    
    
    //MARK:- DELETE DATA FROM SWIPE

    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
              do {
                  try self.realm.write {
                      self.realm.delete(itemForDeletion)
                  }
              } catch {
                  print("Error deleting category, \(error)")
              }
          }
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
