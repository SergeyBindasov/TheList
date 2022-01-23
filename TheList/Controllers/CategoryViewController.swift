//
//  CategoryViewController.swift
//  TheList
//
//  Created by Sergey on 20.01.2022.
//
import UIKit
import SnapKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework


class CategoryViewController: SwipeViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    private lazy var categoryTableView: UITableView = {
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
        view.backgroundColor = UIColor(red: 0.47, green: 0.44, blue: 0.65, alpha: 1.00)
        loadCategories()
        
       
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /// NAVIGATION BAR
      
        title = "The List"
        //navigationController?.isNavigationBarHidden = false
       // navigationItem.largeTitleDisplayMode = .automatic
        //navigationController?.navigationBar.tintColor = .white
        //navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.47, green: 0.44, blue: 0.65, alpha: 1.00)
//        navigationController?.navigationBar.barStyle = UIBarStyle.black
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
       // navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
}

// MARK: - CategoryVC methods

extension CategoryViewController {
    
    func saveCategory(category: Category) {
        
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print ("error saving context \(error)")
        }
        categoryTableView.reloadData()
    }
    
    func loadCategories() {

        categories = realm.objects(Category.self)
        categoryTableView.reloadData()
    }
    
 
    
    override func destroy(at indexPath: Int) {
        if let category = categories?[indexPath] {
               do {
                   try realm.write({
                       realm.delete(category)
                   })
               } catch{
                   print("Error deleting item \(error)")
               }
           }
    }

    @objc func addButtonPressed() {
        
        var listTf = UITextField()
        let cString = UIColor.randomFlat().hexValue()
        let alert = UIAlertController(title: "Добавть новый список", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Добавить", style: .default) { action in
            let newCategory = Category()
            newCategory.name = listTf.text!
            newCategory.colorString = cString
            self.saveCategory(category: newCategory)
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Новый список"
            listTf = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func setupLayout() {
        view.addSubviews(categoryTableView)
        categoryTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Table View methods

extension CategoryViewController {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let listVC = TheListViewController()
        listVC.selectedCategory = categories?[indexPath.row]
                navigationController?.pushViewController(listVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let string = categories?[indexPath.row].colorString {
            let color = UIColor(hexString: string)
            cell.backgroundColor = color
            if let newColor = color {
                cell.textLabel?.textColor = ContrastColorOf(newColor, returnFlat: true)
            }
        }
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "Пока нет категорий"
        return cell
    }
}

