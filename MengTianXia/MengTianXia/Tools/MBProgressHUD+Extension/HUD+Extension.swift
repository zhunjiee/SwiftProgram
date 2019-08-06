//
//  BWLoading.swift
//  MengTianXia
//
//  Created by zl on 2019/7/26.
//  Copyright © 2019 LuMeng. All rights reserved.
//

import MBProgressHUD

extension MBProgressHUD {
    // MARK: -  显示基本信息
    class func show(_ text: String?, icon iconName: String?, view: UIView?, delay: TimeInterval) {
        if (text?.count ?? 0) == 0 {
            return
        }
        var view = view
        if view == nil {
            view = UIApplication.shared.keyWindow
        }
        
        //在显示新的之前需要隐藏掉旧的，否则会导致多个loading页面重叠
        hide(for: view!, animated: true)
        
        let hud = MBProgressHUD.showAdded(to: view!, animated: true)
        hud.bezelView.layer.cornerRadius = 8.0
        var renderMode: UIImage.RenderingMode = .alwaysTemplate
        
        if BWLoadingStyleManager.sharedInstance.hudStyle == .grayBackgroundStyle {
            //灰白色背景+icon 和背景同色
            renderMode = .alwaysTemplate
            hud.bezelView.style = .blur //单色背景
        }
        if BWLoadingStyleManager.sharedInstance.hudStyle == .dimBackgroundStyle {
            //老版本样式，带透明度的黑色背景+白色icon
            renderMode = .alwaysOriginal
            hud.bezelView.backgroundColor = UIColor.black.withAlphaComponent(1.0) //黑色背景
            hud.backgroundColor = UIColor.black.withAlphaComponent(0.3) // 整个view背景
            hud.contentColor = UIColor.white
        }
        
        hud.label.text = text
        let image = (UIImage(named: iconName ?? ""))?.withRenderingMode(renderMode)
        hud.customView = UIImageView(image: image)
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
        // 保证任务在主线程执行
        DispatchQueue.main.async {
            hud.hide(animated: true, afterDelay: delay)
        }
    }
    
    // MARK: - 显示带icon的信息，自定义时长
    class func showSuccess(_ success: String?, to view: UIView?, delay: TimeInterval) {
        self.show(success, icon: "bw_success", view: view, delay: delay)
    }
    
    class func showError(_ error: String?, to view: UIView?, delay: TimeInterval) {
        self.show(error, icon: "bw_error", view: view, delay: delay)
    }
    
    class func showWarning(_ warning: String?, to view: UIView?, delay: TimeInterval) {
        self.show(warning, icon: "bw_warning", view: view, delay: delay)
    }
    
    class func showText(_ text: String?, to view: UIView?, delay: TimeInterval) {
        self.show(text, icon: nil, view: view, delay: delay)
    }
    
    // MARK: -  显示带icon的信息, 默认时长
    class func showSuccess(_ success: String?, to view: UIView?) {
        show(success, icon: "bw_success", view: view, delay: BWLoadingStyleManager.sharedInstance.hudShowTime)
    }
    
    class func showError(_ error: String?, to view: UIView?) {
        show(error, icon: "bw_error", view: view, delay: BWLoadingStyleManager.sharedInstance.hudShowTime)
    }
    
    class func showWarning(_ warning: String?, to view: UIView?) {
        show(warning, icon: "bw_warning", view: view, delay: BWLoadingStyleManager.sharedInstance.hudShowTime)
    }
    
    class func showText(_ text: String?, to view: UIView?) {
        show(text, icon: "", view: view, delay: BWLoadingStyleManager.sharedInstance.hudShowTime)
    }
    
    // MARK: -  显示loading状态
    class func showMessage(_ message: String?, to view: UIView?) {
        var view = view
        if view == nil {
            view = UIApplication.shared.keyWindow
        }
        
        //在显示新的之前需要隐藏掉旧的，否则会导致多个loading页面重叠
        hide(for: view!, animated: true)
        
        let hud = MBProgressHUD.showAdded(to: view!, animated: true)
        hud.bezelView.layer.cornerRadius = 8.0
        hud.label.text = message
        hud.removeFromSuperViewOnHide = true
        
