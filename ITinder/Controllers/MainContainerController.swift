//
//  MainContainerController.swift
//  ITinder
//
//  Created by Nikita on 30.04.2022.
//

import UIKit

class MainContainerController: UITabBarController {

    public var Controllers:[UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        debugPrint("7777777777")
        debugPrint(Controllers)
        debugPrint(self.selectedIndex)
        
        if self.selectedIndex == 0  {
            if Controllers.count == 0{
                
            }else{
                print("---------------")
                //print((Controllers[0] as! ChatsController))
                //(Controllers[0] as! ChatsController).reloadChat()
            }

        }
    }
}
