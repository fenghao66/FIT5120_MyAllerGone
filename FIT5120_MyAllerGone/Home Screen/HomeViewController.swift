//
//  HomeViewController.swift
//  FIT5120_MyAllerGone
//
//  Created by Qfh on 20/3/21.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {

    @IBOutlet weak var CityLabel: UILabel!
    @IBOutlet weak var HomeCollectionView: UICollectionView!
    //var image:UIImage = UIImage()
    
    var temp: String?
    var locationManager: CLLocationManager = CLLocationManager()
    
    var weatherManager = WeatherManager()
    
//    var WeatherModel: WeatherModel! {
//        didSet {
//            self.HomeCollectionView.reloadData()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // locationManager delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        weatherManager.delegate = self

        // Do any additional setup after loading the view.
        guard let tabBar = tabBarController?.tabBar else {
            return
        }
        //tabBar.barTintColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = UIColor.gray.cgColor
        
        //view.backgroundColor = UIColor.white
        //navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.tabBarItem.selectedImage = UIImage(named: "cloudy_click")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLocation()        
    }
    
    func checkLocation(){
        if CLLocationManager.locationServicesEnabled() {
            let locationManager = CLLocationManager()
            locationManagerDidChangeAuthorization(locationManager)
            
        }else {
            print("CLLocationManager failed !!!")
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

            switch manager.authorizationStatus {
                case .authorizedAlways , .authorizedWhenInUse:
                    getUserCurrentLocation()
                    break
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .denied :
                    displayMessage(title: "Reopen Authentication", message: "Settings -> Privacy -> Location Services -> Open")
                    break
                case .restricted:
                    displayMessage(title: "Filed", message: "Map Service Restricted")
                    break
                default:
                    break
            }
            
            switch manager.accuracyAuthorization {
                case .fullAccuracy:
                    break
                case .reducedAccuracy:
                    break
                default:
                    break
            }
    }
    
    func  getUserCurrentLocation(){
//        if let currentLocation = locationManager.location?.coordinate {
//            //print cuttentLocation lat && lng
//            userCurrentLocationLat = currentLocation.latitude
//            userCueentLocationLng = currentLocation.longitude
//            print("current location lat \(currentLocation.latitude)")
//            print("current location lng \(currentLocation.longitude)")
//        }
        locationManager.startUpdatingLocation()
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Receive the data and send it to the UI

extension HomeViewController: WeatherManagerDelegate {
    
    func updateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        
        DispatchQueue.main.async {
            
            self.temp = "\(weather.temperatureString)"
            print(self.temp ?? "no temp")
            self.CityLabel.text = weather.cityName
            self.HomeCollectionView.reloadData()
//            self.temperatureLabel.text = weather.temperatureString
//            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
//
//            self.countryName.text = weather.countryName
//            self.descriptionLabel.text = weather.description.uppercased()
//            self.minTemp.text = "\(weather.minTempString)ºC"
//            self.maxTemp.text = "\(weather.maxTempString)ºC"
//            self.humidity.text = "\(weather.humidityString)%"
            
        }
    }
    
    func failError(error: Error) {
        
//        DispatchQueue.main.async {
//            self.alert(title: "Error, city not found 😰", message: "Check the name 🤔")
//        }
        
    }
}

// MARK: - Collection view data source

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell

            cell.layer.cornerRadius = 5.0
            cell.layer.shadowOpacity = 0.3
            cell.layer.shadowRadius = 5
            cell.layer.masksToBounds = false

            cell.tempLabel.text = self.temp
            //print(temp!)
            cell.weatherImage.image = #imageLiteral(resourceName: "cloudy_click")
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AQICollectionViewCell", for: indexPath) as! AQICollectionViewCell
        
        cell.layer.cornerRadius = 5.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 5
        cell.layer.masksToBounds = false

        cell.AQILabel.text = "17"
        cell.AQIImage.image = #imageLiteral(resourceName: "location_click")
        return cell
    }
}

extension HomeViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManagerDidChangeAuthorization(manager)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("current location lat \(lat)")
            print("current location lng \(lon)")
            weatherManager.fecthWeatherLocation( latitude: lat, longitude: lon)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("location error:", error)
        
    }
    
}
