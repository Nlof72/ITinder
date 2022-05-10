//
//  UserCollectionController.swift
//  ITinder
//
//  Created by Nikita on 05.05.2022.
//

import UIKit

class UserCollectionController: UIViewController {

    @IBOutlet weak var userCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userCollection.register(UINib(nibName: "UserViewCell", bundle: nil), forCellWithReuseIdentifier: "UserViewCell")
        userCollection.dataSource = self
        userCollection.delegate = self
        debugPrint(AppState.userPagedList.count)
        // Do any additional setup after loading the view.
    }
    
}

extension UserCollectionController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint(AppState.userPagedList.count)
        return AppState.userPagedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserViewCell", for: indexPath) as! UserViewCell
        
        cell.setupUserCell(AppState.userPagedList[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 104, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let currentItemNumber = indexPath.item
        let middleCountOfUser = (AppState.userPagedList.count / (AppState.offset+1))/2
        if currentItemNumber > middleCountOfUser{
            if AppState.loading  || AppState.allUsers{
                return
            }
            AppState.loading = true
            userAction.getPagedUserList(limit: AppState.limit, offset: AppState.offset + 1){
                response in
                if response.count < AppState.limit {
                    AppState.allUsers = true
                }
                AppState.offset = AppState.offset + 1
                AppState.loading = false
                collectionView.reloadData()
            }
        }
        debugPrint(indexPath.item)
        debugPrint(indexPath)
        debugPrint(AppState.offset)
    }
}
