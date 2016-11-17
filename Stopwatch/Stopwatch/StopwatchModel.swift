import Foundation

protocol StopwatchModelDelegate: class {
	func lapWasAdded()
	func timerUpdated(with timestamp: TimeInterval)
	func lapUpdated(with timestamp: TimeInterval)
	func updateLapResetButton(forState runningState: RunState)
	func updateStartStopButton(forState runningState: RunState)
	func resetDefaults()
}


extension StopwatchModel: StopwatchAnalogDelegate {
    
    func analogLapWasAdded(){
        
    }
    func analogTimerUpdated(with timestamp: TimeInterval){
        fakeModel?.updateTheStopwatchHand()
    }
    func analogLapUpdated(with timestamp: TimeInterval){
        
    }
    func analogUpdateLapResetButton(forState runningState: RunState){
        
    }
    func analogUpdateStartStopbutton(forState runningState: RunState){
        
    }
    func analogResetDefaults(){
        
    }
    
}

/****************************************************/
/*  Secondary added Delegate for my Analog View     */
/****************************************************/
/*
protocol StopwatchModelAnalogDelegate: class {
    
    func analogLapWasAdded()
    func analogTimerUpdated(with timestamp: TimeInterval)
    func analogLapUpdated(with timestamp: TimerInterval)
    func analogUpdateLapResetButton(forState runningState: RunState)
    func analogUpdateStartStopbutton(forState runningState: RunState)
    func analogResetDefaults()
    
}
 */

class StopwatchModel {
    
    /************************************************/
    /*  Here i will try and connect the model to    */
    /*  the analog controller                       */
    /************************************************/
    fileprivate(set) var fakeModel: StopwatchAnalogTimeViewController!
    
    
    
	weak var delegate: StopwatchModelDelegate?
    
	fileprivate(set) var laps: [TimeInterval] = []
	fileprivate var timer: Timer?
	fileprivate var runState: RunState
	
	fileprivate var startTime: Date?
	fileprivate var lapStartTime: Date?
	fileprivate var masterTimeInterval: TimeInterval = 0
	fileprivate var lapTimeInterval: TimeInterval = 0
	
	init(delegate: StopwatchModelDelegate) {
		
        self.delegate = delegate
		runState = .reset
        //  AAAAADDDDDEEEEEDDD ADDED
        //fakeModel = StopwatchAnalogTimeViewController()
        /************************************************/
        /*  So we will see if we can change the analog  */
        /*  view with the "fakeModel"                   */
        /************************************************/
        
	}
	
    /****************************************************/
    /*      Here is a Function that is called from      */
    /*      from the Controller delegate                */
    /*                                                  */
    /*      LAP RESET PRESSED                           */
    /****************************************************/
	func lapResetPressed() {
		switch (runState) {
		case .started:
			addLap()
		case .stopped:
			runState = .reset
			invalidateTimer()
            /********************************************/
            /*  Here is a Model to Controller delegate  */
            /*  func call                               */
            /********************************************/
			delegate?.resetDefaults()
            //analogDelegate?.analogResetDefaults()
			return
		case .reset:
			break
		}
		/************************************************/
        /*  Here is a Model to Controller delegate func */
        /************************************************/
		delegate?.updateLapResetButton(forState: runState)
        //analogDelegate?.analogUpdateLapResetButton(forState: runState)
	}
	
    /****************************************************/
    /*  Here is a function that is called from the      */
    /*  Controller delegate                             */
    /*                                                  */
    /*  START STOP PRESSED                              */
    /****************************************************/
	func startStopPressed() {
		switch (runState) {
		case .started:
			//Stop the timer
			if let startDate = startTime, let lapDate = lapStartTime {
				masterTimeInterval += Date().timeIntervalSince(startDate)
				lapTimeInterval += Date().timeIntervalSince(lapDate)
			}
			timer?.invalidate()
			runState = .stopped
		case .stopped:
			runState = .started
			fallthrough
		case .reset:
			startTime = Date()
			lapStartTime = startTime
			timer = Timer(timeInterval: 0.001, target: self, selector: #selector(StopwatchModel.updateTimeInterval(_:)), userInfo: nil, repeats: true)
			RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
			runState = .started
		}
        /************************************************/
        /*      Here is a Model to Controller delegate  */
        /*      func call                               */
        /************************************************/
		delegate?.updateStartStopButton(forState: runState)
		delegate?.updateLapResetButton(forState: runState)
	}
	
	fileprivate func addLap() {
		guard let lapTime = lapStartTime else {
			return
		}
		let value = Date().timeIntervalSince(lapTime)
		lapStartTime = Date()
		lapTimeInterval = 0
		laps.append(value)
        /************************************************/
        /*      Here is a Model to Controller delegate  */
        /*      func call                               */
        /************************************************/
		delegate?.lapWasAdded()
        //analogDelegate.analogLapWasAdded()
		delegate?.lapUpdated(with: lapTimeInterval)
        //analogDelegate.analogLapWasAdded()
	}
	
	@objc func updateTimeInterval(_ timer: AnyObject) {
		guard let lapTime = lapStartTime,
			let watchTime = startTime else {
			return
		}
		let lapValue = Date().timeIntervalSince(lapTime) + lapTimeInterval
		let stopWatchValue = Date().timeIntervalSince(watchTime) + masterTimeInterval
        /************************************************/
        /*      Here is a Model to Controller delegate  */
        /*      func call                               */
        /************************************************/
		delegate?.lapUpdated(with: lapValue)
        //analogDelegate.analogLapUpdated(with: lapValue)
		delegate?.timerUpdated(with: stopWatchValue)
        //analogDelgate.analogTimerUpdated(with: stopWatchValue)
        fakeModel.updateTheStopwatchHand( )
    }
    /*
    func convertMillisecondsToCGAffineTransform() -> CGAffineTransform {
    
    
    
    
    }
	*/
	fileprivate func invalidateTimer() {
		timer?.invalidate()
		masterTimeInterval = 0
		lapTimeInterval = 0
		laps = []
	}
    
    /********************************************************/
    /*  Here is code added to try and update the analog     */
    /*  timer by finding milliseconds                       */
    /********************************************************/
    /****************************************************************************/
    /*  Added function to get just the time in milliseconds                     */
    /****************************************************************************/
    fileprivate func getMilliseconds(_ time: TimeInterval) -> (Int){
        let milliSeconds = Int(time * 100) % 100
        return milliSeconds
    }
    
}
