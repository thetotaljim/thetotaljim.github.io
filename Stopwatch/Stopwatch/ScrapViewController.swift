//
//  ScrapViewController.swift
//  Stopwatch
//
//  Created by James Steimel on 11/13/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//  THIS IS ANALOG CLOCK THAT PRINTED LINE BUT THAT WAS IT

import UIKit

class ScrapViewController: UIViewController , CAAnimationDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        /****   HERE IM ADDING THE CODE FOR WATCH HANDS *****/
        //let endAngle = CGFloat(2*M_PI)
        
        
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width))
        
        
        self.view.addSubview(newView)
        
        let time = timeCorrds(x: newView.frame.midX, y: newView.frame.midY, time: timeFrm(),radius: 50)
        
        // Hours
        let hourLayer = CAShapeLayer()
        hourLayer.frame = newView.frame
        let path = CGMutablePath()
        
        //CGPathMoveToPoint(path, nil, CGRectGetMidX(newView.frame), CGRectGetMidY(newView.frame))
        path.move(to: CGPoint(x: newView.frame.midX, y: newView.frame.midY))
        path.addLine(to: CGPoint(x: time.h.x, y: time.h.y))
        hourLayer.path = path
        hourLayer.lineWidth = 4
        hourLayer.lineCap = kCALineCapRound
        hourLayer.strokeColor = UIColor.black.cgColor
        
        hourLayer.rasterizationScale = UIScreen.main.scale;
        hourLayer.shouldRasterize = true
        
        self.view.layer.addSublayer(hourLayer)
        
        // Do any additional setup after loading the view.
        
        rotateLayer(currentLayer: hourLayer, dur:43200)
        
    }
    
    
    func rotateLayer(currentLayer:CALayer,dur:CFTimeInterval){
        
        let angle = degree2radian(a: 360)
        
        // rotation http://stackoverflow.com/questions/1414923/how-to-rotate-uiimageview-with-fix-point
        let theAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        theAnimation.duration = dur
        // Make this view controller the delegate so it knows when the animation starts and ends
        theAnimation.delegate = self
        theAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        // Use fromValue and toValue
        theAnimation.fromValue = 0
        theAnimation.repeatCount = Float.infinity
        theAnimation.toValue = angle
        
        // Add the animation to the layer
        currentLayer.add(theAnimation, forKey:"rotate")
        
    }
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func timeCorrds(x:CGFloat, y:CGFloat, time:(h:Int,m:Int,s:Int), radius: CGFloat, adjustment:CGFloat=90)-> (h:CGPoint, m:CGPoint, s:CGPoint) {
        let cx = x      // x origin
        let cy = y      // y origin
        var r = radius    // radius of circle
        var point = [CGPoint]()
        var angle = degree2radian(a: 6)
        
        func newPoint (t: Int) {
            let xpo = cx - r * cos(angle * CGFloat(t)+degree2radian(a: adjustment))
            let ypo = cy - r * sin(angle * CGFloat(t)+degree2radian(a: adjustment))
            point.append(CGPoint(x: xpo, y: ypo))
        }
        
        //  work out hours first
        var hours = time.h
        if hours > 12 {
            hours = hours-12
        }
        
        let hoursInSeconds = time.h*3600 + time.m*60 + time.s
        newPoint(t: hoursInSeconds*5/3600)
        
        //  work out minutes second
        r = radius*1.25
        let minutesInSeconds =  time.m*60 + time.s
        
        newPoint(t: minutesInSeconds/60)
        
        // work out seconds last
        r = radius * 1.5
        newPoint(t: time.s)
        return (h:point[0],m:point[1],s:point[2])
        
    }

    func timeFrm() -> (h:Int, m:Int, s:Int){
        
        let dateFormatter = DateFormatter()
        let formatStrings = ["hh","mm","ss"]
        var hms = [Int]()
        
        for f in formatStrings {
            
            dateFormatter.dateFormat = f
            let date = Date()
            
            if let formattedDateString = Int(dateFormatter.string(from: date)) {
                hms.append(formattedDateString)
            }
        }
        
        return (h:hms[0], m:hms[1], s:hms[2])
    }
    
    func degree2radian(a: CGFloat) -> CGFloat {
        let b = CGFloat(M_PI)*(a/180)
        return b
    }

    /*****  HERE IS AN ADDED TIME FORMATTING FUNCTION       *********/
    
    func time() -> (h:Int, m:Int, s:Int){
        
        let dateFormatter = DateFormatter()
        let formatStrings = ["hh","mm","ss"]
        var hms = [Int]()
        
        for f in formatStrings {
            
            dateFormatter.dateFormat = f
            let date = Date()
            
            if let formattedDateString = Int(dateFormatter.string(from: date)) {
                hms.append(formattedDateString)
            }
        }
        
        return (h:hms[0], m:hms[1], s:hms[2])
    }
    /*
    func degree2radian(a: CGFloat) -> CGFloat {
        let b = CGFloat(M_PI)*(a/180)
        return b
    }
    */
    /******     End added function                  *******************/
    
    /****       HERE IS THE TIME COORDINATES FUNCTION      ************/
    /*
    func timeCorrds(x:CGFloat, y:CGFloat, time:(h:Int,m:Int,s:Int), radius: CGFloat, adjustment:CGFloat=90)-> (h:CGPoint, m:CGPoint, s:CGPoint) {
        let cx = x      // x origin
        let cy = y      // y origin
        var r = radius    // radius of circle
        var point = [CGPoint]()
        var angle = degree2radian(a: 6)
        
        func newPoint (t: Int) {
            let xpo = cx - r * cos(angle * CGFloat(t)+degree2radian(a: adjustment))
            let ypo = cy - r * sin(angle * CGFloat(t)+degree2radian(a: adjustment))
            point.append(CGPoint(x: xpo, y: ypo))
        }
        
        //  work out hours first
        var hours = time.h
        if hours > 12 {
            hours = hours-12
        }
        
        let hoursInSeconds = time.h*3600 + time.m*60 + time.s
        newPoint(t: hoursInSeconds*5/3600)
        
        //  work out minutes second
        r = radius*1.25
        let minutesInSeconds =  time.m*60 + time.s
        
        newPoint(t: minutesInSeconds/60)
        
        // work out seconds last
        r = radius * 1.5
        newPoint(t: time.s)
        return (h:point[0],m:point[1],s:point[2])
        
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
 }
 
    */
 
}*/
}
