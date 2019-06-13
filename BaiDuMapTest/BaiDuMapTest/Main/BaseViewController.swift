//
//  BaseViewController.swift
//  BaiDuMapTest
//
//  Created by zl on 2019/6/6.
//  Copyright © 2019 ZHUNJIEE. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // view的显示从导航栏下面开始
        edgesForExtendedLayout = []
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
