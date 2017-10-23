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
    @IBOutlet weak var completedTripButton: UIButton!
    
    var trip : Trip?
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.completedTripButton.setTitle("Completed", for: .selected)
        
        destinationLabel.text = trip?.destination
        startDateLabel.text = trip?.startDate
        endDateLabel.text = trip?.endDate
        waypointDestination.text = trip?.waypointDestination
        guard let latitude = trip?.latitude else {return}
        guard let longitude = trip?.longitude else {return}
        latitudeLabel.text = String(describing:latitude)
        longitudeLabel.text = String(describing:longitude)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func completedTripBttnPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "Not Completed"
        {
            sender.setTitle("Completed", for: UIControlState())
        }
        else if sender.titleLabel?.text == "Completed"
        {
            sender.setTitle("Not Completed", for: UIControlState())
        }
        
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if completedTripButton.titleLabel?.text == "Completed"
        {
            let tripCompleted = true
            let updatedTrip = Trip(destination: self.trip?.destination, completed: tripCompleted, email: self.trip?.email, startDate: self.trip?.startDate, endDate: self.trip?.endDate, waypointDestination: self.trip?.waypointDestination, latitude: self.trip?.latitude, longitude: self.trip?.longitude)
            NetworkService.fetch(route: Route.trips(), user: user, trip: updatedTrip, httpMethod: .put, completionHandler: { (data, int) in
                if int == 200
                {
                    print("Success")
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
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
