//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIView {
    var screenScale: CGFloat? {
        window?.screen.scale
    }
}

extension CGRect {
    func retinaRounded(scale: CGFloat?) -> CGRect {
        guard let scale, scale > 1.0 else { return self }
        return CGRect(origin: origin.retinaRounded(scale: scale),
                      size: size.retinaRounded(scale: scale))
    }
}

extension Double {
    func retinaRounded(scale: CGFloat?) -> Double {
        guard let scale, scale > 1.0 else { return self }
        return (self * scale).rounded(.toNearestOrAwayFromZero) / scale
    }
}

extension CGFloat {
    func retinaRounded(scale: CGFloat?) -> CGFloat {
        guard let scale, scale > 1.0 else { return self }
        return (self * scale).rounded(.toNearestOrAwayFromZero) / scale
    }
}

extension CGPoint {
    func retinaRounded(scale: CGFloat?) -> CGPoint {
        guard let scale, scale > 1.0 else { return self }
        return CGPoint(x: x.retinaRounded(scale: scale), y: y.retinaRounded(scale: scale))
    }
}

extension CGSize {
    func retinaRounded(scale: CGFloat?) -> CGSize {
        guard let scale, scale > 1.0 else { return self }
        return CGSize(width: width.retinaRounded(scale: scale), height: height.retinaRounded(scale: scale))
    }
}

extension UIControl {
    @objc static var debounceDelay: Double = 0.5
    @objc func debounce(delay: Double = UIControl.debounceDelay, siblings: [UIControl] = []) {
        let buttons = [self] + siblings
        buttons.forEach { $0.isEnabled = false }
        let deadline = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            buttons.forEach { $0.isEnabled = true }
        }
     }
}

#endif

func onMain(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    }
    else {
        DispatchQueue.main.async(execute: block)
    }
}