        if BWLoadingStyleManager.sharedInstance.hudStyle == .grayBackgroundStyle {
            //灰白色背景+icon 和背景同色
            hud.bezelView.style = .blur //单色背景
        }
        if BWLoadingStyleManager.sharedInstance.hudStyle == .dimBackgroundStyle {
            //老版本样式，带透明度的黑色背景+白色icon
            hud.bezelView.backgroundColor = UIColor.black.withAlphaComponent(1.0) //黑色背景
            hud.backgroundColor = UIColor.black.withAlphaComponent(0.3) // 整个view背景
            hud.contentColor = UIColor.white
        }
    }
    
    class func showDetailMessage(_ message: String?, to view: UIView?, delay: TimeInterval) {
        if (message?.count ?? 0) == 0 {
            return
        }
        var view = view
        if view == nil {
            view = UIApplication.shared.keyWindow
        }
        
        //在显示新的之前需要隐藏掉旧的，否则会导致多个loading页面重叠
        hide(for: view!, animated: true)
        
        let hud = MBProgressHUD.showAdded(to: view!, animated: true)
        hud.bezelView.layer.cornerRadius = 8.0
        hud.detailsLabel.text = message
        hud.removeFromSuperViewOnHide = true
        
        if BWLoadingStyleManager.sharedInstance.hudStyle == .grayBackgroundStyle {
            //灰白色背景+icon 和背景同色
            hud.bezelView.style = .blur //单色背景
        }
        if BWLoadingStyleManager.sharedInstance.hudStyle == .dimBackgroundStyle {
            //老版本样式，带透明度的黑色背景+白色icon
            hud.bezelView.backgroundColor = UIColor.black.withAlphaComponent(1.0) //黑色背景
            hud.backgroundColor = UIColor.black.withAlphaComponent(0.3) // 整个view背景
            hud.contentColor = UIColor.white
        }
        
        // 保证任务在主线程执行
        DispatchQueue.main.async {
            hud.hide(animated: true, afterDelay: delay)
        }
    }
    
    // MARK: -  隐藏HUD
    class func hideHUD() {
        guard let winView = UIApplication.shared.delegate?.window as? UIView else { return }
        hide(for: winView, animated: true)
        
        guard let view = getCurrentUIVC()?.view else { return }
         hide(for: view, animated: true)
    }
    
    // MARK: -  获取当前window视图
    
    //获取当前屏幕显示的viewcontroller
    class func getCurrentWindowVC() -> UIViewController? {
        var window = UIApplication.shared.keyWindow
        // app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
        if window?.windowLevel != .normal {
            let windows = UIApplication.shared.windows
            for tmpWin in windows {
                if tmpWin.windowLevel == .normal {
                    window = tmpWin
                    break
                }
            }
        }
        
        var nextResponder: Any?
        let rootVC = window?.rootViewController
        // 1、通过present弹出VC，rootVC.presentedViewController不为nil
        if let responder = rootVC?.presentedViewController {
            nextResponder = responder
        } else {
            // 2、通过navigationcontroller弹出VC
            let frontView = window?.subviews.first
            nextResponder = frontView?.next
        }
        
        return nextResponder as? UIViewController
    }
    
    class func getCurrentNavVC() -> UINavigationController? {
        let viewVC = getCurrentWindowVC()
        var navVC: UINavigationController?
        if viewVC is UITabBarController {
            if let tabBar = viewVC as? UITabBarController {
                navVC = tabBar.viewControllers?[tabBar.selectedIndex] as? UINavigationController
                while navVC?.presentedViewController != nil {
                    navVC = navVC?.presentedViewController as? UINavigationController
                }
            }
            
        } else if (viewVC is UINavigationController) {
            navVC = viewVC as? UINavigationController
            while navVC?.presentedViewController != nil {
                navVC = navVC?.presentedViewController as? UINavigationController
            }
            
        } else if (viewVC != nil) {
            if viewVC?.navigationController != nil {
                return viewVC?.navigationController
            }
            return viewVC as? UINavigationController
        }
        return navVC
    }
    
    class func getCurrentUIVC() -> UIViewController? {
        var vc: UIViewController?
        let nav = getCurrentNavVC()
        if nav != nil {
            vc = nav?.viewControllers.last
            if vc?.children.count ?? 0 > 0 {
                vc = getSubUIVCWith(viewController: vc!)
            }
        } else {
            vc = nav
        }
        return vc
    }
    
    class func getSubUIVCWith(viewController: UIViewController) -> UIViewController? {
        var cc: UIViewController?
        cc = viewController.children.last
        if cc?.children.count ?? 0 > 0 {
            let _  = getSubUIVCWith(viewController: cc!)
        } else {
            return cc
        }
        return cc
    }
}
