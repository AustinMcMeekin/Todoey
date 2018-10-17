//
//  ViewController.swift
//  Todoey
//
//  Created by Austin McMeekin on 25/09/2018.
//  Copyright © 2018 Austin McMeekin. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    
   
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
   
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
//    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(dataFilePath)
        
    }
//MARK - Tableview Datasource Method
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    //TODO: Declare numberOfRowsInSection here:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    //MARK - TableView Delegate Methods
   
    //TODO: Declare tableViewTapped here:
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            
            do{
            try realm.write {
                
                realm.delete(item)
                
//                item.done = !item.done
            }
            } catch {
                print("Error updating data, \(error)")
            }
        }
        self.tableView.reloadData()
        
        }
    
    //TODO: Set tap gesture

    
    
    //MARK - Add New Items

    @IBAction func addCell(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
//            let currentDate = self.callDate()
    
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
            }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
            // what will happen once the user clicks the Add Item button on our UIAlert
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        
        }
    
    func saveItem (item : Item) {

//        do {
//            try realm.write {
//                realm.add(item)
//            }
//        } catch {
//            print("Error saving context, \(error)")
//        }
        
//        do {
//           try context.save()
//        } catch {
//            print("Error saving context, \(error)")
//        }
//
//        tableView.reloadData()
    }

    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
 
        tableView.reloadData()

    }
    
//    func callDate() -> Int {
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyyMMddHHmmss"
//        let now = Date()
//        let dateString = Int(formatter.string(from:now)) ?? 0
//        return dateString
//    }
    
}

//MARK: - Search Bar methods

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadItems()
    }
}
