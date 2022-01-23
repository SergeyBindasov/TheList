//
//  SceneDelegate.swift
//  TheList
//
//  Created by Sergey on 13.01.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let navcontroller = UINavigationController()
        navcontroller.isNavigationBarHidden = false
        navcontroller.navigationBar.prefersLargeTitles = true
        navcontroller.navigationBar.tintColor = .white
        navcontroller.navigationBar.barStyle = UIBarStyle.black
        navcontroller.navigationBar.isTranslucent = true
        navcontroller.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navcontroller.navigationBar.tintColor = .white
        navcontroller.navigationItem.rightBarButtonItem?.tintColor = .white
        navcontroller.viewControllers = [CategoryViewController()]
        

        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navcontroller
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
 
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
  
    }

    func sceneWillResignActive(_ scene: UIScene) {
   
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
   
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
      
    }


}

