//
//  ViewController.swift
//  TheList
//
//  Created by Sergey on 13.01.2022.
//

import UIKit
import SnapKit
import CoreData

class TheListViewController: UIViewController {
    
    var array = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
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
        
        view.addSubviews(searchBar, myTableView)
        view.backgroundColor = UIColor(red: 0.47, green: 0.44, blue: 0.65, alpha: 1.00)
        setupLayout()
        loadItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /// NAVIGATION BAR
        title = "The List"
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    func saveItem() {
        
        do {
            try context.save()
        } catch {
            print ("error saving context \(error)")
        }
        myTableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {

        
        do {
            array = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        myTableView.reloadData()
    }
    
    func destroyItem(indexPath: Int) {
        context.delete(array[indexPath])
        array.remove(at: indexPath)
    }
    
    
    @objc func addButtonPressed() {
        
        var listTf = UITextField()
        let alert = UIAlertController(title: "Добавть в список", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Добавить", style: .default) { action in
            
            
            let newItem = Item(context: self.context)
            newItem.title = listTf.text!
            newItem.isDone = false
            self.array.append(newItem)
            self.saveItem()
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Что-то очень важное"
            listTf = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func setupLayout() {
        
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
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
       
        loadItems(with: request)
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
                
        array[indexPath.row].isDone = !array[indexPath.row].isDone
        
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TheListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = array[indexPath.row]
        cell.backgroundColor = .white
        cell.textLabel?.text = item.title
        // ternary operator
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
    }
}




