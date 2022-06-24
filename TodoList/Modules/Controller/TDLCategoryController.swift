//
//  TDLCategoryController.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/14.
//

import UIKit
//import CoreData
import RealmSwift
import SwipeCellKit

class TDLCategoryController: TDLBaseTVController {

    //MARK: - Property
    let cellID = "CategoryCellID"
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
        
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = #colorLiteral(red: 0.9306189418, green: 0.7211485505, blue: 0, alpha: 1)
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = categories?[indexPath.row].name ?? "none"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = TDLTodoListController()
        destinationVC.selectedCategory = categories?[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TDLCategoryController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let object = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(object)
                    }
//                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch {
                    TDLLog("Error deleting context \(error)")
                }
            }
        }
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
}
