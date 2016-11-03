//
//  ActivityIndicatorHelper.swift
//  Recipes
//
//  Created by Ori Dahan on 10/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ActivityIndicator {

    var activityIndicatorView: NVActivityIndicatorView!
    var insertToView: UIView!
    var HUD: UIView!
    
    var HUDSize: CGFloat!
    var options: [String: AnyObject] = [:]
    var HUDColor: UIColor!
    var elementsColor: UIColor!
    
    //--------------------------------------
    // MARK: - Init Methods
    //--------------------------------------

    init(view: UIView, HUDSize: CGFloat) {
        self.HUDSize = HUDSize
        self.insertToView = view
    }
    
    convenience init(largeActivityView view: UIView, options: [String: AnyObject] = [:]) {
        self.init(view: view, HUDSize: 100.0)
        self.options = self.setDefaultOptions(options)
        self.HUDColor = Helpers.sharedInstance.getRedColor(0.95)
        self.elementsColor = Helpers.sharedInstance.getNudeColor()
        
        
        self.buildHUD()
        if let isShowLabel = self.options["isShowLabel"] as? Bool, isShowLabel {
            self.buildLabel()
        }
        self.buildActivityIndicator()
    }

    convenience init(smallActivityView view: UIView) {
        self.init(view: view, HUDSize: 40.0)
        self.HUDColor = self.getBlackColor()
        self.options["isShowLabel"] = false as AnyObject?
        self.elementsColor = self.getGrayColor()
        
        self.buildHUD()
        self.buildActivityIndicator()
    }

    fileprivate func buildHUD() {
        let HUDSize: CGFloat = self.HUDSize
        let frame = CGRect(x: UIScreen.main.bounds.width / 2 - HUDSize / 2, y: self.insertToView.bounds.height / 2 - HUDSize / 2, width: HUDSize, height: HUDSize)
        self.HUD = UIView(frame: frame)
        self.HUD.backgroundColor = self.HUDColor
        
        let maskPath = UIBezierPath(roundedRect: self.HUD.bounds,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: 10.0, height: 10.0)
        )
        let maskLayer = CAShapeLayer(layer: maskPath)
        maskLayer.frame = self.HUD.bounds
        maskLayer.path = maskPath.cgPath
        self.HUD.layer.mask = maskLayer
    }
    
    fileprivate func buildActivityIndicator() {
        let indicatorSize: CGFloat = 0.4 * self.HUDSize
        var isShowLabel = true
        if let isShowLabelFromOptions = self.options["isShowLabel"] as? Bool {
            isShowLabel = isShowLabelFromOptions
        }
        let heightPointsToSubstract: CGFloat = isShowLabel ? 10 : -1
        let widthPointsToAdd: CGFloat = isShowLabel ? 3 : 1

        self.activityIndicatorView = NVActivityIndicatorView(
            frame: CGRect(x: self.HUD.bounds.width / 2 - indicatorSize / 2 + widthPointsToAdd, y: self.HUD.bounds.height / 2 - indicatorSize / 2 - heightPointsToSubstract, width: indicatorSize, height: indicatorSize),
            type: NVActivityIndicatorType.ballRotateChase,
            color: self.elementsColor,
            padding: indicatorSize
        )
        self.activityIndicatorView.hidesWhenStopped = true
        
        self.HUD.addSubview(self.activityIndicatorView)
    }
    
    fileprivate func buildLabel() {
        let label: UILabel = UILabel(frame: CGRect(x: self.HUD.bounds.width / 2 - 20, y: self.HUD.bounds.height - 30, width: self.HUD.bounds.width, height: 20))
        var labelText = getLocalizedString("loading")
        if let labelTextFromOptions = options["labelText"] as? String {
            labelText = labelTextFromOptions
        }
        label.text = labelText
        label.textColor = self.elementsColor
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.font = Helpers.sharedInstance.getTextFont()
        label.sizeToFit()
        
        self.HUD.addSubview(label)
    }
    
    fileprivate func getBlackColor() -> UIColor {
        return UIColor(red:0.26, green:0.27, blue:0.27, alpha:0.95)
    }

    fileprivate func getGrayColor() -> UIColor {
        return UIColor(red:0.87, green:0.89, blue:0.91, alpha:1.0)
    }

    //--------------------------------------
    // MARK: - Helper Methods
    //--------------------------------------
    
    fileprivate func setDefaultOptions(_ options: [String: AnyObject]) -> [String: AnyObject] {
        var retOptions = options
        if retOptions["isShowLabel"] == nil {
           retOptions["isShowLabel"] = true as AnyObject?
        }
        return retOptions
    }
    
    func show() {
        self.activityIndicatorView.startAnimation()
        self.insertToView.addSubview(self.HUD)
    }
    
    func hide() {
        self.activityIndicatorView.stopAnimation()
        self.HUD.removeFromSuperview()
    }
    
    func isAnimating() -> Bool {
        return self.activityIndicatorView.animating
    }
}
