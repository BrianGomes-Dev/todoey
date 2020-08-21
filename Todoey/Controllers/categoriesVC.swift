//
//  categoriesVC.swift
//  Todoey
//
//  Created by user172197 on 8/4/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class categoriesVC: SwipeTableVC {

    let realm = try! Realm()
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      loadCategories()
        
        tableView.separatorStyle = .none
      
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
        
        
        
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
        
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
    
//MARK:- DELETE DATA FROM SWIPE

    override func updateModel(at indexPath: IndexPath) {
          if let categoryForDeletion = self.categories?[indexPath.row] {
              do {
                  try self.realm.write {
                      self.realm.delete(categoryForDeletion)
                  }
              } catch {
                  print("Error deleting category, \(error)")
              }
          }
      }
    
    
    
  //MARK:- ADD NEW CATEGORIES
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()

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

              
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.selectionStyle = .none
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {
                fatalError()
            }
            

            cell.backgroundColor = UIColor(hexString: category.color)
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        }
        
              
              
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

