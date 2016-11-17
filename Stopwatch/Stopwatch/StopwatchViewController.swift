import UIKit
/*
protocol StopwatchViewDelegate: class {
    
}
*/
class StopwatchViewController: UIViewController {
    
    
    //  Added stopwatchViewDelegate
    //weak var viewDelegate: StopwatchViewDelegate?
    
    
    /********************************************/
    /*          HERE ARE MY ADDED PAGECONTROL   */
    /*      AND THE CONTAINER VIEW              */
    /********************************************/
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBAction func selectedNewPage(_ sender: AnyObject) {
    }
    @IBOutlet weak var containerView: UIView!
    
    var stopwatchPageViewController: StopwatchPageViewController? {
        didSet {
            stopwatchPageViewController?.stopwatchDelegate = self
        }
    }
    
   
    
    //  END ADDED CODE
    

	@IBOutlet weak var lapMinutesLabel: UILabel!
	@IBOutlet weak var lapSecondsLabel: UILabel!
	@IBOutlet weak var lapMillisecondsLabel: UILabel!
	@IBOutlet weak var minutesLabel: UILabel!
	@IBOutlet weak var secondsLabel: UILabel!
	@IBOutlet weak var millisecondsLabel: UILabel!
	@IBOutlet weak var lapResetButton: ControlButtonView!
	@IBOutlet weak var startStopButton: ControlButtonView!
	@IBOutlet weak var lapsTableView: UITableView!
	
	fileprivate(set) var model: StopwatchModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		model = StopwatchModel(delegate: self)
		setupDefaults()
        
        
        /*  HERE IS MORE OF MY ADDED CODE   */
        
        pageControl.addTarget(self, action: #selector(StopwatchViewController.didChangePageControlValue), for: .valueChanged)
        
        //  END ADDED CODE
        
	}
    
    /*  HERE IS AN ADDED FUNCTION   */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stopwatchPageViewController = segue.destination as? StopwatchPageViewController {
            self.stopwatchPageViewController = stopwatchPageViewController
        }
    }
    
    
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    func didChangePageControlValue() {
        stopwatchPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
	
    //  End Added function
    
    
    
    
	func setupDefaults() {
		minutesLabel.text = "00"
		secondsLabel.text = "00"
		millisecondsLabel.text = "00"
		lapMinutesLabel.text = "00"
		lapSecondsLabel.text = "00"
		lapMillisecondsLabel.text = "00"
		lapResetButton.isEnabled = false
		lapResetButton.titleLabel.text = "Lap"
		startStopButton.titleLabel.text = "Start"
		lapsTableView.reloadData()
	}

	@IBAction func lapResetButtonPressed(_ sender: AnyObject) {
        /********************************************/
        /*  Here is a Controller to Model func call */
        /********************************************/
		model.lapResetPressed()
	}
	
	@IBAction func startStopButtonPressed(_ sender: AnyObject) {
        /********************************************/
        /*  Here is a Controller to Model func call */
        /********************************************/
		model.startStopPressed()
		lapResetButton.isEnabled = true
	}
	
	fileprivate func formatTimeIntervalToString(_ time: TimeInterval) -> (minutes: String, seconds: String, milliseconds: String) {
		let minutes = (Int(time) / 60) % 60
		let seconds = Int(time) % 60
		let milliSeconds = Int(time * 100) % 100
		return (String(format: "%02d", minutes), String(format: "%02d", seconds), String(format: "%02d", milliSeconds))
	}
    /****************************************************************************/
    /*  Added function to get just the time in milliseconds                     */
    /****************************************************************************/
    fileprivate func getMilliseconds(_ time: TimeInterval) -> (Int){
        let milliSeconds = Int(time * 100) % 100
        return milliSeconds
    }
    
    
    
}


/************************************************/
/*  Here is an added extension                  */
/*                                              */
/*  PAGE VIEW STUFF                             */
/************************************************/

extension StopwatchViewController: StopwatchPageViewControllerDelegate {
    
    func stopwatchPageViewController(_ stopwatchPageViewController: StopwatchPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func stopwatchPageViewController(_ stopwatchPageViewController: StopwatchPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
}

/*********  END ADDED EXTENSION     *************/
/*                                              */
/*      Table View Stuff Below                  */
/************************************************/

// MARK: - Table View DataSource Methods
extension StopwatchViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  Controller getting data from model
		return model.laps.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Lap Cell", for: indexPath) as! LapCellTableViewCell
		
		let reverseIndex = model.laps.count - 1 - (indexPath as NSIndexPath).row
		let lap = model.laps[reverseIndex]
		let formatted = formatTimeIntervalToString(lap)
		cell.lapNumberLabel.text = "Lap \(reverseIndex + 1)"
		cell.lapTimeLabel.text = "\(formatted.minutes):\(formatted.seconds).\(formatted.milliseconds)"
		
		return cell
	}
}


/************************************************************/
/*      HERE IS THE CODE FOR MODEL TO CONTROLLER            */
 /*     FUNC CALLS                                          */
/************************************************************/
// MARK: - Stopwatch Model Delegate Methods


extension StopwatchViewController: StopwatchModelDelegate {
	/************************************************/
    /*  LAP WAS ADDED                               */
    /************************************************/
	func lapWasAdded() {
		lapsTableView.reloadData()
	}
	/************************************************/
    /*  TIMER UPDATED FUNCTION                      */
    /************************************************/
	func timerUpdated(with timestamp: TimeInterval) {
		let value = formatTimeIntervalToString(timestamp)
		minutesLabel.text = value.minutes
		secondsLabel.text = value.seconds
		millisecondsLabel.text = value.milliseconds
	}
	
	func lapUpdated(with timestamp: TimeInterval) {
		let value = formatTimeIntervalToString(timestamp)
		lapMinutesLabel.text = value.minutes
		lapSecondsLabel.text = value.seconds
		lapMillisecondsLabel.text = value.milliseconds
	}
	
	func updateLapResetButton(forState runningState: RunState) {
		switch (runningState) {
		case .stopped:
			lapResetButton.titleLabel.text = "Reset"
		case .started, .reset:
			lapResetButton.titleLabel.text = "Lap"
		}
	}
	
	func updateStartStopButton(forState runningState: RunState) {
		switch (runningState) {
		case .stopped, .reset:
			startStopButton.titleLabel.text = "Start"
			startStopButton.borderColor = UIColor.green
		case .started:
			startStopButton.titleLabel.text = "Stop"
			startStopButton.borderColor = UIColor.red
		}
	}
	
	func resetDefaults() {
		setupDefaults()
	}
}




