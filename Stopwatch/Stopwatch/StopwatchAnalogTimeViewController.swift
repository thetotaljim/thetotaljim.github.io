//
//  StopwatchAnalogTimeViewController.swift
//  Stopwatch
//
//  Created by James Steimel on 11/9/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

protocol StopwatchAnalogDelegate : class {
    
    func analogLapWasAdded()
    func analogTimerUpdated(with timestamp: TimeInterval)
    func analogLapUpdated(with timestamp: TimeInterval)
    func analogUpdateLapResetButton(forState runningState: RunState)
    func analogUpdateStartStopbutton(forState runningState: RunState)
    func analogResetDefaults()
}



class StopwatchAnalogTimeViewController: UIViewController, CAAnimationDelegate {
    
    @IBOutlet weak var clockView: UIImageView!
    @IBOutlet weak var myClockView: UIView!
  
    //  Added model 
    
    weak var delegate: StopwatchAnalogDelegate?
    
    func updateTheStopwatchHand() {
       // watchView.transform = CGAffineTransform(rotationAngle: (45 * CGFloat(M_PI)/180.0))
        print("this happened")
        
        
    }
    
    let watchView = WatchView()
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        myClockView.addSubview(watchView)
        
        //self.delegate = delegate
        //Added model intialization
        //model = StopwatchModel(delegate: self)
        
        
        /*
        let lay4 = CALayer()
        let im  = UIImage(named: "stopwatch-light")
        
        lay4.frame = myClockView.frame
        lay4.contents = im?.cgImage
        
        myClockView.layer.addSublayer(lay4)
         */
        //self.myClockView.contentMode = UIViewContentMode.scaleAspectFit
        //self.clockView.image = UIImage(named: "stopwatch-light")
       
        //self.myClockView.contentMode = UIViewContentMode.scaleAspectFit
        
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
    
    
}
