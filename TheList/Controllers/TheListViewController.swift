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
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
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
        
        view.addSubviews(myTableView)
        view.backgroundColor = UIColor(red: 0.47, green: 0.44, blue: 0.65, alpha: 1.00)
        setupLayout()
        //loadItems()
        
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



extension TheListViewController {
    
    func saveItem() {
        
        do {
            try context.save()
        } catch {
            print ("error saving context \(error)")
        }
        myTableView.reloadData()
    }
    
//    func loadItems() {
//
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                array = try decoder.decode([Item].self, from: data)
//            } catch{
//                print("Error decoding item array \(error)")
//            }
//        }
//    }
    
    
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
        
        myTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
