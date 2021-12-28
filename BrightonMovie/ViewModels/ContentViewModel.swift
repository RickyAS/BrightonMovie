//
//  ContentViewModel.swift
//  BrightonMovie
//
//  Created by Ricky Austin on 28/12/21.
//

import Foundation

class ContentViewModel: ObservableObject{
    @Published var model = [MovieModel]()
    @Published private var inModel = [MovieModel]()
    @Published var emptyPlaceholder = (show: false, message: "No Movies Found", image: "shippingbox")
    @Published var isFavourite = false{
        didSet{
            favouriteData()
        }
    }
    @Published var searchText = ""{
        didSet{
            if searchText != ""{
                retrieveData(searchText)
            }
            
        }
    }
    @Published var sortIndex = 0{
        didSet{
            filterData()
        }
    }
    
    
    init(){
        retrieveData("avenger")
    }
    
   private func retrieveData(_ title: String){
        UrlService.shared.buildPath(path: "s=\(title)").decode(OuterModel.self) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let outer):
                    if outer.Search.isEmpty{
                        self.emptyPlaceholder = (true, "No movies found", "shippingbox")
                        return
                    }
                    self.model = outer.Search
                    self.inModel = outer.Search
                    self.emptyPlaceholder = (false, "", "")
                case .failure:
                    self.emptyPlaceholder = (true, "Please check your Internet", "wifi.exclamationmark")
                }
            }
            
        }
    }
    
    private func filterData(){
        //Sort List
        switch sortIndex{
        case 1:
            model = model.sorted{($0.title ?? "").localizedCompare($1.title ?? "") == .orderedAscending}
        case 2:
            model = model.sorted{($0.year ?? "").localizedCompare($1.year ?? "") == .orderedAscending}
        default:
            model = inModel
        }
    }
    
    private func favouriteData(){
        if isFavourite{
            guard let data = UserDefaults.standard.data(forKey: "SavedMovies"),
                    let decoded = try? JSONDecoder().decode([MovieModel].self, from: data), !decoded.isEmpty else{
                self.emptyPlaceholder = (true, "No favorites yet", "bolt.heart")
                return}
            self.model = decoded
        }else{
            self.emptyPlaceholder = (false, "", "")
            self.model = self.inModel
        }
    }
}
