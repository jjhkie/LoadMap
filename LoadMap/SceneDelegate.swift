//
//  SceneDelegate.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        enum TabBarIndex: Int, CaseIterable {
            case home, note, calendar, fail

            var title: String {
                switch self {
                case .home:
                    return "Home"
                case .note:
                    return "메모"
                case .calendar:
                    return "Calendar"
                case .fail:
                    return "Fail"
                }
            }

            var image: UIImage? {
                switch self {
                case .home:
                    return UIImage(systemName: "house")
                case .note:
                    return UIImage(systemName: "note")
                case .calendar:
                    return UIImage(systemName: "calendar")
                case .fail:
                    return UIImage(systemName: "pencil")
                }
            }

            var selectedImage: UIImage? {
                switch self {
                case .home:
                    return UIImage(systemName: "house.fill")
                case .note:
                    return UIImage(systemName: "note.fill")
                case .calendar:
                    return UIImage(systemName: "calendar.fill")
                case .fail:
                    return UIImage(systemName: "pencil.line")
                }
            }

            var viewController: UIViewController {
                switch self {
                case .home:
                    return UINavigationController(rootViewController: MainView(viewModel: MainViewModel()))
                case .note:
                    return UINavigationController(rootViewController: LogsView(viewModel: LogsViewModel()))
                case .calendar:
                    return CalendarLineView()
                case .fail:
                    return TaskView(viewModel: TaskViewModel())
                }
            }

            var tabBarItem: UITabBarItem {
                let item = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
                return item
            }
        }

        let tabBar = UITabBarController()
        tabBar.tabBar.tintColor = .layerFourColor
        tabBar.tabBar.barTintColor = .blue
        tabBar.tabBar.backgroundColor = .white
        let viewControllers = TabBarIndex.allCases.map {
            let viewController = $0.viewController
            viewController.tabBarItem = $0.tabBarItem
            return viewController
        }
        tabBar.viewControllers = viewControllers
       
        
        
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}


}

