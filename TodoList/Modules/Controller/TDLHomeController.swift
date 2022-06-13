//
//  TDLHomeController.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/9.
//

import UIKit
import CoreData

class TDLHomeController: TDLBaseTVController {
    
    //MARK: - Property
    let cellID = "HomeCellID"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray : [TodoList] = []
    
    lazy var searchBar : UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        return bar
    }()
    
    //MARK: - Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Todoey"
        loadTodoList()
        configureSubView()
    }
    
    func configureSubView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.sectionHeaderTopPadding = 0.0
        tableView.backgroundColor = #colorLiteral(red: 0.9306189418, green: 0.7211485505, blue: 0, alpha: 1)
        
        let rightBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonPressed))
        rightBtn.tintColor = .white
        navigationItem.rightBarButtonItem = rightBtn
        
    }
    
    //MARK: - Data Base
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
    
    func loadTodoList(with request : NSFetchRequest<TodoList> = TodoList.fetchRequest()) {
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
        let request : NSFetchRequest<TodoList> = TodoList.fetchRequest()
        request.predicate = NSPredicate(format: "text CONTAINS[cd] %@", text)
        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        
        loadTodoList(with: request)
    }
    
    //MARK: - Add New Items
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Creat new item"
        }
        
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            guard let text = alert.textFields?.first?.text else {return}
            let model = TodoList(context: self.context)
            model.text = text
            model.isSelect = false
            
            self.itemArray.append(model)
            self.saveTodoListData()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Table view data source & delegate
extension TDLHomeController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let model = itemArray[indexPath.row]
        cell.textLabel?.text = model.text
        cell.accessoryType = model.isSelect ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        
        let model = itemArray[indexPath.row]
        let isSelect = model.isSelect
        
        cell.accessoryType = isSelect ? .none : .checkmark
        model.isSelect = !isSelect
        saveTodoListData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        searchBar
    }
}

//MARK: - UISearchBarDelegate
extension TDLHomeController : UISearchBarDelegate {
    // 按字符串查询
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let text = searchBar.text else {return}
        
        text.isEmpty ? loadTodoList() : searchTodoList(with: text)
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
