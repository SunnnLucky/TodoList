//
//  TDLHomeController.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/9.
//

import UIKit

class TDLHomeController: TDLBaseTVController {
    
    var itemArray : [TDLTodoListModel] = []
    
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let cellID = "HomeCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Todoey"
        loadTodoList()
        
//        if let tempArray = self.defaults.array(forKey: TDLConst.kTodoListArray) as? [TDLTodoListModel] {
//            itemArray = tempArray
//        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = #colorLiteral(red: 0.9306189418, green: 0.7211485505, blue: 0, alpha: 1)
        
        let rightBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonPressed))
        rightBtn.tintColor = .white
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    //MARK: - Save Data
    func saveTodoListData() {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            guard let url = dataFilePath else {return}
            try data.write(to: url)
        } catch {
            TDLLog("encoder fail \(error)")
        }
        
        //defaults.set(self.itemArray, forKey: TDLConst.kTodoListArray)
        //defaults.synchronize()
    }
    
    func loadTodoList() {
        guard let url = dataFilePath else {return}
        guard let data = try? Data(contentsOf: url) else {return}
        let decoder = PropertyListDecoder()
        do {
            itemArray = try decoder.decode([TDLTodoListModel].self, from: data)
        } catch {
            TDLLog("decoder fail \(error)")
        }
    }
    
    //MARK: - Add New Items
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Creat new item"
        }
        
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            guard let text = alert.textFields?.first?.text else {return}
            let model = TDLTodoListModel(text, false)
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
        
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        
        let isSelect = itemArray[indexPath.row].isSelect
        
        cell.accessoryType = isSelect ? .none : .checkmark
        itemArray[indexPath.row].isSelect = !isSelect
        saveTodoListData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
