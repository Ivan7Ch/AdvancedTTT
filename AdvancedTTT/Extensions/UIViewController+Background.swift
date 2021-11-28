//
//  UIViewController+Background.swift
//  AdvancedTTT
//
//  Created by User on 28.11.2021.
//

import UIKit
import Pastel

extension UIViewController {
    
    func addBackground() {
        let pastelView = PastelView(frame: view.bounds)
        
        pastelView.startPastelPoint = .top
        pastelView.endPastelPoint = .bottom
        pastelView.animationDuration = 7.0
        
        var colors = [#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.8904744485, green: 0.8502347224, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.6813562978, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.6451833526, alpha: 1)]
        
//        if self.traitCollection.userInterfaceStyle == .dark {
            colors = [#colorLiteral(red: 0.2352941176, green: 0.2549019608, blue: 0.2823529412, alpha: 1), #colorLiteral(red: 0.1058823529, green: 0.1490196078, blue: 0.1725490196, alpha: 1), #colorLiteral(red: 0.05882352941, green: 0.2980392157, blue: 0.4588235294, alpha: 1)]
//        }
        colors = [#colorLiteral(red: 1, green: 0.1058823529, blue: 0.4196078431, alpha: 0.75), #colorLiteral(red: 0.2705882353, green: 0.7921568627, blue: 1, alpha: 0.75)]
        
        pastelView.setColors(colors)
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
}
