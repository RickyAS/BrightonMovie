//
//  ContentDetailViewModel.swift
//  BrightonMovie
//
//  Created by Ricky Austin on 28/12/21.
//

import Foundation

class ContentDetailViewModel : ObservableObject{
    @Published var model: MovieModel?
    @Published var emptyPlaceholder = (show: false, message: "No Movies Found", image: "shippingbox")
    @Published var isFavourite = false
    
    init(movieID: String){
        retrieveData(movieID)
    }
    
    private func retrieveData(_ movieID: String){
         UrlService.shared.buildPath(path: "i=\(movieID)").decode(MovieModel.self) { result in
             DispatchQueue.main.async {
                 switch result{
                 case .success(let movie):
                     self.model = movie
                 case .failure:
                     self.emptyPlaceholder = (true, "Please check your Internet", "wifi.exclamationmark")
                 }
             }
             
         }
     }
    
    func saveMovie(){
        if isFavourite{
            guard let model = model else {return}
            var mod = [MovieModel]()
            if let data = UserDefaults.standard.data(forKey: "SavedMovies"),
                let decoded = try? JSONDecoder().decode([MovieModel].self, from: data){
                mod = decoded
            }
            mod.append(model)
            if let encoded = try? JSONEncoder().encode(mod){
                UserDefaults.standard.set(encoded, forKey: "SavedMovies")
            }
        }
        
    }
    
}
