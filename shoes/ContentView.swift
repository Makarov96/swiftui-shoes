//
//  ContentView.swift
//  shoes
//
//  Created by Guerin Steven Colocho Chacon on 21/11/23.
//

import SwiftUI
import Observation

struct ContentView: View {
    @Namespace var nameSpace
    @Namespace var cube
    @State var isSelected: Bool = false
    @State var reducer : Int = 19
    @State var totalValue: CGFloat = 0.0
    @State var animateSize: Bool = false
    let totalValues: Int = 36
    let startValue: Int = 1
    var increaseValue: CGFloat  = 0.5
    
    @State
    var shoe: Shoes =  Shoes(path: "shoes/img19", sizes: ["5.5","6.0", "6.5", "7.0", "7.5", "8.0", "8.5", "9.0", "9.5", "10.0", "10.5"], price: 256.00, shoesName: "Nike Air Max 90 \n Futura", scalePath: "shoes/img19", isFavorite: false)
    var body: some View {
        GeometryReader{gt in
            let  size = gt.size
            
            ZStack{
                if !isSelected{
                    VStack(alignment:.center) {
                        RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                            .fill(LinearGradient(colors: [Color("BlueLight"), Color("PinkLight")], startPoint: .top, endPoint: .bottom))
                            .frame(width: size.width * 0.7, height:  size.height * 0.6)
                            .matchedGeometryEffect(id: "cube", in: cube, isSource: !isSelected)
                           .overlay {
                                Image(shoe.path).resizable()
                                    .frame(width: 410, height: 310)
                                    .scaledToFit()
                                    .rotationEffect(.degrees(-30))
                                    .offset(x: -50, y : -70)
                                    .matchedGeometryEffect(id: shoe.id, in: nameSpace)
                                
                            }
                            .onTapGesture {
                                
                                withAnimation(.spring()) {
                                    isSelected = true
                                    
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                                    
                                    withAnimation(.bouncy) {
                                        animateSize = true
                                    }
                                })
                                
                            }
                        
                       
                     }
                    .frame(width: size.width, height: size.height)
                    .opacity(isSelected  ? 0 : 1 )
                    .zIndex(1)
                }
                
                if isSelected {
                    ZStack{
                        
                        RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                            .fill(LinearGradient(colors: [Color("BlueLight"), Color("PinkLight")], startPoint: .top, endPoint: .bottom))
                            .frame(width:animateSize ? size.width : size.width * 0.72 , height:  animateSize ? size.height + 100 : size.height * 0.62)
                            .ignoresSafeArea()
                            .matchedGeometryEffect(id:  "cube", in: cube)
                        
                        
                        VStack{
                            
                            CustomHeader(nikeOnTap: {
                                withAnimation(.spring()) {
                                    isSelected = false
                                    reducer = 19
                                    totalValue = 0.0
                                    shoe.scalePath = "shoes/img19"
                                    animateSize = false
                                    
                                }
                                
                            }).safeAreaPadding(.top)
                                .padding(.bottom, 50)
                            
                            VStack{
                                Text(shoe.shoesName).multilineTextAlignment(.center)
                                    .font(.system(size: 30))
                                    .fontWeight(.light)
                                
                                Text("\(String(format: "%.0f",shoe.price))$").multilineTextAlignment(.center)
                                    .font(.system(size: 20))
                                    .fontWeight(.light)
                                    .frame(height: 10)
                                
                            }
                            
                            Spacer()
                            Image(shoe.scalePath)
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 400, height: 295)
                                .offset(y: -350)
                                .gesture(DragGesture(minimumDistance: 0).onChanged({ value in
                                    
                                    
                                    let x = value.translation.width

                                    if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {
                                        return;
                                    }
                                    if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                                        return;
                                    }
                                    
                                    if x >= totalValue{
                                        
                                        totalValue = x + increaseValue
                                        
                                        
                                        if reducer <= startValue {
                                            reducer = startValue
                                        }else {
                                            reducer = reducer - 1
                                            shoe.scalePath = "shoes/img\(reducer)"
                                        }
                                        
                                        
                                    }else {
                                        if x < totalValue {
                                            totalValue = x - increaseValue
                                            
                                            if  reducer == totalValues{
                                                reducer = totalValues
                                            }else {
                                                reducer = reducer + 1
                                                shoe.scalePath = "shoes/img\(reducer)"
                                            }
                                        }
                                    }
                                    
                                    
                                }))
                                .transition(.opacity)
                                .matchedGeometryEffect(id:  shoe.id, in: nameSpace)
                            
                            
                        } .zIndex(2)
                        
                        Spacer()
                        HStack{
                            
                            Button(action: {
                                
                                withAnimation(.interpolatingSpring) {
                                    shoe.isFavorite.toggle()
                                }
                            }
                                   , label: {
                                Image(systemName: shoe.isFavorite ? "heart.fill" : "heart").foregroundColor(shoe.isFavorite ? .red : .black)
                                    .frame(width: 50, height: 50)
                                    .background(.white)
                                    .cornerRadius(30)
                                    .shadow(radius: 5, y: 5)
                            })
                            Spacer()
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Text("Add to basket").foregroundColor(.white)
                                    .frame(width: 200, height: 50)
                                    .background(.black.opacity(0.8))
                                    .cornerRadius(30)
                                    .shadow(radius: 8, y: 8)
                            })
                            
                            
                        }.padding(.horizontal, 70)
                            .offset(y: 340)
 
                    }
                    
                    
                }
                
            }
            
            
            
        }
    }
}

#Preview {
    ContentView()
}

typealias NikeOnTap =  ()->Void

struct CustomHeader: View {
    var nikeOnTap:NikeOnTap
    
    init(nikeOnTap: @escaping NikeOnTap) {
        self.nikeOnTap = nikeOnTap
    }
    
    var body: some View {
        HStack{
            Image(systemName: "arrow.backward").resizable()
                .frame(width: 20,height: 20)
                .onTapGesture {
                    nikeOnTap()
                }
            Spacer()
            Text("Nike Shoes")
            Spacer()
            Image(systemName: "bag").resizable()
                .frame(width: 20,height: 20)
        }
        .padding(.horizontal, 30)
    }
}



@Observable
class Shoes: Identifiable {
    let id: String = UUID().uuidString
    let path:String
    var scalePath: String
    let sizes: Array<String>
    let price: Double
    let shoesName: String
    var isFavorite:Bool
    
    init(path: String, sizes: Array<String>, price: Double, shoesName: String, scalePath:String, isFavorite:Bool) {
        self.path = path
        self.sizes = sizes
        self.price = price
        self.shoesName = shoesName
        self.scalePath = scalePath
        self.isFavorite = isFavorite
    }
    
    
}
