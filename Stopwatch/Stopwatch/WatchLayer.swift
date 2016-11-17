//
//  WatchLayer.swift
//  Stopwatch
//
//  Created by James Steimel on 11/13/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

class WatchLayer: CALayer {
    
    private var armLayer = CALayer()
    
    override func draw(in ctx: CGContext) {
        
        UIGraphicsPushContext(ctx)
    
    
        let circle = CAShapeLayer()
        circle.lineWidth = 2.0
        circle.bounds = bounds
 
        let rad = bounds.width/2.01
        
        /*
        for i in 1...240 {
            ctx.saveGState()
            
        }
        */
        
        for i in 1...240 {
            //  save the original position and origin
            ctx.saveGState()
            //  make translation
            ctx.translateBy(x: circle.bounds.midX, y: circle.bounds.midY)
            //  make rotation
            //  possible chang CGFloat(i)*6 -> CGFloat(i)
            ctx.rotate(by: degree2radian(a: CGFloat(i)*1.5))//*6))
            if i % 20 == 0 {
                drawSecondMarker(ctx: ctx, x: rad-20, y: 0, radius: rad, color: UIColor.black)
            }
            else if i % 4 == 0 {
                drawSecondMarker(ctx: ctx, x: rad-15, y: 0, radius: rad, color: UIColor.gray)
            }
            else  {
                drawSecondMarker(ctx: ctx, x: rad-10, y: 0, radius: rad, color: UIColor.gray)
            }
            ctx.restoreGState()
        }
        
        let rect = CGRect(x: circle.bounds.midX, y: circle.bounds.midY, width: circle.bounds.width, height: circle.bounds.height)
        
        drawText(rect: rect , ctx: ctx, x: circle.bounds.midX, y: circle.bounds.midY, radius: rad, sides: 12, color: UIColor.black)
        
        /// Arrow
        //let arrow = CALayer()
        armLayer.bounds = bounds
        armLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        armLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        armLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(12 * M_PI / 2)))
        armLayer.contents = arrowImage()?.cgImage
        
        addSublayer(circle)
        addSublayer(armLayer)
 
        UIGraphicsPopContext()
    }
    
        /*
        circle.fillColor = UIColor(red: 0.9, green: 0.95, blue: 0.93, alpha: 0.9).cgColor
        circle.strokeColor = UIColor.gray.cgColor
        let path = CGMutablePath()
        path.addEllipse(in: bounds.insetBy(dx: 3, dy: 3))
        circle.path = path
        circle.bounds = bounds
        circle.position = CGPoint(x: bounds.midX, y: bounds.midY)
        addSublayer(circle)
 */
    
    func degree2radian(a: CGFloat) -> CGFloat {
        let b = CGFloat(M_PI)*(a/180)
        return b
    }
    
    func drawSecondMarker(ctx: CGContext, x: CGFloat, y: CGFloat, radius: CGFloat, color:UIColor){
        
        //  generate a path
        let path = CGMutablePath()
        //  move to starting point on edge of circle
        path.move(to: CGPoint(x: radius, y: 0.0 ))
        
        //  the above is different from original code due to changes
        //  in Swift 3 : missing the nil part
        path.addLine(to: CGPoint(x: x, y: y) )
        path.closeSubpath()
        ctx.addPath(path)
        ctx.setLineWidth(1.5)
        ctx.setStrokeColor(color.cgColor)
        ctx.strokePath()
        
    }

    func circleCircumferencePoints(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint] {
        let angle = degree2radian(a: 360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(a: adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(a: adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i -= 1;
        }
        return points
    }

    func drawText(rect:CGRect, ctx:CGContext, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) {
    
        // Flip text co-ordinate space
        ctx.translateBy(x: 0.0, y: rect.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        // dictates on how inset the ring of numbers will be
        let inset:CGFloat = radius/4.5
        // An adjustment of 270 degrees to position numbers correctly
        let points = circleCircumferencePoints(sides: sides,x: x,y: y,radius: radius-inset,adjustment:270)
        //let path = CGMutablePath()
    
        for p in points.enumerated() {
            if p.offset > 0 {
                let aFont = UIFont(name: "HelveticaNeue-Light", size: radius/8)
                // create a dictionary of attributes to be applied to the string
                let attr : CFDictionary = [NSFontAttributeName: aFont!,  NSForegroundColorAttributeName:UIColor.black] as CFDictionary
                // create the attributed string
                let val = p.offset*5
                let text = CFAttributedStringCreate(nil, val.description as CFString!, attr)
                // create the line of text
                let line = CTLineCreateWithAttributedString(text!)
                // retrieve the bounds of the text
                let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useOpticalBounds)
                // set the line width to stroke the text with
                ctx.setLineWidth(1.5)
                // set the drawing mode to stroke
                ctx.setTextDrawingMode(CGTextDrawingMode.fillStroke)
                // Set text position and draw the line into the graphics context, text length and height is adjusted for
                let xn = p.element.x - bounds.width/2
                let yn = p.element.y - bounds.midY
                //CGContextSetTextPosition(ctx, xn, yn)
                ctx.textPosition = CGPoint(x: xn, y: yn)
                // draw the line of text
                CTLineDraw(line, ctx)
            }
        }
        
    }
    
    func arrowImage() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), false, 1.0)
        
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.move(to: CGPoint(x: frame.width/2, y: 25 ))
            ctx.addLine(to: CGPoint(x: frame.width/2, y: frame.height/2))
            ctx.setLineWidth(2)
            ctx.setFillColor(UIColor.red.cgColor)
            ctx.setStrokeColor(UIColor.red.cgColor)
            ctx.strokePath()
            
            /// Arrowhead
            
            
           
            /*
            ctx.move(to: CGPoint(x: frame.width/2 - 20, y: 25))
            ctx.addLine(to: CGPoint(x: frame.width/2, y: 0))
            ctx.addLine(to: CGPoint(x: frame.width/2 + 20, y: 25))
            ctx.fillPath()
 
            
            ///cutout at the bottom
            ctx.move(to: CGPoint(x: frame.width/2 - 10, y: frame.width/2))
            ctx.addLine(to: CGPoint(x: frame.width/2, y: frame.height/2 - 10))
            ctx.addLine(to: CGPoint(x: frame.width/2 + 10, y: frame.height/2))
            ctx.setBlendMode(CGBlendMode.clear)
            ctx.fillPath()
            */
            
            let arrowImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return arrowImage
        }
        return nil
    }
    
    func rotateArrow(with transform: CGAffineTransform) {
        CATransaction.setAnimationDuration(0.01)
        armLayer.setAffineTransform(transform)
    }
}
