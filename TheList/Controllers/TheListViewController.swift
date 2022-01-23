//
//  ViewController.swift
//  TheList
//
//  Created by Sergey on 13.01.2022.
//

import UIKit
import SnapKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework


class TheListViewController: SwipeViewController {
    
    let realm = try! Realm()
    
    var toDoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
   
    
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.searchTextField.backgroundColor = .white
        return bar
    }()
    
    private lazy var myTableView: UITableView = {
        let table = UITableView()
        table.register(SwipeTableViewCell.self, forCellReuseIdentifier: "Cell")
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        table.rowHeight = 60
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /// NAVIGATION BAR
        title = selectedCategory?.name
        guard let color = selectedCategory?.colorString else { return }
        view.backgroundColor = UIColor(hexString: color)
        searchBar.barTintColor = UIColor(hexString: color)
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: color)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        
    }
}

// MARK: -  TheListVC methods
extension TheListViewController {
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        myTableView.reloadData()
    }
    
    override func destroy(at indexPath: Int) {
        if let item = toDoItems?[indexPath] {
               do {
                   try realm.write({
                       realm.delete(item)
                   })
               } catch{
                   print("Error deleting item \(error)")
               }
           }
    }
        
    @objc func addButtonPressed() {
        
        var listTf = UITextField()
        let alert = UIAlertController(title: "Добавть в список", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Добавить", style: .default) { action in

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write({
                    let newItem = Item()
                    newItem.title = listTf.text!
                        newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                })
                } catch {
                    print("Error saving new items \(error)")
                }
                self.myTableView.reloadData()
        
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Что-то очень важное"
            listTf = textField
        }
        alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
        
    func setupLayout() {
        view.addSubviews(searchBar, myTableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        myTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Search bar methods
extension TheListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        myTableView.reloadData()
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

// MARK: - TableView methods
extension TheListViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write({
                    item.isDone = !item.isDone
                })
            } catch{
                print("Error saving done status \(error)")
            }
        }
        myTableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell =  super.tableView(tableView, cellForRowAt: indexPath)
        cell.backgroundColor = .white
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
           
            if let color = UIColor(hexString: selectedCategory!.colorString)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat (toDoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "Пока нет списков"
        }
        return cell
    }
}
