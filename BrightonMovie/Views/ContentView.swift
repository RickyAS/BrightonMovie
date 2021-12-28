//
//  ContentView.swift
//  BrightonMovie
//
//  Created by Ricky Austin on 28/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ContentViewModel()
    @State private var isSort = false
    
    
    var body: some View {
        NavigationView{
            VStack{
                HStack(spacing: 8){
                    SearchBar("Find movie here...", text: $viewModel.searchText)
                    sortButton
                    favButton
                }.padding([.top, .horizontal])
                
                if viewModel.emptyPlaceholder.show{
                    Image(systemName: viewModel.emptyPlaceholder.image).foregroundColor(.gray).font(.system(size: 40, weight: .medium)).padding(.top, 20).padding(.bottom)
                    Text(viewModel.emptyPlaceholder.message).foregroundColor(.gray)
                    Spacer()
                }else{
                    List(viewModel.model.indices, id: \.self){ i in
                        ContentViewCell(model: viewModel.model[i])
                        
                    }.listStyle(PlainListStyle())
                }
                
            }.navigationTitle("Nice Movies").navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    var sortButton: some View{
        Button(action: {isSort.toggle()}){
            Image(systemName: "list.triangle").foregroundColor(.black).font(.system(size: 24, weight: .medium))
                .actionSheet(isPresented: $isSort) {
                ActionSheet(
                    title: Text("Sort by.."),
                    buttons: [
                        .default(Text("default")) {
                            viewModel.sortIndex = 0
                        },

                        .default(Text("title")) {
                            viewModel.sortIndex = 1
                        },

                        .default(Text("year")) {
                            viewModel.sortIndex = 2
                        },
                        .cancel(Text("Batal"))
                    ]
                )
            }
        }
    }
    
    var favButton: some View{
        Button(action: {viewModel.isFavourite.toggle()}){
            Image(systemName: viewModel.isFavourite ? "heart.fill": "heart").foregroundColor(.black).font(.system(size: 24, weight: .medium))
        }
    }
}

struct ContentViewCell: View{
    let model: MovieModel
    
    var body: some View{
        NavigationLink(destination: ContentViewDetail(viewModel: ContentDetailViewModel(movieID: model.imdbID ?? ""))) {
            HStack(alignment: .top){
                WebImage(url: URL(string: model.poster ?? "")).resizable().scaledToFill().frame(width: 80, height: 100).padding(.trailing)
                
                VStack(alignment: .leading, spacing: 8){
                    Text(model.title ?? "").font(.system(size: 16))
                    Text(model.year ?? "year").foregroundColor(.gray).font(.system(size: 14))
                }
               
            }.padding(.vertical)
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
