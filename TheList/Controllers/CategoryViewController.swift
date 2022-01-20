//
//  CategoryViewController.swift
//  TheList
//
//  Created by Sergey on 20.01.2022.
//
import UIKit
import SnapKit
import CoreData

class CategoryViewController: UIViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private lazy var categoryTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupLayout()
        view.backgroundColor = UIColor(red: 0.47, green: 0.44, blue: 0.65, alpha: 1.00)
        loadItems()
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /// NAVIGATION BAR
        title = "The List"
        navigationController?.isNavigationBarHidden = false
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.47, green: 0.44, blue: 0.65, alpha: 1.00)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
}

// MARK: - CategoryVC methods

extension CategoryViewController {
    
    func saveItem() {
        
        do {
            try context.save()
        } catch {
            print ("error saving context \(error)")
        }
        categoryTableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {

        do {
            categories = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        categoryTableView.reloadData()
    }
    
    func destroyItem(indexPath: Int) {
        context.delete(categories[indexPath])
        categories.remove(at: indexPath)
    }

    
    @objc func addButtonPressed() {
        
        var listTf = UITextField()
        let alert = UIAlertController(title: "Добавть новый список", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Добавить", style: .default) { action in
            let categorie = Category(context: self.context)
            categorie.name = listTf.text!
            self.categories.append(categorie)
            self.saveItem()
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

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let listVC = TheListViewController()
        listVC.selectedCategory = categories[indexPath.row]
                navigationController?.pushViewController(listVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    
}



