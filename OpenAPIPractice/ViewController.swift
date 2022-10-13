//
//  ViewController.swift
//  OpenAPIPractice
//
//  Created by Yejin on 2022/10/13.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityPicker: UIPickerView!
    
    @IBOutlet weak var cityNameLb: UILabel!
    @IBOutlet weak var tempLb: UILabel!
    @IBOutlet weak var descriptionLb: UILabel!
    
    let maxCityCnt = 5
    let pickerViewCnt = 1
    var cityNames = ["Seoul", "Busan", "Jeonju", "Daegu", "Incheon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    func configureView(weatherData: WeatherData) {
        self.cityNameLb.text = weatherData.name
        if let weather = weatherData.weather.first {
            self.descriptionLb.text = weather.description
        }
        self.tempLb.text = "\(Int(weatherData.temp.temp - 273.15))℃"
        
    }
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=26d76be5afd84f2dcc741d18a5d9a4a8") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            guard let weatherData = try? decoder.decode(WeatherData.self, from: data) else { return }
            DispatchQueue.main.async {
                self?.configureView(weatherData: weatherData)
            }
            //네트워크 작업은 별도의 스레드에서 진행되고 응답이 와도 메인스레드로 자동으로 돌아오지 않아서 컴플리션핸들러에서 ui 작업을 한다면 메인스레드에서 작업할 수 있도록 만들어줘야함
        }.resume()
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerViewCnt
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cityName = cityNames[row]
        self.getCurrentWeather(cityName: cityName)
        self.view.endEditing(true)
    }
    
}

