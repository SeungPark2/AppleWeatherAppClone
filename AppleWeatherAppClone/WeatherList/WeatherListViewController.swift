//
//  WeatherListViewController.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/01/26.
//

import Combine

import UIKit

class WeatherListViewController: UIViewController {

    // MARK: -- Public Properties
    
    // MARK: -- Public Method
    
    // MARK: -- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.checkPermission()
        initSearchController()
        bindState(with: viewModel)
        bindAction(with: viewModel)
    }
    
    // MARK: -- Private Method
    
    private func initSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "도시 또는 공항 검색"
        searchController.searchBar.setValue("취소",
                                            forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .white
        self.navigationItem.searchController = searchController
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func bindState(with viewModel: WeatherListViewModel) {
        
        viewModel.isLoaded
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                
                [weak self] isLoaded in
                
                self?.loadingIndicatorView?.isHidden = !isLoaded
                isLoaded ? self?.loadingIndicatorView?.startAnimating() :
                           self?.loadingIndicatorView?.stopAnimating()
            })
            .store(in: &self.cancellable)
        
        viewModel.$weathers
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                
                [weak self] _ in
                
                self?.weatherTableView?.reloadData()
            })
            .store(in: &self.cancellable)
    }
    
    private func bindAction(with viewModel: WeatherListViewModel) {
        
        optionBarButton?.target = self
        optionBarButton?.action = #selector(didTapOption)
        
        
        
    }
    
    @objc
    private func didTapOption() {
        
        print("opiton")
    }
    
    // MARK: -- Private Properties
    
    private var cancellable = Set<AnyCancellable>()
    private lazy var viewModel = WeatherListViewModel()
    
    // MARK: -- IBOutlet
    
    @IBOutlet private weak var optionBarButton: UIBarButtonItem?
    
    @IBOutlet private weak var weatherTableView: UITableView?
    
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView?
}

extension WeatherListViewController: UITableViewDelegate,
                                     UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.weathers.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier,
                                                       for: indexPath) as? WeatherCell,
              let weather = self.viewModel.weathers[safe: indexPath.row] else {
            
            return UITableViewCell()
        }
        
        cell.updateUI(with: weather,
                      tempType: .celsius)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
     
        guard let weather = self.viewModel.weathers[safe: indexPath.row] else {
            
            return
        }
        
        if let weatherDetail = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.weatherDetail.rawValue) as? WeatherDetailVC {
            
            weatherDetail.weatherInfo = weather
            
            self.navigationController?.pushViewController(weatherDetail,
                                                          animated: true)
        }
    }
}
