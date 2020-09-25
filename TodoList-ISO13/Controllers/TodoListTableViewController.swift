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
        // load item.plist
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
            let newItem = Item()
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
           print("Error encoding item array")
        }
        self.tableView.reloadData()
    }
    
    func loadItem()  {
        //turn data to optional
        if let data = try? Data (contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do {
                itemArray =  try decoder.decode([Item].self, from: data)
            } catch  {
                print("Error decoding")
            }
             
        }
    }
    
}



 
