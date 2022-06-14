//
//  TDLBaseNavController.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/10.
//

import UIKit

class TDLBaseNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 解决iOS15 barTintColor设置无效的问题
        // 使用新的UINavigationBarAppearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        navigationBar.tintColor = .white
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
        // 与scrollEdgeAppearance保持一致
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
