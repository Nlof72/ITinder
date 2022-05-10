//
//  CollectionController.swift
//  ITinder
//
//  Created by Nikita on 04.05.2022.
//

import UIKit

class CollectionController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register( UINib(nibName: "UserViewCell", bundle: nil), forCellWithReuseIdentifier: "UserViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.reloadData()
        // Do any additional setup after loading the view.
    }

}

extension CollectionController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TestUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        debugPrint("asdasdasdasd")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserViewCell", for: indexPath) as!  UserViewCell
        
        let user = TestUser[indexPath.row]
        cell.setupUserCell(user)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
}
