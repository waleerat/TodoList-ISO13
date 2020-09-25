//
//  ViewController.swift
//  TodoList-ISO13
//
//  Created by Waleerat Gottlieb on 2020-09-23.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController {
    var itemArray = [Items]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //(1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load item.plist
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItem()
    
    }

    // MARK: - TabelView Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell.todoListItem, for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType =  item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Tabelview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // set opposit value true/false
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
    // MARK: - Add New Item
 
    @IBAction func AddNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField() // create textfield for
        
        let alert = UIAlertController(title: "Add New todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the AddItem button on our UIAlert
            let newItem = Items(context: self.context) //(2)
            newItem.title = textField.text!
            self.itemArray.append(newItem)

            self.saveItem()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "CreateNew Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert , animated: true, completion: nil)
    }
    
    // MARK: - Model Munpulation Methods
    func saveItem() {
        do {
            try context.save()  //(3)save data from (2)
        } catch {
           print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
     
    func loadItem()  {
        let request : NSFetchRequest<Items> = Items.fetchRequest() //(4)
        do {
            itemArray =  try context.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
        }
        
    }
    
}



 
