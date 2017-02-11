//  RAMRotationAnimation.swift
//
// Copyright (c) 11/10/14 Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import QuartzCore

/// The RAMRotationAnimation class provides rotation animation.
public class RAMRotationAnimation : RAMItemAnimation {
  
  /**
   Animation direction
   
   - Left:  left direction
   - Right: right direction
   */
  public enum RAMRotationDirection {
    case Left
    case Right
  }
 /// Animation direction (left, right)
  public var direction : RAMRotationDirection!
  
  /**
   Start animation, method call when UITabBarItem is selected
   
   - parameter icon:      animating UITabBarItem icon
   - parameter textLabel: animating UITabBarItem textLabel
   */
  override public func playAnimation(icon : UIImageView, textLabel : UILabel) {
    //playRoatationAnimation(icon)
    textLabel.textColor = textSelectedColor
  }
  
  /**
   Start animation, method call when UITabBarItem is unselected
   
   - parameter icon:      animating UITabBarItem icon
   - parameter textLabel: animating UITabBarItem textLabel
   - parameter defaultTextColor: default UITabBarItem text color
   - parameter defaultIconColor: default UITabBarItem icon color
   */
  override public func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor, defaultIconColor : UIColor) {
    textLabel.textColor = defaultTextColor
    
    if let iconImage = icon.image {
      let renderMode = CGColorGetAlpha(defaultIconColor.CGColor) == 0 ? UIImageRenderingMode.AlwaysOriginal :
        UIImageRenderingMode.AlwaysTemplate
      let renderImage = iconImage.imageWithRenderingMode(renderMode)
      icon.image = renderImage
      icon.tintColor = defaultIconColor
    }
  }
  
  /**
   Method call when TabBarController did load
   
   - parameter icon:      animating UITabBarItem icon
   - parameter textLabel: animating UITabBarItem textLabel
   */
  override public func selectedState(icon : UIImageView, textLabel : UILabel) {
    textLabel.textColor = textSelectedColor
    
    if let iconImage = icon.image {
      let renderImage = iconImage.imageWithRenderingMode(.AlwaysTemplate)
      icon.image = renderImage
      icon.tintColor = textSelectedColor
    }
  }
  
  func playRoatationAnimation(icon : UIImageView) {
    
    let rotateAnimation = CABasicAnimation(keyPath: Constants.AnimationKeys.Rotation)
    rotateAnimation.fromValue = 0.0
    
    var toValue = CGFloat(M_PI * 2.0)
    if direction != nil && direction == RAMRotationDirection.Left {
      toValue = toValue * -1.0
    }
    
    rotateAnimation.toValue = toValue
    rotateAnimation.duration = NSTimeInterval(duration)
    
    icon.layer.addAnimation(rotateAnimation, forKey: nil)
    
    if let iconImage = icon.image {
      let renderImage = iconImage.imageWithRenderingMode(.AlwaysTemplate)
      icon.image = renderImage
      icon.tintColor = iconSelectedColor
    }
  }
}

/// The RAMLeftRotationAnimation class provides letf rotation animation.
class RAMLeftRotationAnimation : RAMRotationAnimation {
  
  override init() {
    super.init()
    direction = RAMRotationDirection.Left
  }
}

/// The RAMRightRotationAnimation class provides rigth rotation animation.
class RAMRightRotationAnimation : RAMRotationAnimation {
  
  override init() {
    super.init()
    direction = RAMRotationDirection.Right
  }
}


