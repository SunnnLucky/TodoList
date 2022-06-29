//
//  TDLHomeController.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/9.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class TDLTodoListController: TDLSwipeTVController {
    
    //MARK: - Property
    let realm = try! Realm()
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var todoItems: Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItemList()
        }
    }
    
    lazy var searchBar : UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        return bar
    }()
    
    //MARK: - Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let colorHex = selectedCategory?.colorHex {
            title = selectedCategory?.name
            searchBar.barTintColor = UIColor(hexString: colorHex)
            guard let navBar =  navigationController?.navigationBar else {return}
            guard let color = UIColor(hexString: colorHex) else {return}
            let appearance = navBar.standardAppearance
            let textColor = ContrastColorOf(color, returnFlat: true)
            appearance.backgroundColor = color
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : textColor]
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : textColor]
            
            navBar.tintColor = textColor
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = selectedCategory?.colorHex {
            title = "Todoey"
            guard let navBar =  navigationController?.navigationBar else {return}
            let appearance = navBar.standardAppearance
            appearance.backgroundColor = .systemBlue
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            
            navBar.tintColor = .white
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
        }
    }
    
    func configureSubView() {
        
        tableView.sectionHeaderTopPadding = 0.0
        tableView.backgroundColor = #colorLiteral(red: 0.9306189418, green: 0.7211485505, blue: 0, alpha: 1)
        
        let rightBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonPressed))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    override func deleteAction(indexPath: IndexPath) {
        guard let item = todoItems?[indexPath.row] else {return}
        do {
            try realm.write{realm.delete(item)}
        } catch {
            TDLLog("Error saving context \(error)")
        }
    }
    
    //MARK: - Realm
    //    func saveItemData(_ item: Item) {
    //        do {
    //            try realm.write {
    //                realm.add(item)
    //            }
    //        } catch {
    //            TDLLog("Error saving context \(error)")
    //        }
    //    }
    
    func loadItemList() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    func searchTodoList(with text : String) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "dateCreated", ascending: true)
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //        let predicate = NSPredicate(format: "text CONTAINS[cd] %@", text)
        //        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        //
        //        loadTodoList(with: request, predicate: predicate)
    }
    
    //MARK: - Data Base
    /*
     func saveTodoListData() {
     // let encoder = PropertyListEncoder()
     do {
     //let data = try encoder.encode(itemArray)
     //guard let url = dataFilePath else {return}
     //try data.write(to: url)
     try context.save()
     } catch {
     TDLLog("Error saving context \(error)")
     }
     }
     
     func loadTodoList(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
     let matchesPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
     if let addtionalPredicate = predicate {
     request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [addtionalPredicate,matchesPredicate])
     } else {
     request.predicate = matchesPredicate
     }
     
     do {
     itemArray = try context.fetch(request)
     } catch {
     TDLLog("Error fetching data from context \(error)")
     }
     
     /*
      guard let url = dataFilePath else {return}
      guard let data = try? Data(contentsOf: url) else {return}
      let decoder = PropertyListDecoder()
      do {
      itemArray = try decoder.decode([TodoList].self, from: data)
      } catch {
      TDLLog("decoder fail \(error)")
      }
      */
     }
     
     func searchTodoList(with text : String) {
     let request : NSFetchRequest<Item> = Item.fetchRequest()
     let predicate = NSPredicate(format: "text CONTAINS[cd] %@", text)
     request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
     
     loadTodoList(with: request, predicate: predicate)
     }
     */
    
    //MARK: - Add New Items
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Creat new item"
        }
        
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            guard let text = alert.textFields?.first?.text else {return}
            guard let currentCategory = self.selectedCategory else {return}
            do {
                try self.realm.write({
                    let item = Item()
                    item.title = text
                    item.dateCreated = Date()
                    item.colorHex = UIColor.randomFlat().hexValue()
                    currentCategory.items.append(item)
                })
            } catch {
                TDLLog("Error saving context \(error)")
            }
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Table view data source & delegate
extension TDLTodoListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        guard let model = todoItems?[indexPath.row] else {return cell}
        cell.textLabel?.text = model.title
        cell.accessoryType = model.done ? .checkmark : .none
        let percentage = CGFloat(indexPath.row) / CGFloat(todoItems!.count)
        let bgColor = UIColor(hexString: selectedCategory!.colorHex)
        if let color = bgColor?.darken(byPercentage:percentage) {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        guard let model = todoItems?[indexPath.row] else {return}
        let isSelect = model.done
        cell.accessoryType = isSelect ? .none : .checkmark
        do {
            try realm.write{
                model.done = !isSelect
            }
        } catch {
            TDLLog("Error saving context \(error)")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        searchBar
    }
}

//MARK: - UISearchBarDelegate
extension TDLTodoListController : UISearchBarDelegate {
    // 按字符串查询
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let text = searchBar.text else {return}
        
        text.isEmpty ? loadItemList() : searchTodoList(with: text)
        tableView.reloadData()
        
        if text.isEmpty {
            // 这里跟调用顺序有关，点击叉号按钮会再次调用searchBarShouldBeginEditing导致键盘无法正常回退
            // 加上DispatchQueue.main.async方法会改用调用顺序，使键盘正常退出
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    //    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //        guard let text = searchBar.text else {return}
    //
    //        searchTodoList(text: text)
    //
    //        tableView.reloadData()
    //    }
}
