//
//  FaceView.swift
//  Happiness
//
//  Created by Rajiv on 12/10/17.
//  Copyright © 2017 Pedscapades. All rights reserved.
//

import UIKit

protocol FaceViewDataSource: class {
    func smilinessForFaceView(sender: FaceView) -> Double?
}

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    @IBInspectable var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    @IBInspectable var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }

    var faceCenter: CGPoint {
        return convert(center, from:superview)
    }
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) * scale / 2
    }
    
    weak var dataSource: FaceViewDataSource?
    
    override func draw(_ rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        
        facePath.stroke()
        
        bezierPathForEye(whichEye: .Left).stroke()
        bezierPathForEye(whichEye: .Right).stroke()
        
        let smiliness = dataSource?.smilinessForFaceView(sender: self) ?? 0.0
        bezierPathForSmile(fractionOfMaxSmile: smiliness).stroke()
    }
    
    private struct Scaling {
        static let faceRadiusToEyeRadiusRatio: CGFloat = 10
        static let faceRadiusToEyeOffsetRatio: CGFloat = 3
        static let faceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let faceRadiusToMouthWidthRatio: CGFloat = 1
        static let faceRadiusToMouthHeightRatio: CGFloat = 3
        static let faceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye { case Left, Right }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Scaling.faceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.faceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.faceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        path.lineWidth = lineWidth
        
        return path
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath {
        let mouthWidth = faceRadius / Scaling.faceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.faceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.faceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth/3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth/3, y: cp1.y)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
    }

}
