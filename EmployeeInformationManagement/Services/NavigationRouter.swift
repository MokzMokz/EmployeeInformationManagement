//
//  NavigationRouter.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit
import Foundation

enum NavigationRouterEvent{
    case WillPresentViewController
    case DidPresentViewController
    case WillDismissViewController
    case DidDismissViewController
    case WillPresentContactCardViewController
    case WillPresentAddContactViewController
    case WillPresentEditContactViewController
    case WillPresentAlertController
    case WillPresentImagePicker
    case WillPresentCallScreen
}

extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}

class NavigationRouter : NSObject {
    
    private static let _shared = NavigationRouter()
    private var isInitialized : Bool = false
    weak var queuedViewController : UIViewController? = nil//might need to change to a lsit
    
    static func shared() -> NavigationRouter{
        return _shared
    }
    
    func initialize(){
        if isInitialized == false {
            rootViewController = UIApplication.shared.keyWindow?.rootViewController
            currentViewController = rootViewController
            let vc = UIViewController.init()
            vc.swizzlePresent()
            vc.swizzlePrepareForSegue()
            vc.swizzleDismiss()
            let seg = UIStoryboardSegue.init(identifier: "token", source: vc, destination: vc)
            seg.swizzlePerform(segue: seg)
            isInitialized = true
            let nav = UINavigationController.init()
            nav.swizzlePop()
            nav.swizzlePush()
        }
    }
    
  
    weak var rootViewController : UIViewController? = nil
    weak var _currentViewController : UIViewController? = nil
    
    weak var currentViewController : UIViewController?{
        get{
            return _currentViewController ?? rootViewController
        }
        set{
            if newValue == nil {
                
                print("assigning currentviewcontrroller to nil")
                
            }
            else{
               _currentViewController = newValue
            }
            
        }
    }
    
//    func presentCallView(number : String, willShow: ((CallViewController) -> Void)? = nil,
//                     didShow: ((CallViewController) -> Void)? = nil){
//
//        self.presentModal(fromStoryboard: CallViewController.self, identifier: "callViewController", willShow: { (vc) in
//            vc.viewModel.makeCall(recipient: number)
//            if willShow != nil {
//                willShow!(vc)
//            }
//        }, didShow: nil)
//    }
    
    func pushEditEmployee(employee: Employee) {
        guard let vc = self.initFromStoryBoard(type: EditEmployeeViewController.self, identifier: "EditEmployeeViewController") else {
            return
        }
        
        vc.employee = employee
        guard let navigation = self.currentViewController as? UINavigationController else {
            return
        }
        
        navigation.pushViewController(vc, animated: true)
    }
    
    func presentEditEmployee(company: Company,
                             willShow: ((EmployeeListViewController) -> Void)? = nil,
                             didShow: ((EmployeeListViewController) -> Void)? = nil) {
       
        guard let vc = self.initFromStoryBoard(type: EditEmployeeViewController.self, identifier: "EditEmployeeViewController") else {
            return
        }
        vc.type = .add
        vc.company = company
        let navigation = UINavigationController(rootViewController: vc)
        presentModal(viewController: navigation, willShow: nil, didShow: nil, animated: false)
    }
    
    func presentEmployee(company: Company,
                         willShow: ((EmployeeListViewController) -> Void)? = nil,
                         didShow: ((EmployeeListViewController) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let employeeListViewController = storyboard.instantiateViewController(withIdentifier: "EmployeeListViewControllerNavigation") as! UINavigationController
        employeeListViewController.modalPresentationStyle = .overFullScreen
        
        if let vc = employeeListViewController.viewControllers.first as? EmployeeListViewController {
            vc.company = company
        }
        presentModal(viewController: employeeListViewController, willShow: nil, didShow: nil, animated: false)
    }
    
    
    func presentModal<T>(viewController : T,
                         willShow: ((T) -> Void)?,
                         didShow: ((T) -> Void)?, animated : Bool){
        
        queuedViewController = (viewController as! UIViewController)
        
        weak var weakSelf = self

        if isInitialized{
            if willShow != nil {
                willShow!(viewController)
            }
            
            DispatchQueue.main.async {
                weakSelf?.currentViewController?.present(viewController as! UIViewController, animated: animated, completion: {
                    weakSelf!.queuedViewController = nil
                    if didShow != nil {
                        didShow!(viewController)
                    }
                  
                })
            }
        }
    }
    
    func presentModal<T>(viewController : T,
                      willShow: ((T) -> Void)?,
                      didShow: ((T) -> Void)?){

        weak var weakSelf = self

        if willShow != nil {
            willShow!(viewController)
        }
        
        DispatchQueue.main.async {
            weakSelf?.currentViewController?.present(viewController as! UIViewController, animated: true, completion: {
                if didShow != nil {
                    didShow!(viewController)
                }
            })
        }
    }
    
    func presentModal<T>(fromStoryboard type : T.Type, identifier : String,
         willShow: ((T) -> Void)? = nil,
         didShow: ((T) -> Void)? = nil) -> Void{
        let retVal = initFromStoryBoard(type: type, identifier: identifier)
        self.presentModal(viewController: (retVal ?? nil)!, willShow: willShow, didShow: didShow)
    }
    
    func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        currentViewController?.dismiss(animated: flag, completion: completion)
    }
    
