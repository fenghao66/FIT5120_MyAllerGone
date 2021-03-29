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
    
    var temp: String = "--"
    var weatherImageName: String?
    var currentDate: String?
    var currentWeekday: String?
    var weatherDesc: String?
    var MinTemp: String?
    var MaxTemp: String?
    
    var forecastImage1: String?
    var forecastDate1: String?
    var forecastDesc1: String?
    var forecastMin1: String?
    var forecastMax1: String?
    
    var forecastImage2: String?
    var forecastDate2: String?
    var forecastDesc2: String?
    var forecastMin2: String?
    var forecastMax2: String?
    
    var forecastImage3: String?
    var forecastDate3: String?
    var forecastDesc3: String?
    var forecastMin3: String?
    var forecastMax3: String?
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    var forecastManager = ForecastManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let cellScale: CGFloat = 0.90
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * 0.92)
        let layout = HomeCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        //let cellSize = layout.collectionViewContentSize
        layout.itemSize = CGSize(width: cellWidth, height: 150)
        
        // locationManager delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        weatherManager.delegate = self
        forecastManager.delegate = self

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
    //MARK: - Get current date and week
    
    func getCurrentDateString() -> String {
            let now = Date()
            let dformatter = DateFormatter()
            dformatter.dateFormat = "MM/dd"
            return dformatter.string(from: now)
        }
    func getCurrentDate() -> Date {
          let now = Date()
          let dateformatter = DateFormatter()
          dateformatter.dateFormat = "yyyy-MM-dd"
          let dateStr = dateformatter.string(from: now)
          return dateformatter.date(from: dateStr)!
      }
    func getWeedayFromeDate(date: Date, forecastIndex: Int) -> String {
           let calendar = Calendar.current
           let dateComponets = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.weekday,Calendar.Component.day], from: date)
           // get what day is today
           let weekDay = dateComponets.weekday! + forecastIndex
           switch weekDay {
           case 1:
               return "Sun"
           case 2:
              return  "Mon"
           case 3:
               return "Tue"
           case 4:
               return "Wed"
           case 5:
               return "Thu"
           case 6:
               return "Fri"
           case 7:
               return "Sat"
           default:
               return ""
           }
       }
    
    func updateWeekAndDate() {
        let date = self.getCurrentDate()
        self.currentDate = self.getCurrentDateString()
        self.currentWeekday = self.getWeedayFromeDate(date: date, forecastIndex: 0)
    }
    
    func updateForecastWeek() {
        let date = self.getCurrentDate()
        self.forecastDate1 = self.getWeedayFromeDate(date: date, forecastIndex: 1)
        self.forecastDate2 = self.getWeedayFromeDate(date: date, forecastIndex: 2)
        self.forecastDate3 = self.getWeedayFromeDate(date: date, forecastIndex: 3)
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
            //print(self.temp ?? "no temp")
            self.CityLabel.text = weather.cityName
            self.weatherImageName = weather.conditionName
            self.weatherDesc = weather.description
            self.MinTemp = weather.minTempString
            self.MaxTemp = weather.maxTempString
            self.updateWeekAndDate()
            
//            let date = self.getCurrentDate()
//            self.currentDate = self.getCurrentDateString()
//            self.currentWeekday = self.getWeedayFromeDate(date: date)
            
            self.HomeCollectionView.reloadData()
            
//            self.temperatureLabel.text = weather.temperatureString
//
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

//MARK: - Receive the forecast data and send it to the UI

extension HomeViewController: ForecastManagerDelegate {
    
    func updateForecast(_ weatherManager: ForecastManager, weather: ForecastModel){
        
        DispatchQueue.main.async {
            
            self.forecastImage1 = weather.conditionName
            self.forecastDesc1 = weather.description
            self.forecastMin1 = weather.minTempString
            self.forecastMax1 = weather.maxTempString
            
            self.forecastImage2 = weather.conditionName2
            self.forecastDesc2 = weather.description2
            self.forecastMin2 = weather.minTempString2
            self.forecastMax2 = weather.maxTempString2
            
            self.forecastImage3 = weather.conditionName3
            self.forecastDesc3 = weather.description3
            self.forecastMin3 = weather.minTempString3
            self.forecastMax3 = weather.maxTempString3
            
            self.updateForecastWeek()
            
            self.HomeCollectionView.reloadData()
        }
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
            cell.dateLabel.text = self.currentDate
            cell.weedayLabel.text = self.currentWeekday
            cell.weatherDescLabel.text = self.weatherDesc?.capitalized
            cell.MinMaxTempLabel.text = String("\(self.MinTemp ?? "?")-\(self.MaxTemp ?? "?")°C")
            //print(temp!)
            //#imageLiteral(resourceName: "weatherImageName")
            cell.weatherImage.image =  UIImage(named: "\(weatherImageName ?? "noImage")")
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AQICollectionViewCell", for: indexPath) as! AQICollectionViewCell
        
        cell.layer.cornerRadius = 5.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 5
        cell.layer.masksToBounds = false

        cell.firstDayLabel.text = self.forecastDate1
        cell.firstImage.image = UIImage(named: "\(forecastImage1 ?? "noImage")")
        cell.firstTempLabel.text = String("\(self.forecastMin1 ?? "?")°-\(self.forecastMax1 ?? "?")°")
        cell.firstDescLabel.text = self.forecastDesc1?.capitalized
        
        cell.SecondDayLabel.text = self.forecastDate2
        cell.secondImage.image = UIImage(named: "\(forecastImage2 ?? "noImage")")
        cell.secondTempLabel.text = String("\(self.forecastMin2 ?? "?")°-\(self.forecastMax2 ?? "?")°")
        cell.decondDescLabel.text = self.forecastDesc2?.capitalized
        
        cell.thirdDayLabel.text = self.forecastDate3
        cell.thirdImage.image = UIImage(named: "\(forecastImage3 ?? "noImage")")
        cell.thirdTempLabel.text = String("\(self.forecastMin3 ?? "?")°-\(self.forecastMax3 ?? "?")°")
        cell.thirdDescLabel.text = self.forecastDesc3?.capitalized
        
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
            forecastManager.fecthForecastLocation(latitude: lat, longitude: lon)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("location error:", error)
        
    }
    
}
