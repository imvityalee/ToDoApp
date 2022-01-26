//
//  EmptyListView.swift
//  ToDoApp
//
//  Created by Victor Lee on 25/1/22.
//

import SwiftUI

struct EmptyListView: View {
    //MARK: - Properties
    @State private var isAnimated: Bool = false
    
    let images: [String] = [
        LocalizbleEmptyListView.illustration1,
        LocalizbleEmptyListView.illustration2,
        LocalizbleEmptyListView.illustration3
    ]
    
    let tips: [String] = [
        LocalizbleEmptyListView.tip1,
        LocalizbleEmptyListView.tip2,
        LocalizbleEmptyListView.tip3,
        LocalizbleEmptyListView.tip4,
        LocalizbleEmptyListView.tip5
    ]
    
    @ObservedObject var theme = ThemeSettings()
    var themes: [Theme] = themeData
    
    //MARK: - body
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 5) {
                Image(images.randomElement() ?? "\(images[0])")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256,
                           idealWidth: 280,
                           maxWidth: 360,
                           minHeight: 256,
                           idealHeight: 280,
                           maxHeight: 360,
                           alignment: .center)
                    .layoutPriority(1)
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
                Text(tips.randomElement() ?? "\(tips[0])")
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
            } // Vstack
            .padding(.horizontal)
            .opacity(isAnimated ? 1: 0)
            .offset(y: isAnimated ? 0: -50)
            .animation(.easeOut, value: 1.5)
            .onAppear { isAnimated.toggle() }
        } //: Zstack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color(LocalizbleEmptyListView.backgroundColor))
        .edgesIgnoringSafeArea(.all)
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView().environment(\.colorScheme, .dark)
    }
}

struct LocalizbleEmptyListView {
    static let illustration1: String = "illustration-no1"
    static let illustration2: String = "illustration-no2"
    static let illustration3: String = "illustration-no3"


    static let tip1: String = "Use your time wisely."
    static let tip2: String = "Work hard, play hard."
    static let tip3: String = "Keep it simple."
    static let tip4: String = "Slow things are better."
    static let tip5: String = "Rewarh yourself ."

    static let backgroundColor: String = "ColorBase"
}
