//
//  UIView+BlurEffect.swift
//  Movies-app
//
//  Created by Oleh on 01.12.2024.
//

import UIKit

extension UIView {
    
    func applyBlurEffect(alpha: CGFloat = 0.5) {
        let blurEffect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .dark : .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        self.alpha = alpha
    }
}
