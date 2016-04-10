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
    
    //--------------------------------------
    // MARK: - Init Methods
    //--------------------------------------

    init(view: UIView) {

        self.insertToView = view
        
        self.buildHUD()
        
        self.buildActivityIndicator()
        
        self.buildLoadingLabel()
    }
    
    private func buildHUD() {
        let HUDSize: CGFloat = 100.0
        let frame = CGRectMake(self.insertToView.bounds.width / 2 - HUDSize / 2, self.insertToView.bounds.height / 2 - HUDSize / 2 - 60, HUDSize, HUDSize)
        self.HUD = UIView(frame: frame)
        self.HUD.backgroundColor = UIColor(red:0.95, green:0.72, blue:0.37, alpha:0.95)
        
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
        let indicatorSize: CGFloat = 40.0
        self.activityIndicatorView = NVActivityIndicatorView(
            frame: CGRectMake(self.HUD.bounds.width / 2 - indicatorSize / 2 + 3, self.HUD.bounds.height / 2 - indicatorSize / 2 - 10, indicatorSize, indicatorSize),
            type: NVActivityIndicatorType.BallRotateChase,
            color: UIColor(red:0.69, green:0.29, blue:0.29, alpha:1.0),
            padding: 40
        )
        self.activityIndicatorView.hidesWhenStopped = true
        
        self.HUD.addSubview(self.activityIndicatorView)
    }
    
    private func buildLoadingLabel() {
        let loadingLabel: UILabel = UILabel(frame: CGRectMake(self.HUD.bounds.width / 2 - 20, self.HUD.bounds.height - 30, self.HUD.bounds.width, 20))
        loadingLabel.text = getLocalizedString("loading")
        loadingLabel.textColor = UIColor(red:0.69, green:0.29, blue:0.29, alpha:1.0)
        loadingLabel.numberOfLines = 0
        loadingLabel.textAlignment = NSTextAlignment.Center
        loadingLabel.font = UIFont(name: "Alef-Regular", size: 14)
        loadingLabel.sizeToFit()
        
        self.HUD.addSubview(loadingLabel)
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