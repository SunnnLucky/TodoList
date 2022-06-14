//
//  TDLCategoryController.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/14.
//

import UIKit
import CoreData

class TDLCategoryController: TDLBaseTVController {

    //MARK: - Property
    let cellID = "CategoryCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Todoey"
        configureSubView()
    }
    
    func configureSubView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        //tableView.sectionHeaderTopPadding = 0.0
        tableView.backgroundColor = #colorLiteral(red: 0.9306189418, green: 0.7211485505, blue: 0, alpha: 1)
        
        let rightBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonPressed))
        rightBtn.tintColor = .white
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    //MARK: - Add New Items
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Creat new item"
        }
        
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            guard let text = alert.textFields?.first?.text else {return}
//            let model = TodoList(context: self.context)
//            model.text = text
//            model.isSelect = false
//
//            self.itemArray.append(model)
//            self.saveTodoListData()
//            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Table view data source & delegate
extension TDLCategoryController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
//        let model = itemArray[indexPath.row]
//        cell.textLabel?.text = model.text
//        cell.accessoryType = model.isSelect ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
