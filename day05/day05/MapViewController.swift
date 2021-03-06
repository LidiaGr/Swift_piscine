//
//  ViewController.swift
//  day05
//
//  Created by Lidia Grigoreva on 26.06.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    
    let segmentedControll = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
    let locationButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupMapView()
        setupSegmentedControll()
        
        addLocationButton()
        fetchPlacesOnMap()
    }
    
    func setupMapView() {
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func setupSegmentedControll() {
        segmentedControll.selectedSegmentIndex = 0
        segmentedControll.selectedSegmentTintColor = .systemBlue
        segmentedControll.backgroundColor = .white
        segmentedControll.layer.borderWidth = 1
        segmentedControll.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControll.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControll.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
        
        segmentedControll.addTarget(self, action: #selector(changeMapViewType(_:)), for: .valueChanged)
        
        mapView.addSubview(segmentedControll)
        segmentedControll.translatesAutoresizingMaskIntoConstraints = false
        segmentedControll.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -10).isActive = true
        segmentedControll.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func changeMapViewType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
            break
        case 1:
            mapView.mapType = .hybrid
            break
        case 2:
            mapView.mapType = .satellite
            break
        default:
            break
        }
    }
    
    func addLocationButton() {
        let image = UIImage(systemName: "location.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: segmentedControll.frame.height))
        locationButton.setImage(image, for: .normal)
        locationButton.tintColor = .systemBlue
        locationButton.addTarget(self, action: #selector(getMyLocation(_:)), for: .touchUpInside)
        
        mapView.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.centerYAnchor.constraint(equalTo: segmentedControll.centerYAnchor).isActive = true
        locationButton.leadingAnchor.constraint(equalTo: segmentedControll.trailingAnchor, constant: 5).isActive = true
    }
    
    @objc func getMyLocation(_ sender: UIButton) {
        checkLocationService()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            showAlert(msg: "Turn on your Location Services to allow \"day05\" to determine your location")
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            goToUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showAlert(msg: "\"day05\" can only access your location when you choose to share it")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
            break
        case .restricted:
            showAlert(msg: "\"day05\" can only access your location when you choose to share it")
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func goToUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
        }
    }
        
    func showAlert(msg: String){
        let alertController = UIAlertController (title: msg, message: "Go to Settings?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func fetchPlacesOnMap() {
        var annotations = [MKPointAnnotation()]
        for place in PlacesAPI.getPlaces() {
            let annotation = MKPointAnnotation()
            annotation.title = place.title
            annotation.subtitle = place.info
            annotation.coordinate = place.coordinate
            mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
        mapView.showAnnotations(annotations, animated: true)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Place")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
               return nil
           }

        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Place") as? MKMarkerAnnotationView
        annotationView?.canShowCallout = true
        annotationView?.rightCalloutAccessoryView = UITextView()
        
        var color: UIColor = .red
        for place in PlacesAPI.getPlaces() {
            if place.title == annotation.title {
                color = place.color
            }
        }
        annotationView?.markerTintColor = color
        annotationView?.glyphImage = UIImage(systemName: "heart")
        
        return annotationView
        
    }
    
    func goToPlace(place: Place) {
        let center = place.coordinate
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
}