    func dismissToRoot(animated flag: Bool, completion: (() -> Void)? = nil){
        rootViewController?.dismiss(animated: flag, completion: completion)
    }
    
    //viewcontroller factory function
    func initFromStoryBoard<T>(type : T.Type,storyBoardName : String , identifier : String) -> T? {
        
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        var retVal : T? = nil
        
        retVal = storyboard.instantiateViewController(withIdentifier: identifier) as? T
        
        return retVal;
    }
    
    func initFromStoryBoard<T>(type : T.Type, identifier : String) -> T? {
        return initFromStoryBoard(type: type, storyBoardName: "Main", identifier: identifier)
    }
}

// start native class murdering
extension UIViewController {
    
    class Wrapper {
        let value: Any?
        init(_ value: Any?) {
            self.value = value
        }
    }
    
    var navigationRouter : NavigationRouter {
        return NavigationRouter.shared()
    }
    
    typealias willShowViewControllerHandler = (_ from : UIViewController, _ viewController : UIViewController) -> Void
    typealias didShowViewControllerHandler = (_ from : UIViewController, _ to : UIViewController) -> Void
    
    @nonobjc static var willShowViewControllerHandlerKey = "willShowViewControllerHandlerKey"
    @nonobjc static var didShowViewControllerHandlerKey = "didShowViewControllerHandlerKey"
    
