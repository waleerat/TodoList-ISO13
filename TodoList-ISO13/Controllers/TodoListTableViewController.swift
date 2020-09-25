//
//  ViewController.swift
//  TodoList-ISO13
//
//  Created by Waleerat Gottlieb on 2020-09-23.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newItem = Item()
        newItem.title = "Waleerat1"
        itemArray.append(newItem)
        let newItem1 = Item()
        newItem1.title = "Waleerat2"
        itemArray.append(newItem1)
        let newItem2 = Item()
        newItem2.title = "Waleerat3"
        itemArray.append(newItem2)
        
         
    
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

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
    // MARK: - Add New Item
 
    @IBAction func AddNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField() // create textfield for
         
        let alert = UIAlertController(title: "Add New todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the AddItem button on our UIAlert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
             
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            } catch {
               print("Error encoding item array")
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "CreateNew Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert , animated: true, completion: nil)
    }
    
}



 
