//
//  TripsViewController.swift
//  Trip-Planner
//
//  Created by Elmer Astudillo on 10/17/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController {
    
    var trips = [Trip]()
    var user : User?

    @IBOutlet weak var tripsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let currentUser = user else { return }
        
        NetworkService.fetch(route: Route.trips(), user: currentUser , httpMethod: .get) { (data, response) in
            print("This is the current status \(data) \(response)")
            let trips = try? JSONDecoder().decode([Trip].self, from: data)
            //guard let trips = trip?.trips else { return }
            guard let allTrips = trips else {return}
            self.trips = allTrips
            DispatchQueue.main.async {
                self.tripsTableView.reloadData()
            }
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

extension TripsViewController : UITableViewDelegate
{
    
}

extension TripsViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = trips[indexPath.row]
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let tripDetailVC = storyboard.instantiateViewController(withIdentifier: "TripDetailViewController") as! TripDetailViewController
        tripDetailVC.trip = trip
        self.navigationController?.pushViewController(tripDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! TripCell
        let trip = trips[indexPath.row]
        cell.destinationLabel.text = trip.destination
        cell.startDateLabel.text = trip.startDate
        
        return cell
    }
}
