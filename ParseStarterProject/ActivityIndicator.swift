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
    var isShowLabel: Bool!
    var HUDColor: UIColor!
    var elementsColor: UIColor!
    
    //--------------------------------------
    // MARK: - Init Methods
    //--------------------------------------

    init(view: UIView, HUDSize: CGFloat) {

        self.HUDSize = HUDSize
        
        self.insertToView = view
        
    }
    
    convenience init(largeActivityView view: UIView) {
        self.init(view: view, HUDSize: 100.0)
        self.isShowLabel = true
        self.HUDColor = Helpers.getRedColor(0.95)
        self.elementsColor = Helpers.getNudeColor()
        
        self.buildHUD()
        self.buildLoadingLabel()
        self.buildActivityIndicator()
    }

    convenience init(smallActivityView view: UIView) {
        self.init(view: view, HUDSize: 40.0)
        self.isShowLabel = false
        self.HUDColor = self.getBlackColor()
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
        let heightPointsToSubstract: CGFloat = self.isShowLabel == true ? 10 : -1
        let widthPointsToAdd: CGFloat = self.isShowLabel == true ? 3 : 1
        self.activityIndicatorView = NVActivityIndicatorView(
            frame: CGRectMake(self.HUD.bounds.width / 2 - indicatorSize / 2 + widthPointsToAdd, self.HUD.bounds.height / 2 - indicatorSize / 2 - heightPointsToSubstract, indicatorSize, indicatorSize),
            type: NVActivityIndicatorType.BallRotateChase,
            color: self.elementsColor,
            padding: indicatorSize
        )
        self.activityIndicatorView.hidesWhenStopped = true
        
        self.HUD.addSubview(self.activityIndicatorView)
    }
    
    private func buildLoadingLabel() {
        let loadingLabel: UILabel = UILabel(frame: CGRectMake(self.HUD.bounds.width / 2 - 20, self.HUD.bounds.height - 30, self.HUD.bounds.width, 20))
        loadingLabel.text = getLocalizedString("loading")
        loadingLabel.textColor = self.elementsColor
        loadingLabel.numberOfLines = 0
        loadingLabel.textAlignment = NSTextAlignment.Center
        loadingLabel.font = UIFont(name: "Alef-Regular", size: 14)
        loadingLabel.sizeToFit()
        
        self.HUD.addSubview(loadingLabel)
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