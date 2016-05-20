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
        self.HUDColor = Helpers.getRedColor(0.95)
        self.elementsColor = Helpers.getNudeColor()
        
        
        self.buildHUD()
        if let isShowLabel = self.options["isShowLabel"] as? Bool where isShowLabel {
            self.buildLabel()
        }
        self.buildActivityIndicator()
    }

    convenience init(smallActivityView view: UIView) {
        self.init(view: view, HUDSize: 40.0)
        self.HUDColor = self.getBlackColor()
        self.options["isShowLabel"] = false
        self.elementsColor = self.getGrayColor()
        
        self.buildHUD()
        self.buildActivityIndicator()
    }

    private func buildHUD() {
        let HUDSize: CGFloat = self.HUDSize
        let frame = CGRectMake(UIScreen.mainScreen().bounds.width / 2 - HUDSize / 2, self.insertToView.bounds.height / 2 - HUDSize / 2, HUDSize, HUDSize)
        self.HUD = UIView(frame: frame)
        self.HUD.backgroundColor = self.HUDColor
        
        let maskPath = UIBezierPath(roundedRect: self.HUD.bounds,
                                    byRoundingCorners: .AllCorners,
                                    cornerRadii: CGSize(width: 10.0, height: 10.0)
        )
        let maskLayer = CAShapeLayer(layer: maskPath)
        maskLayer.frame = self.HUD.bounds
        maskLayer.path = maskPath.CGPath
        self.HUD.layer.mask = maskLayer
    }
    
    private func buildActivityIndicator() {
        let indicatorSize: CGFloat = 0.4 * self.HUDSize
        var isShowLabel = true
        if let isShowLabelFromOptions = self.options["isShowLabel"] as? Bool {
            isShowLabel = isShowLabelFromOptions
        }
        let heightPointsToSubstract: CGFloat = isShowLabel ? 10 : -1
        let widthPointsToAdd: CGFloat = isShowLabel ? 3 : 1

        self.activityIndicatorView = NVActivityIndicatorView(
            frame: CGRectMake(self.HUD.bounds.width / 2 - indicatorSize / 2 + widthPointsToAdd, self.HUD.bounds.height / 2 - indicatorSize / 2 - heightPointsToSubstract, indicatorSize, indicatorSize),
            type: NVActivityIndicatorType.BallRotateChase,
            color: self.elementsColor,
            padding: indicatorSize
        )
        self.activityIndicatorView.hidesWhenStopped = true
        
        self.HUD.addSubview(self.activityIndicatorView)
    }
    
    private func buildLabel() {
        let label: UILabel = UILabel(frame: CGRectMake(self.HUD.bounds.width / 2 - 20, self.HUD.bounds.height - 30, self.HUD.bounds.width, 20))
        var labelText = getLocalizedString("loading")
        if let labelTextFromOptions = options["labelText"] as? String {
            labelText = labelTextFromOptions
        }
        label.text = labelText
        label.textColor = self.elementsColor
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "Alef-Regular", size: 14)
        label.sizeToFit()
        
        self.HUD.addSubview(label)
    }
    
    private func getBlackColor() -> UIColor {
        return UIColor(red:0.26, green:0.27, blue:0.27, alpha:0.95)
    }

    private func getGrayColor() -> UIColor {
        return UIColor(red:0.87, green:0.89, blue:0.91, alpha:1.0)
    }

    //--------------------------------------
    // MARK: - Helper Methods
    //--------------------------------------
    
    private func setDefaultOptions(options: [String: AnyObject]) -> [String: AnyObject] {
        var retOptions = options
        if retOptions["isShowLabel"] == nil {
           retOptions["isShowLabel"] = true
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