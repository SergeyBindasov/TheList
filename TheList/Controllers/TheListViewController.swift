//
//  ViewController.swift
//  TheList
//
//  Created by Sergey on 13.01.2022.
//

import UIKit
import SnapKit
import RealmSwift

class TheListViewController: UIViewController {
    
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
        return bar
    }()
    
    private lazy var myTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.47, green: 0.44, blue: 0.65, alpha: 1.00)
        setupLayout()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /// NAVIGATION BAR
        title = "My List"
        navigationController?.isNavigationBarHidden = false
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.47, green: 0.44, blue: 0.65, alpha: 1.00)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
}

// MARK: -  TheListVC methods
extension TheListViewController {
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        myTableView.reloadData()
    }
    
    func destroyItem(indexPath: Int) {
        if let item = toDoItems?[indexPath] {
            do {
                try realm.write({
                    realm.delete(item)
                })
            } catch{
                print("Error deleting item \(error)")
            }
        }
        myTableView.reloadData()
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
extension TheListViewController: UITableViewDelegate {
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
}
    

extension TheListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .white
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
        } else {
            cell.textLabel?.text = "Пока нет списков"
        }
        return cell
    }
}
