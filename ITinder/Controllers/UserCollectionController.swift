//
//  UserCollectionController.swift
//  ITinder
//
//  Created by Nikita on 05.05.2022.
//

import UIKit

class UserCollectionController: UIViewController {

    @IBOutlet weak var userCollection: UICollectionView!
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userCollection.register(UINib(nibName: "UserViewCell", bundle: nil), forCellWithReuseIdentifier: "UserViewCell")
        userCollection.dataSource = self
        userCollection.delegate = self
        // Do any additional setup after loading the view.
    }
    
}

extension UserCollectionController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        let middleCountOfUser = (AppState.userPagedList.count)/2
        if currentItemNumber > middleCountOfUser{
            if AppState.loading  || AppState.allUsers{
                return
            }
            AppState.loading = true
            userAction.getPagedUserList(limit: AppState.limit, offset: AppState.offset + AppState.limit){
                response in
                collectionView.reloadData()
                if response.count < AppState.limit {
                    AppState.allUsers = true
                    AppState.loading = false
                    return
                }
                AppState.offset = AppState.offset + AppState.limit
                AppState.loading = false
                debugPrint(response)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "PeopleController") as! FlowController
                nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.currentUserOutsid = AppState.userPagedList[indexPath.item]
        self.show(nextViewController, sender: self)
    }
}
