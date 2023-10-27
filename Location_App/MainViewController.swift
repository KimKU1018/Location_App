//
//  ViewController.swift
//  Location_App
//
//  Created by KU Kim on 2023/10/25.
//

import UIKit
import MapKit

class MainViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var searchController: UISearchController!
    
    var resultsController: SearchResultsTableViewController!
    
    var filteredLandmarks = [PinLandmark]()
    
    let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Landmark"
        
        mapView.delegate = self
        
        addPin()
        
        makeResultsController()
        makeSearchController()
        
        locationManager.getMyLocation { location in
            // 받은 location 정보 위치로 이동
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            
            self.mapView.setRegion(region, animated: true)
            self.mapView.showsUserLocation = true 
        }
        
    
        
        
    }
    
    private func makeResultsController() {
        resultsController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultsTableViewController") as? SearchResultsTableViewController
        resultsController.tableView.delegate = self
        resultsController.tableView.dataSource = self
    }
    
    private func makeSearchController() {
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        navigationItem.searchController = searchController
    }
    
    private func addPin() {
        PinLandmark.allCases.forEach { landmark in
            
            let pin = MyPointAnnotation()
            pin.title = landmark.title
            pin.coordinate = landmark.coordinate
            pin.id = landmark.id
            self.mapView.addAnnotation(pin)
        
        }
        
    }

}


extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let hasView = view.annotation as? MyPointAnnotation else {
            return
        }
       
        let selectedPin = PinLandmark(rawValue: hasView.id)
        
        
        // move to detailVC
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.url = selectedPin?.url
        self.navigationItem.title = selectedPin?.title
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        self.mapView.deselectAnnotation(view.annotation, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredLandmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
        
        cell.title.text = filteredLandmarks[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(filteredLandmarks[indexPath.row].id)
        
        guard let selectedPin = PinLandmark(rawValue:
                                                filteredLandmarks[indexPath.row].id) else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let resign = MKCoordinateRegion(center: selectedPin.coordinate, span: span)
        
        self.mapView.setRegion(resign, animated: true)
        
        searchController.isActive = false
        
        self.navigationItem.title = selectedPin.title
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        let pinAllList = PinLandmark.allCases
        
        filteredLandmarks = pinAllList.filter({ landmark in
          //  landmark.title.contains(searchText)
            landmark.title.lowercased().contains(searchText.lowercased())
        })
        
        resultsController.tableView.reloadData()
    }
}

class MyPointAnnotation: MKPointAnnotation {
    var id = 0
}
