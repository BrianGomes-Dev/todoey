//
//  categoriesVC.swift
//  Todoey
//
//  Created by user172197 on 8/4/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class categoriesVC: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

   loadItems()
        
    }
    
    
    func saveItems(){
        
        
        do{
            try context.save()
        }catch{
            print("Error saving context :",error)
        }
        self.tableView.reloadData()
    }

func loadItems(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        
        
        
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context: ",error)
        }
        
        tableView.reloadData()
    }
    
    
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            
            self.categoryArray.append(newCategory)
            self.saveItems()
            
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
        categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
              
              let categorys = categoryArray[indexPath.row]
        cell.textLabel?.text = categorys.name
              
      //        cell.accessoryType = item.done == true ? .checkmark : .none
              
              return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! TodoListVC
        
        if let indexPath = tableView.indexPathForSelectedRow{
        
        dest.selectedCategory = categoryArray[indexPath.row]
    }
    }
    
    
}
