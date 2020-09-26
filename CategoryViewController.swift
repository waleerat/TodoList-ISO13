//
//  CategoryViewController.swift
//  TodoList-ISO13
//
//  Created by Waleerat Gottlieb on 2020-09-25.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var itemArray = [Categories]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //var itemArray = [Categories]()
        let destinationVC = segue.destination as! TodoListViewController
        
        if let IndexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = itemArray[IndexPath.row]
        }
    }
    
    // MARK: - Add New Categories
    @IBAction func clickAddNewCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField() // create textfield for
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // What will happen once the user clicks the AddItem button on our UIAlert
            let newCate = Categories(context: self.context)
            newCate.name = textField.text!
            self.itemArray.append(newCate)
            self.saveCategory()
            print("Save!")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "CreateNew Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert , animated: true, completion: nil)
    }
    
    // MARK: - Data Manipulatation Methods
    func saveCategory() {
        do {
            try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
     
    func loadCategories(with request: NSFetchRequest<Categories> =  Categories.fetchRequest())  {
        do {
            itemArray =  try context.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}
