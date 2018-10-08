//
//  LinearProgressBar.swift
//  CookMinute
//
//  Created by Philippe Boisney on 18/11/2015.
//  Copyright © 2015 CookMinute. All rights reserved.
//
//  Google Guidelines: https://www.google.com/design/spec/components/progress-activity.html#progress-activity-types-of-indicators
//

import UIKit

public class LinearProgressBar: UIView {
    
    //FOR DATA
    private var screenSize: CGRect = UIScreen.main.bounds
    private var isAnimationRunning = false
    
    //FOR DESIGN
    private var progressBarIndicator: UIView!
    
    //PUBLIC VARS
    public var backgroundProgressBarColor: UIColor = UIColor(red:0.73, green:0.87, blue:0.98, alpha:1.0)
    public var progressBarColor: UIColor = UIColor(red:0.12, green:0.53, blue:0.90, alpha:1.0)
    public var heightForLinearBar: CGFloat = 5
    public var widthForLinearBar: CGFloat = 0
    
    public init () {
        super.init(frame: CGRect(x: 0, y: 20, width: screenSize.width, height: 0))
        self.progressBarIndicator = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: heightForLinearBar))
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.progressBarIndicator = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: heightForLinearBar))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LIFE OF VIEW
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.screenSize = UIScreen.main.bounds
        
        if widthForLinearBar == 0 || widthForLinearBar == self.screenSize.height {
            widthForLinearBar = self.screenSize.width
        }
        
        
        
        if (UIDeviceOrientation.landscapeLeft == UIDevice.current.orientation || UIDeviceOrientation.landscapeRight == UIDevice.current.orientation) {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: widthForLinearBar, height: self.frame.height)
        }
        
        if (UIDeviceOrientation.portrait == UIDevice.current.orientation || UIDeviceOrientation.portrait == UIDevice.current.orientation) {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: widthForLinearBar, height: self.frame.height)
        }
    }
    
    //MARK: PUBLIC FUNCTIONS    ------------------------------------------------------------------------------------------
    
    //Start the animation
    public func startAnimation(){

        self.configureColors()

        if !isAnimationRunning {
            self.isAnimationRunning = true

            UIView.animate(withDuration: 0.5, delay:0, options: [], animations: {
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.widthForLinearBar, height: self.heightForLinearBar)
                }, completion: { animationFinished in
                    self.addSubview(self.progressBarIndicator)
                    self.configureAnimation()
            })
        }
    }
    
    //Start the animation
    public func stopAnimation() {
        
        self.isAnimationRunning = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: self.widthForLinearBar, height: 0)
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.widthForLinearBar, height: 0)
        })
    }
    
    //MARK: PRIVATE FUNCTIONS    ------------------------------------------------------------------------------------------
    
    private func configureColors(){
        
        self.backgroundColor = self.backgroundProgressBarColor
        self.progressBarIndicator.backgroundColor = self.progressBarColor
        self.layoutIfNeeded()
    }
    
    private func configureAnimation() {
        
        guard let superview = self.superview else {
            stopAnimation()
            return
        }

        self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: 0, height: heightForLinearBar)

        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: self.widthForLinearBar*0.7, height: self.heightForLinearBar)
            })

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.progressBarIndicator.frame = CGRect(x: superview.frame.width, y: 0, width: 0, height: self.heightForLinearBar)

            })

        }) { (completed) in
            if (self.isAnimationRunning){
                self.configureAnimation()
            }
        }
    }
}