    var willShowHandler: willShowViewControllerHandler? {
        get {
            let wrapper = objc_getAssociatedObject(self, &UIViewController.willShowViewControllerHandlerKey) as? Wrapper
            return wrapper?.value as? willShowViewControllerHandler
        }
        set {
            objc_setAssociatedObject(self, &UIViewController.willShowViewControllerHandlerKey, Wrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var didShowHandler: didShowViewControllerHandler? {
        get {
            let wrapper = objc_getAssociatedObject(self, &UIViewController.didShowViewControllerHandlerKey) as? Wrapper
            return wrapper?.value as? didShowViewControllerHandler
        }
        set {
            objc_setAssociatedObject(self, &UIViewController.didShowViewControllerHandlerKey, Wrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    func performSegue(withIdentifier identifier: String, sender: Any?, willShow: @escaping willShowViewControllerHandler, didShow: @escaping didShowViewControllerHandler) {
        willShowHandler = willShow
        didShowHandler = didShow
        performSegue(withIdentifier: identifier, sender: sender)
    }
    
    func swizzlePrepareForSegue() {
        DispatchQueue.once(token: "swizzlePrepareForSegue") {
            let originalSelector = #selector(UIViewController.prepare(for:sender:))
            let swizzledSelector = #selector(UIViewController.swizzledPrepare(for:sender:))
            
            let instanceClass = UIViewController.self
            let originalMethod = class_getInstanceMethod(instanceClass, originalSelector)
            let swizzledMethod = class_getInstanceMethod(instanceClass, swizzledSelector)
            
            let didAddMethod = class_addMethod(instanceClass, originalSelector,
                                               method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            
            if didAddMethod {
                class_replaceMethod(instanceClass, swizzledSelector,
                                    method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }
    
    @objc func swizzledPrepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.swizzlePerform(segue: segue)
        if  segue.source.willShowHandler != nil {
            segue.source.willShowHandler!(segue.source,segue.destination)
        }
    }
    
    
    func swizzleDismiss() {
        DispatchQueue.once(token: "swizzleDismiss") {
            let originalSelector = #selector(UIViewController.dismiss(animated:completion:))
            let swizzledSelector = #selector(UIViewController.swizzledDismiss(animated:completion:))
            
            let instanceClass = UIViewController.self
            let originalMethod = class_getInstanceMethod(instanceClass, originalSelector)
            let swizzledMethod = class_getInstanceMethod(instanceClass, swizzledSelector)
            
            let didAddMethod = class_addMethod(instanceClass, originalSelector,
                                               method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            
            if didAddMethod {
                class_replaceMethod(instanceClass, swizzledSelector,
                                    method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }
    
    @objc func swizzledDismiss(animated flag: Bool, completion: (() -> Void)? = nil){
        NavigationRouter.shared().currentViewController = self.presentingViewController
        
        self.swizzledDismiss(animated: flag) {
            if completion != nil {
                completion!()
            }
        }
    }
    
    func swizzlePresent() {
        DispatchQueue.once(token: "swizzlePresent") {
            let originalSelector = #selector(UIViewController.present(_:animated:completion:))
            let swizzledSelector = #selector(UIViewController.swizzledPresent(_:animated:completion:))

            let instanceClass = UIViewController.self
            let originalMethod = class_getInstanceMethod(instanceClass, originalSelector)
            let swizzledMethod = class_getInstanceMethod(instanceClass, swizzledSelector)

            let didAddMethod = class_addMethod(instanceClass, originalSelector,
                                               method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))

            if didAddMethod {
                class_replaceMethod(instanceClass, swizzledSelector,
                                    method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }

    @objc open func swizzledPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
          self.swizzledPresent(viewControllerToPresent, animated: flag) {
              NavigationRouter.shared().currentViewController = viewControllerToPresent
              
              if completion != nil {
                  completion!()
              }
          }
      }
}

// start native class murdering
extension UINavigationController {
    
    class Wrapper {
        let value: Any?
        init(_ value: Any?) {
            self.value = value
        }
    }
    
    func swizzlePush() {
        DispatchQueue.once(token: "swizzlePush") {
            
            let originalSelector = #selector(UINavigationController.pushViewController(_:animated:))
            let swizzledSelector = #selector(UINavigationController.swizzledPushViewController(_:animated:))

            let instanceClass = UINavigationController.self
            let originalMethod = class_getInstanceMethod(instanceClass, originalSelector)
            let swizzledMethod = class_getInstanceMethod(instanceClass, swizzledSelector)

            let didAddMethod = class_addMethod(instanceClass, originalSelector,
                                               method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))

            if didAddMethod {
                class_replaceMethod(instanceClass, swizzledSelector,
                                    method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }
    
    func swizzlePop() {
        DispatchQueue.once(token: "swizzlePop") {
            let originalSelector = #selector(UINavigationController.popViewController(animated:))
            let swizzledSelector = #selector(UINavigationController.swizzledPopViewController(animated:))

            let instanceClass = UINavigationController.self
            let originalMethod = class_getInstanceMethod(instanceClass, originalSelector)
            let swizzledMethod = class_getInstanceMethod(instanceClass, swizzledSelector)

            let didAddMethod = class_addMethod(instanceClass, originalSelector,
                                               method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))

            if didAddMethod {
                class_replaceMethod(instanceClass, swizzledSelector,
                                    method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }
    
    @objc open func swizzledPopViewController(animated: Bool) -> UIViewController?{
        
        defer{
            if let vc = self.viewControllers.last,
               let nav = vc.navigationController {
                NavigationRouter.shared().currentViewController = nav//set current to the viewcontroller afterp popped one
            } else {
                NavigationRouter.shared().currentViewController = self.viewControllers.last!//set current to the viewcontroller afterp popped one
            }
           
        }
        
        return self.swizzledPopViewController(animated: animated)
    }
    
    @objc open func swizzledPushViewController(_ viewController: UIViewController, animated: Bool){
        if self.viewControllers.count > 0{
            NavigationRouter.shared().currentViewController = viewController//set current to the viewcontroller afterp popped one
        }
        self.swizzledPushViewController(viewController, animated: animated)
    }
}

extension UIStoryboardSegue {
    
    func swizzlePerform(segue : UIStoryboardSegue) {
        // Must be fire once time.
        DispatchQueue.once(token: "swizzlePerform") {
            let originalSelector = #selector(segue.perform as () -> Void)
            let swizzledSelector = #selector(segue.swizzledPerform)
            
            let instanceClass = UIStoryboardSegue.self
            let originalMethod = class_getInstanceMethod(instanceClass, originalSelector)
            let swizzledMethod = class_getInstanceMethod(instanceClass, swizzledSelector)
            
            let didAddMethod = class_addMethod(instanceClass, originalSelector,
                                               method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            
            if didAddMethod {
                class_replaceMethod(instanceClass, swizzledSelector,
                                    method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }
    
    @objc open func swizzledPerform() {
        defer {
            self.swizzledPerform()
            
            if  let nav = destination as? UINavigationController{
                NavigationRouter.shared().currentViewController = nav.topViewController
                print("destination is a nav controller setting to \(String(describing: nav.topViewController)) instead")
            }
            else{
                NavigationRouter.shared().currentViewController = destination
            }
            
        }
        
        if source.didShowHandler != nil {
             source.didShowHandler!(source,destination)
        }
    }
}

fileprivate extension DispatchQueue {
    
    private static var _onceTracker: [String] = []
    
    /// Return default dispatch_once in Swift.
    static func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}


