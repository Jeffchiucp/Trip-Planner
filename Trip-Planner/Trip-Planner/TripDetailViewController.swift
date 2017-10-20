//
//  TripDetailViewController.swift
//  Trip-Planner
//
//  Created by Elmer Astudillo on 10/17/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController {
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var waypointDestination: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var tripCompletion: UIButton!
    
    var trip : Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        destinationLabel.text = trip?.destination
        startDateLabel.text = trip?.startDate
        endDateLabel.text = trip?.endDate
        waypointDestination.text = trip?.waypointDestination
        latitudeLabel.text = String(describing:trip?.latitude)
        longitudeLabel.text = String(describing: trip?.longitude)
//        tripCompletion.setTitle(tri, for: UIControlState())

        // Do any additional setup after loading the view.
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
