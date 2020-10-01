//
//  CategoryViewController.swift
//  TodoList-ISO13
//
//  Created by Waleerat Gottlieb on 2020-09-25.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var itemArray = [Categories]()  // 1. define array
    // Optional :  4. Set View context for popup
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()  // 2. load data to array
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count  // 3. count Array
    }
    
    // 4. connect table with TableCell  this function will be called (itemArray.count) times
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.name // 5. load data to cell
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    // 6. Action if cilck Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    // 7. prepare data befor  segue to the next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //var itemArray = [Categories]()
        // 6. set distination code tyo TodoListViewController
        let destinationVC = segue.destination as! TodoListViewController
        
        if let IndexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = itemArray[IndexPath.row]
        }
    }
    
    // MARK: - Add New Categories
    // Optional : Create add Category Popup
    @IBAction func clickAddNewCategory(_ sender: UIBarButtonItem) {
        // Optional : 1. Create text field
        var textField = UITextField()
        // Optional : 2. Create Popup window with title Add New Category
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        // Optional : 3. Create Add Category BNT
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // Optional : 5. What will happen once the user clicks the AddItem button on our UIAlert
            let newCate = Categories(context: self.context)
            newCate.name = textField.text!
            self.itemArray.append(newCate)
            self.saveCategory()
            print("Save!")
        }
        // // Optional : 5. set placeholder to TextField
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "CreateNew Category"
            textField = alertTextField
        }
        // Optional : 6. popup window
        alert.addAction(action)
        // Optional : 7. set Animation
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
