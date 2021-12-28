//
//  ContentViewDetail.swift
//  BrightonMovie
//
//  Created by Ricky Austin on 28/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentViewDetail: View {
    @ObservedObject var viewModel: ContentDetailViewModel
    
    var body: some View {
        ScrollView{
            header
            desc.padding()
        }.navigationTitle("Detail").navigationBarTitleDisplayMode(.inline).onDisappear{
            viewModel.saveMovie()
        }
    }
    
    var header: some View{
        ZStack(alignment: .bottom){
            
            WebImage(url: URL(string: viewModel.model?.poster ?? "")).resizable().placeholder{
                Rectangle().foregroundColor(.red)
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*0.5).scaledToFill()
            
            
            VStack(alignment: .trailing, spacing: 4){
                HStack{
                    Text(viewModel.model?.title ?? "").foregroundColor(.white).font(.system(size: 18, weight: .medium))
                    Spacer()
                }.offset(x: 0, y: 20)
                
                Circle().foregroundColor(.red).frame(width: 50, height: 50).overlay(Button(action:{viewModel.isFavourite.toggle()}){
                    Image(systemName: viewModel.isFavourite ? "heart.fill" : "heart").foregroundColor(.white)
                }).offset(x: 0, y: 20)
                
                
            }.padding(.horizontal).background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
        }
    }
    
    var desc: some View{
        VStack(alignment : .leading, spacing: 8){
            Group{
                Text("🗓 \(viewModel.model?.released ?? "")")
                Text("🕚 \(viewModel.model?.runtime ?? "")")
                Text("⭐️ \(viewModel.model?.ratings?.first?.value ?? "0")").padding(.bottom)
            }
            
            Text(viewModel.model?.plot ?? "").multilineTextAlignment(.leading).lineLimit(6).foregroundColor(.gray).font(.system(size: 14, weight: .light)).padding(.vertical)
            
            Group{
                HStack(alignment: .top){
                    VStack(alignment: .leading, spacing: 4){
                        Text("Genre")
                        Text("Director")
                        Text("Actors")
                    }.padding(.trailing)
                    
                    VStack(alignment: .leading, spacing: 4){
                        Text(viewModel.model?.genre ?? "")
                        Text(viewModel.model?.director ?? "")
                        Text(viewModel.model?.actors ?? "")
                    }
                }
            }.foregroundColor(.gray)
            
        
        }
    }
}

struct ContentViewDetail_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewDetail(viewModel: ContentDetailViewModel(movieID: "tt0458339"))
    }
}
