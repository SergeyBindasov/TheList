//
//  ViewController.swift
//  TheList
//
//  Created by Sergey on 13.01.2022.
//

import UIKit
import SnapKit

class TheListViewController: UIViewController {
    
    var array = ["купить молоко", "сходить в зал", "почитать", "покодить", "позвонить папе"]
    
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
       
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TheListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .white
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
    
    
}



extension TheListViewController {
    @objc func addButtonPressed() {
        
       
        
        var listTf = UITextField()
        let alert = UIAlertController(title: "Добавть в список", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Добавить", style: .default) { action in
            if listTf.text == "" {
                self.array.append("Важное что-то без названия")
            } else {
                self.array.append(listTf.text!)
               
            }
            //self.array.append(listTf.text ?? "Важное что-то без названия")
            self.myTableView.reloadData()
            //print(text)
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

