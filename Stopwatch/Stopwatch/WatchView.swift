//
//  WatchView.swift
//  Stopwatch
//
//  Created by James Steimel on 11/13/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

class WatchView: UIView {
    
    private(set) var watchLayer: WatchLayer?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing codeet layer
       
        let image = UIImageView(image: UIImage(named: "stopwatch-light"))
        image.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(image)
        
    }
   */
    
    /*
    override func draw(_ rect: CGRect) {

    
        // Drawing code
        //  obtain context
        let ctx = UIGraphicsGetCurrentContext()
        //  radius
        let rad = rect.width/2.01
        //let rad = rect.width/3.5
        
        //let endAngle = CGFloat(2*M_PI)
        
        //  add circle to the context
        //CGContextAddArc(ctx, rect.midX, rect.midY, rad, 0, endAngle, 1)
        
        //let center = CGPoint(x: rect.midX, y: rect.midY)
        // possible change 60 -> 360
        
        for i in 1...240 {
            
            //  save the original position and origin
            ctx?.saveGState()
            //  make translation
            ctx?.translateBy(x: rect.midX, y: rect.midY)
            //  make rotation
            //  possible chang CGFloat(i)*6 -> CGFloat(i)
            ctx?.rotate(by: degree2radian(a: CGFloat(i)*1.5))//*6))
            if i % 20 == 0 {
                drawSecondMarker(ctx: ctx!, x: rad-20, y: 0, radius: rad, color: UIColor.black)
            }
            else if i % 4 == 0 {
                drawSecondMarker(ctx: ctx!, x: rad-15, y: 0, radius: rad, color: UIColor.gray)
            }
            else  {
                drawSecondMarker(ctx: ctx!, x: rad-10, y: 0, radius: rad, color: UIColor.gray)
            }
            ctx?.restoreGState()
        }
 
 
        drawText(rect:rect, ctx: ctx!, x: rect.midX, y: rect.midY, radius: rad, sides: 12, color: UIColor.black)
    }*/*/
    
    
    override func draw(_ rect: CGRect) {
        watchLayer?.frame = rect
        layer.addSublayer(watchLayer!)
        watchLayer?.setNeedsDisplay()
    }
    
    /*
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
    
    //  To then draw the second markers a further function is necessary:
    func secondMarkers(ctx:CGContext, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) {
        // retrieve points
        let points = circleCircumferencePoints(sides: sides,x: x,y: y,radius: radius)
        // create path
        let path = CGMutablePath()
        // determine length of marker as a fraction of the total radius
        var divider:CGFloat = 1/16
        for p in points.enumerated(){
            if p.offset % 5 == 0 {
                divider = 1/8
                print("Working out of 1/8")
            }
            else {
                divider = 1/16
                print("Working out of 1/8")
            }
            
            let xn = p.element.x + divider*(x-p.element.x)
            let yn = p.element.y + divider*(y-p.element.y)
            // build path
            path.move(to: CGPoint(x: p.element.x, y: p.element.y))
            //CGPathMoveToPoint(path, nil, p.element.x, p.element.y)
            path.addLine(to: CGPoint(x: xn, y: yn))
            //CGPathAddLineToPoint(path, nil, xn, yn)
            //CGPathCloseSubpath(path)
            path.closeSubpath()
            // add path to context
            //CGContextAddPath(ctx, path)
            ctx.addPath(path)
        }
        // set path color
        let cgcolor = color.cgColor
        ctx.setStrokeColor(cgcolor)
        ctx.setLineWidth(1.5)
        ctx.strokePath()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup () {
        
    }
    
    /*  HERE IS CODE FOR NUMBERS ON FACE        */
    
    func drawText(rect:CGRect, ctx:CGContext, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) {
        
        // Flip text co-ordinate space
        ctx.translateBy(x: 0.0, y: rect.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        // dictates on how inset the ring of numbers will be
        let inset:CGFloat = radius/3.5
        // An adjustment of 270 degrees to position numbers correctly
        let points = circleCircumferencePoints(sides: sides,x: x,y: y,radius: radius-inset,adjustment:270)
        let path = CGMutablePath()
        
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
 */
}
