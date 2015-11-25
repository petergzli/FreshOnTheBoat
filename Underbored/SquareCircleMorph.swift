//
//  SquareCircleMorph.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/13/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    static let blue = UIColor(red: 108 / 255.0, green: 189 / 255.0, blue: 232 / 255.0, alpha: 1.0)
    static let red = UIColor(red: 245 / 255.0, green: 150 / 255.0, blue: 151 / 255.0, alpha: 1.0)
    static let redPurple = UIColor(red: 154 / 255.0, green: 149 / 255.0, blue: 201 / 255.0, alpha: 1.0)
    static let redPurpleLight = UIColor(red: 154 / 255.0, green: 149 / 255.0, blue: 201 / 255.0, alpha: 0.54)
    static let green = UIColor(red: 116 / 255.0, green: 198 / 255.0, blue: 163 / 255.0, alpha: 1.0)
    static let bluePurple = UIColor(red: 188 / 255.0, green: 132 / 255.0, blue: 186 / 255.0, alpha: 1.0)
    static let lightGrey = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10)
    static let mediumGrey = UIColor(red: 0, green: 0, blue: 0, alpha: 0.54)
    static let white = UIColor.whiteColor()
    static let clear = UIColor.clearColor()
}

class SquareMorpher: CAShapeLayer {
    
    let animationDuration: CFTimeInterval = 0.25
    
    override init() {
        super.init()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(view: UIView, color: UIColor) {
        path = squarePathWithCenter(CGPoint(x: view.bounds.origin.x + view.bounds.height/2, y: view.bounds.origin.y + view.bounds.width/2), side: view.frame.size.width).CGPath
        frame = view.bounds
        fillColor = color.CGColor
        lineCap = kCALineCapRound
    }
    
    func expand(view: UIView) {
        let expandAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        expandAnimation.fromValue = squarePathWithCenter(CGPoint(x: view.bounds.origin.x + view.bounds.height/2, y: view.bounds.origin.y + view.bounds.width/2), side: view.frame.size.width).CGPath
        expandAnimation.toValue = squarePathCornerWithCenter(CGPoint(x: view.bounds.origin.x + view.bounds.height/2, y: view.bounds.origin.y + view.bounds.width/2), side: view.frame.size.width).CGPath
        expandAnimation.duration = animationDuration
        expandAnimation.fillMode = kCAFillModeBoth
        expandAnimation.removedOnCompletion = false
        addAnimation(expandAnimation, forKey: nil)
    }
    
    func contract(view: UIView) {
        let contractAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        contractAnimation.fromValue = squarePathCornerWithCenter(CGPoint(x: view.bounds.origin.x + view.bounds.height/2, y: view.bounds.origin.y + view.bounds.width/2), side: view.frame.size.width).CGPath
        contractAnimation.toValue = squarePathWithCenter(CGPoint(x: view.bounds.origin.x + view.bounds.height/2, y: view.bounds.origin.y + view.bounds.width/2), side: view.frame.size.width).CGPath
        
        
        contractAnimation.duration = animationDuration
        contractAnimation.fillMode = kCAFillModeForwards
        contractAnimation.removedOnCompletion = false
        addAnimation(contractAnimation, forKey: nil)
    }
    
    func circlePathWithCenter(center: CGPoint, radius: CGFloat) -> UIBezierPath {
        let circlePath = UIBezierPath()
        circlePath.addArcWithCenter(center, radius: radius, startAngle: -CGFloat(M_PI), endAngle: -CGFloat(M_PI/2), clockwise: true)
        circlePath.addArcWithCenter(center, radius: radius, startAngle: -CGFloat(M_PI/2), endAngle: 0, clockwise: true)
        circlePath.addArcWithCenter(center, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI/2), clockwise: true)
        circlePath.addArcWithCenter(center, radius: radius, startAngle: CGFloat(M_PI/2), endAngle: CGFloat(M_PI), clockwise: true)
        circlePath.closePath()
        return circlePath
    }
    
    func squarePathWithCenter(center: CGPoint, side: CGFloat) -> UIBezierPath {
        let squarePath = UIBezierPath()
        let startX = center.x - side / 2
        let startY = center.y - side / 2
        squarePath.moveToPoint(CGPoint(x: startX, y: startY))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.addLineToPoint(CGPoint(x: startX + side, y: startY))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.addLineToPoint(CGPoint(x: startX + side, y: startY + side))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.addLineToPoint(CGPoint(x: startX + side/2 + side/12, y: startY + side))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.addLineToPoint(CGPoint(x: startX + side/2, y: startY + side))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.addLineToPoint(CGPoint(x: startX + side/2 - side/12, y: startY + side))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.addLineToPoint(CGPoint(x: startX, y: startY + side))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.closePath()
        return squarePath
    }
    
    func squarePathCornerWithCenter(center: CGPoint, side: CGFloat) -> UIBezierPath {
        let squarePath = UIBezierPath()
        let startX = center.x - side / 2
        let startY = center.y - side / 2
        squarePath.moveToPoint(CGPoint(x: startX, y: startY))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.addLineToPoint(CGPoint(x: startX + side, y: startY))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.addLineToPoint(CGPoint(x: startX + side, y: startY + side))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.addLineToPoint(CGPoint(x: startX + side/2 + side/12, y: startY + side))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.addLineToPoint(CGPoint(x: startX + side/2, y: startY + side + side/12))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.addLineToPoint(CGPoint(x: startX + side/2 - side/12, y: startY + side))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.addLineToPoint(CGPoint(x: startX, y: startY + side))
        squarePath.addLineToPoint(squarePath.currentPoint)
        squarePath.closePath()
        return squarePath
    }
}