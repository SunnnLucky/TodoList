//
//  TDLCategoryController.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/14.
//

import UIKit
//import CoreData
import RealmSwift

class TDLCategoryController: TDLSwipeTVController {
    
    //MARK: - Property
    let realm = try! Realm()
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Todoey"
        loadCategoryList()
        configureSubView()
    }
    
    func configureSubView() {
        let rightBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonPressed))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    //MARK: - Add New Items
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Creat new Category"
        }
        
        let addAction = UIAlertAction(title: "Add Category", style: .default) { action in
            guard let text = alert.textFields?.first?.text else {return}
            let newCategory = Category()
            newCategory.name = text
            newCategory.colorHex = UIColor.randomFlat().hexValue()
            self.saveCategoryData(newCategory)
            self.tableView.reloadData()
            /* core data
             let model = Category(context: self.context)
             */
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Realm
    func saveCategoryData(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            TDLLog("Error saving context \(error)")
        }
    }
    
    func loadCategoryList() {
        categories = realm.objects(Category.self)
    }
    
    override func deleteAction(indexPath: IndexPath) {
        guard let object = categories?[indexPath.row] else {return}
        do {
            try realm.write {realm.delete(object)}
        } catch {
            TDLLog("Error deleting context \(error)")
        }
    }
    
    //MARK: - Data Base
    /*
     func saveCategoryData() {
     do {
     try context.save()
     } catch {
     TDLLog("Error saving context \(error)")
     }
     }
     
     func loadCategoryList(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
     do {
     categories = try context.fetch(request)
     } catch {
     TDLLog("Error fetching data from context \(error)")
     }
     }
     */
}

// MARK: - Table view data source & delegate
extension TDLCategoryController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let model = categories?[indexPath.row] {
            cell.textLabel?.text = model.name
            cell.backgroundColor = .init(hexString: model.colorHex)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = TDLTodoListController()
        destinationVC.selectedCategory = categories?[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
