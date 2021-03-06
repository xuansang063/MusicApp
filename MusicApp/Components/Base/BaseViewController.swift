
//
//  BaseViewController.swift
//  MusicApp
//
//  Created by admin on 22/03/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

enum NavigationStyle {
    case left
    case right
}

class BaseViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .ChangeLanguage, object: nil)
        NotificationCenter.default.removeObserver(self, name: .ChangeRegion, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotification()
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeLanguage(notification:)), name: .ChangeLanguage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeRegion(notification:)), name: .ChangeRegion, object: nil)
    }
    
    @objc func didChangeLanguage(notification: Notification) {
        self.didChangeLanguage()
    }
    
    @objc func didChangeRegion(notification: Notification) {
        self.didChangeRegion()
    }
    
    @objc func pullToRefreshData() {
        
    }
    
    func didChangeLanguage() {
        
    }
    
    func didChangeRegion() {
        
    }
    
    func setUpNavigation() {
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = false
        navigationItem.setHidesBackButton(true, animated: true)
    }

    func showLargeTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    
    @objc func backButtonTapped() {
        self.pop()
    }
    
    func hideTabbar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabbar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func dismissKeyBoard() {
        self.view.endEditing(true)
    }
}

// MARK: For Navigation
extension BaseViewController {

    func hideNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func showNavigation() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setTitle(title: String) {
        self.navigationItem.title = title
    }
    
    func push(controller: UIViewController, animated: Bool = true) {
        controller.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(controller, animated: animated)
    }

    func pop(animated: Bool = true ) {
        self.navigationController?.popViewController(animated: animated)
    }

    func present(controller: UIViewController, animated: Bool = true) {
        self.present(controller, animated: animated, completion: nil)
    }

    func dismiss(animated: Bool = true) {
        self.dismiss(animated: animated, completion: nil)
    }
    
    func loadVideo(videoView: YTPlayerView, item: Item?) {
        let playvarsDic = ["playsinline": 1, "origin" : "http://www.youtube.com"] as [String : Any]
        if let utubeModel = item, let videoId = utubeModel.id {
            videoView.load(withVideoId: videoId, playerVars: playvarsDic)
        }
    }
}

extension BaseViewController {
    
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
    }
}
