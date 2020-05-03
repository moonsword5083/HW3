//
//  ContentView.swift
//  HW3
//
//  Created by User20 on 2020/5/3.
//  Copyright © 2020 00657143. All rights reserved.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    let player = AVPlayer()
    @State var looper: AVPlayerLooper?
    
    @State private var selectDate = Date()
    let today = Date()
    let startDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())!
    var year: Int{
        Calendar.current.component(.year, from: selectDate)
    }
    
    @State private var selectRole = 0
    var roles = ["W", "温蒂", "傀影", "莫斯提馬", "塞雷婭", "煌"]
    
    @State private var selectGender = "男"
    var gender = ["男", "女"]
    
    @State private var selectOrganization = "羅德島"
    var organization = ["羅德島", "整合運動", "龍門", "雷姆必拓", "黑鋼國際", "喀蘭貿易", "莱塔尼亞", "莱茵生命", "深海獵人", "烏薩斯學生自治團", "格拉斯哥幫", "拉特蘭", "使徒", "汐斯塔", "企鵝物流", "卡西米爾"]
    
    @State private var roleHeight:Int = 165
    @State private var experience:CGFloat = 0
    @State private var notation = false
    @State private var notationContent:String = ""
    @State private var showSecondPage = false
    var buttonHue:[Double] = [1.0, 0.158, 1.158, 0.686, 0.034, 0.758]
    var buttonSaturation:[Double] = [0.889, 0.949, 0.161, 0.913, 0.893, 0.765]
    var buttonBright:[Double] = [0.842, 0.722, 0.298, 0.850, 0.946, 0.274]
    
    var body: some View {
        NavigationView{
            VStack{
                Image(self.roles[self.selectRole])
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 4 * 3)
                    .clipped()
                    .onAppear(){
                        let fileUrl = Bundle.main.url(forResource: "videoplayback", withExtension: "mp4")!
                        let playerItem = AVPlayerItem(url: fileUrl)
                        self.player.replaceCurrentItem(with: playerItem)
                        self.player.play()
                }
                Form{
                    Picker(selection: self.$selectRole, label: Text("幹員")){
                        ForEach(0..<self.roles.count){(index) in
                            Text(self.roles[index])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 380, height: 50)
                    .clipped()
                    
                    Picker(selection: self.$selectGender, label: Text("性別")){
                        ForEach(self.gender, id: \.self){(index) in
                            Text(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Stepper(value: self.$roleHeight, in: 120...200){
                        Text("身高: \(self.roleHeight)cm")
                    }
                    
                    HStack{
                        Text("戰鬥經驗: \(Int(self.experience))年")
                            .padding(.trailing)
                        Slider(value: self.$experience, in: 0...60, step: 1)
                    }
                    
                    VStack{
                        Picker(selection: self.$selectOrganization, label: Text("組織")){
                            ForEach(self.organization, id: \.self){(index) in
                                Text(index)
                            }
                        }
                        Image(self.selectOrganization)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130, height: 130)
                            .clipped()
                    }
                    
                    DatePicker("入職日期", selection: self.$selectDate, in: self.startDate...self.today, displayedComponents: .date)
                    
                    Toggle("註記", isOn: self.$notation)
                    if self.notation{
                        TextField("其他資料", text: self.$notationContent)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 2))
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: 460)
                Spacer()
                ButtonView(showSecondPage: $showSecondPage, selectRole: $selectRole, selectGender: $selectGender, roleHeight: $roleHeight, selectOrganization: $selectOrganization, experience: $experience, notation: $notation, notationContent: $notationContent, selectDate: $selectDate)
            }
            .offset(y:90)
            .background(Image("背景3").resizable().frame(width: UIScreen.main.bounds.width).opacity(0.7))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ButtonView: View {
    @Binding var showSecondPage: Bool
    @Binding var selectRole: Int
    @Binding var selectGender: String
    @Binding var roleHeight: Int
    @Binding var selectOrganization: String
    @Binding var experience: CGFloat
    @Binding var notation: Bool
    @Binding var notationContent: String
    @Binding var selectDate: Date
    
    var buttonHue:[Double] = [1.0, 0.158, 1.158, 0.686, 0.034, 0.758]
    var buttonSaturation:[Double] = [0.889, 0.949, 0.161, 0.913, 0.893, 0.765]
    var buttonBright:[Double] = [0.842, 0.722, 0.298, 0.850, 0.946, 0.274]
    
    var body: some View {
        Button(action: {self.showSecondPage = true}){
            Text("填寫完成")
                .fontWeight(.heavy)
                .padding()
                .foregroundColor(Color(hue: self.buttonHue[selectRole], saturation: self.buttonSaturation[selectRole], brightness: self.buttonBright[selectRole]))
                .frame(width: 120, height: 50)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(hue: self.buttonHue[selectRole], saturation: self.buttonSaturation[selectRole], brightness: self.buttonBright[selectRole]), lineWidth: 4))
        }
        .offset(y:-165)
        .sheet(isPresented: self.$showSecondPage){
            SecondPage(showSecondPage: self.$showSecondPage, name: self.$selectRole, gender: self.$selectGender, heigh: self.$roleHeight, organization: self.$selectOrganization, experience: self.$experience, startDate: self.$selectDate, notation: self.$notation, notationContent: self.$notationContent)
        }
    }
}

