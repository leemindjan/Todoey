//
//  ViewController.swift
//  Todoey
//
//  Created by Dan Le on 2/19/19.
//  Copyright © 2019 Dan Le. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //loadItems()
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    //todoItems?[indexPath.row].done = item.done
                    //selectedCategory?.items[indexPath.row].done = item.done
                }
            } catch {
                print("Error saving item \(error)")
            }
            
        }
        
        //todoItems?[indexPath.row].done = !todoItems?[indexPath.row].done
        
        //saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //print("Success")

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = alert.textFields![0].text!
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
                } catch {
                    print("Error adding new item \(error)")
                }
            }
            
            self.tableView.reloadData()
            
//            item.parentCategory = self.selectedCategory
//
//            self.itemArray.append(item)
//
//            self.saveItems()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)

    }

    //MARK - Model Manupulation Methods
//
//    func saveItems() {
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context \(error)")
//        }
//
//        tableView.reloadData()
//    }
//
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        //let request: NSFetchRequest<Item> = Item.fetchRequest()
//        if request.predicate == nil {
//            let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//            request.predicate = predicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error loading context \(error)")
//        }

        tableView.reloadData()
    }


}

//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate1 = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        let predicate2 = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name)
//
//        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicate1, predicate2])
//
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
//
//        loadItems(with: request)

//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error loading context \(error)")
//        }
//
//        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
