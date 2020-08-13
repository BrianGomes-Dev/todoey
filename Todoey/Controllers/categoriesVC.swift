//
//  categoriesVC.swift
//  Todoey
//
//  Created by user172197 on 8/4/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class categoriesVC: UITableViewController {

    let realm = try! Realm()
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      loadCategories()
        
    }
    
    
    func save(category:Category){
        
        
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving context :",error)
        }
        self.tableView.reloadData()
    }

func loadCategories(){
        
    categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            

            self.save(category: newCategory)
            
        }
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertAction.Style.cancel,
                                            handler: {(_: UIAlertAction!) in
              }))
        
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Add a category"
        }
        
        present(alert, animated: true, completion: nil)
        //
    }


//MARK:- TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
              
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet."
              
      //        cell.accessoryType = item.done == true ? .checkmark : .none
              
              return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! TodoListVC
        
        if let indexPath = tableView.indexPathForSelectedRow{
        
        dest.selectedCategory = categories?[indexPath.row]
    }
    }
    
    
}
