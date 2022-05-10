//
//  UICollectionController.swift
//  ITinder
//
//  Created by Nikita on 04.05.2022.
//

import UIKit

class UICollectionController: UIViewController {

    let dataSources: [String] = ["1", "2", "3", "4", "5", "6 "]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

}

extension UICollectionController: UICollectionViewDataSource{
    collectionView(<#T##UICollectionView#>, numberOfItemsInSection: <#T##Int#>)
}
