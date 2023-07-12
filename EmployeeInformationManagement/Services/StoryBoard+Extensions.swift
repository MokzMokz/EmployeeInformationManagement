//
//  StoryBoard+Extensions.swift
//  EmployeeInformationManagement
//
//  Created by Collabera on 7/12/23.
//

import Foundation
import UIKit
extension UIStoryboard {

    enum Storyboard: String {
        case main
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    enum StoryBoardIdentifier: String {
        case editEmployee
        case addEmployee
    }
    
    class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
    
}

extension StoryboardInitializable where Self: Coordinator {
    /**
     define in protocol file
     
     */
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static var storyboardName: UIStoryboard.Storyboard {
        return UIStoryboard.Storyboard.main
    }
    static func instantiateViewController() -> UIViewController {
        let storyboard = UIStoryboard.storyboard(storyboard: storyboardName)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier)
        
    }
}
