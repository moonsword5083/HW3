//
//  SecondPage.swift
//  HW3
//
//  Created by User20 on 2020/5/3.
//  Copyright © 2020 00657143. All rights reserved.
//

import SwiftUI

struct SecondPage: View {
    @Binding var showSecondPage: Bool
    @Binding var name: Int
    var roles = ["W", "温蒂", "傀影", "莫斯提馬", "塞雷婭", "煌"]
    @Binding var gender: String
    @Binding var heigh: Int
    @Binding var organization: String
    @Binding var experience: CGFloat
    @Binding var startDate: Date
    @Binding var notation: Bool
    @Binding var notationContent: String
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    @State private var showAlert = false
    @State private var showSort = false
    @State private var showPic = false
    @State private var sort = 1
    var sortClass = ["丟到冷宮", "普通資料", "我的最愛"]
    
    var buttonHue:[Double] = [1.0, 0.158, 1.158, 0.686, 0.034, 0.758]
    var buttonSaturation:[Double] = [0.889, 0.949, 0.161, 0.913, 0.893, 0.765]
    var buttonBright:[Double] = [0.842, 0.722, 0.298, 0.850, 0.946, 0.274]
    
    var body: some View {
        VStack{
            Text("幹員資料")
            HStack {
                Image(roles[name])
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipped()
                    .border(Color.gray, width: 4)
                VStack(alignment: .leading){
                    Text("資料分類: \(sortClass[sort])")
                    Button(action: {self.showSort = true}){
                        Text("選擇分類")
                    }
                    .actionSheet(isPresented: self.$showSort){
                        ActionSheet(title: Text("選擇分類"), message:Text("對幹員喜惡程度"), buttons: [
                            .default(Text("丟到冷宮"), action:{
                                self.sort = 0
                                self.showPic = true
                                
                            })
                            ,.default(Text("普通資料"), action:{
                                self.sort = 1
                                self.showPic = true
                            })
                            ,.default(Text("我的最愛"), action:{
                                self.sort = 2
                                self.showPic = true
                            })
                        ])
                    }
                    Text("名字: \(roles[name])")
                }
            }
            HStack {
                VStack(alignment: .leading){
                    Text("性別: \(gender)")
                    Text("身高: \(heigh) cm")
                    Text("所屬組織: \(organization)")
                    Text("戰鬥經驗: \(Int(experience)) 年")
                    Text("入職日期: \(dateFormatter.string(from: startDate))")
                    if notation{
                        Text("註記:\(notationContent)")
                    }
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 12 / 17)
            
            PicView(showPic: $showPic, sort: $sort)
            
            HStack{
                Button(action: {self.showAlert = true}){
                    HStack{
                        Text("添加資料")
                            .fontWeight(.heavy)
                        Image(systemName: "folder.badge.plus")
                    }
                    .padding()
                    .foregroundColor(Color(hue: self.buttonHue[name], saturation: self.buttonSaturation[name], brightness: self.buttonBright[name]))
                    .frame(width: 140, height: 50)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(hue: self.buttonHue[name], saturation: self.buttonSaturation[name], brightness: self.buttonBright[name]), lineWidth: 4))
                }
                .alert(isPresented: self.$showAlert){ () -> Alert in
                    return Alert(title: Text("已添加到\(sortClass[sort])"))
                }
                Spacer()
                Button(action: {self.showSecondPage = false}){
                    HStack {
                        Text("重新填寫")
                            .fontWeight(.heavy)
                        Image(systemName: "trash")
                    }
                        
                    .padding()
                    .foregroundColor(Color(hue: self.buttonHue[name], saturation: self.buttonSaturation[name], brightness: self.buttonBright[name]))
                    .frame(width: 130, height: 50)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(hue: self.buttonHue[name], saturation: self.buttonSaturation[name], brightness: self.buttonBright[name]), lineWidth: 4))
                }
            }
            .offset(y:80)
            .frame(width: UIScreen.main.bounds.width * 8 / 11)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Image("背景2").resizable().frame(width: UIScreen.main.bounds.width).opacity(0.7))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SecondPage_Previews: PreviewProvider {
    static var previews: some View {
        SecondPage(showSecondPage: .constant(true), name: .constant(0), gender: .constant("女"), heigh: .constant(165), organization: .constant("整合運動"), experience: .constant(11), startDate: .constant(Date()), notation: .constant(true), notationContent: .constant("哈哈"))
    }
}

struct PicView: View {
    @Binding var showPic: Bool
    @Binding var sort: Int
    var sortClass = ["丟到冷宮", "普通資料", "我的最愛"]
    
    var body: some View {
        ZStack{
            if showPic {
                if sort == 0{
                    Image(sortClass[0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width - 70, height: 220)
                        .clipped()
                        .contextMenu{
                            Button(action:{
                                self.sort = 1
                            }){
                                Text("普通資料")
                                Image(systemName: "folder")
                            }
                            Button(action:{
                                self.sort = 2
                            }){
                                Text("我的最愛")
                                Image(systemName: "heart")
                            }
                    }
                    .transition(.opacity)
                }else if sort == 1{
                    Image(sortClass[1])
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width - 70, height: 220)
                        .clipped()
                        .contextMenu{
                            Button(action:{
                                self.sort = 0
                                self.showPic = true
                            }){
                                Text("丟到冷宮")
                                Image(systemName: "hand.thumbsdown")
                            }
                            Button(action:{
                                self.sort = 2
                                self.showPic = true
                            }){
                                Text("我的最愛")
                                Image(systemName: "heart")
                            }
                    }
                    .transition(.opacity)
                }else if sort == 2{
                    Image(sortClass[2])
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width - 70, height: 220)
                        .clipped()
                        .contextMenu{
                            Button(action:{
                                self.sort = 0
                                self.showPic = true
                            }){
                                Text("丟到冷宮")
                                Image(systemName: "hand.thumbsdown")
                            }
                            Button(action:{
                                self.sort = 1
                                self.showPic = true
                            }){
                                Text("普通資料")
                                Image(systemName: "folder")
                            }
                    }
                    .transition(.opacity)
                }
            }else{
                Image(sortClass[1])
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 70, height: 220)
                    .clipped()
                    .contextMenu{
                        Button(action:{
                            self.sort = 0
                            self.showPic = true
                        }){
                            Text("丟到冷宮")
                            Image(systemName: "hand.thumbsdown")
                        }
                        Button(action:{
                            self.sort = 2
                            self.showPic = true
                        }){
                            Text("我的最愛")
                            Image(systemName: "heart")
                        }
                }
            }
        }
        .animation(.easeInOut(duration: 3))
        .offset(y:50)
    }
}

