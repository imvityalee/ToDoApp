//
//  SettingsView.swift
//  ToDoApp
//
//  Created by Victor Lee on 25/1/22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismissAction
    @EnvironmentObject var iconSettings: IconNames
    
    @EnvironmentObject var theme: ThemeSettings
    let themes: [Theme] = themeData

    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                
                Form {
                    //MARK: - SEction 1
                    Section {
                        Picker(selection: $iconSettings.currentIndex) {
                            ForEach(0..<iconSettings.iconNames.count) { index in
                                HStack {
                                    Image(uiImage: UIImage(named: self.iconSettings.iconNames[index] ?? "Blue") ?? UIImage())
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44, alignment: .center)
                                        .cornerRadius(8)
                                    Spacer().frame(width: 8)
                                    Text(iconSettings.iconNames[index] ?? "Blue")
                                        .frame(alignment: .leading)
                                }
                                .padding(3)
                            }
                            .onReceive([self.iconSettings.currentIndex].publisher.first()) { (value) in
                                let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                                if index != value  {
                                    UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value]) { error in
                                        if let error = error {
                                            print(error.localizedDescription)
                                        } else {
                                            print("Success! You have changed the icon")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                                        .strokeBorder(Color.primary, lineWidth: 2)
                                    Image(systemName: "paintbrush")
                                        .font(.system(size: 28, weight: .regular, design: .default))
                                    .foregroundColor(Color.primary)
                                }
                                .frame(width: 44, height: 44)
                                Text("App Icons".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.primary)
                            }// Label
                        }

                    } header: {
                        Text("Choose the app icon")
                    }
                    //MARK: - Section 2
                    
                    Section {
                        List {
                            ForEach(themes, id: \.id ) { item in
                                Button {
                                    theme.themeSettings = item.id
                                    UserDefaults.standard.set(theme.themeSettings, forKey: "Theme")
                                } label: {
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.themeColor)
                                        Text(item.themeName)
                                    }
                                }
                                .tint(Color.primary)
                            }
                        }
                    } header: {
                        HStack {
                            Text("Choose the app theme")
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(themes[self.theme.themeSettings].themeColor)
                        }
                    }

                    //MARK: - Section 3
                    Section {
                        FormRowLinkView(icon: "globe", color: Color.pink, text: "Website", link: "https://imvityalee.github.io")
                        FormRowLinkView(icon: "link", color: Color.blue, text: "Twitter", link: "https://twitter.com")
                        FormRowLinkView(icon: "play.rectangle", color: Color.green, text: "Courses", link: "https://youtube.com")
                    } header: {
                        Text("Follow us on Social media")
                    }
                    .padding(.vertical, 3)
                    //MARK: - Section 4
                    Section {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Victor / Andrew")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Robert Petras")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.1")
                    } header: {
                        Text("About the application")
                    }
                }// Form
                //MARK: Footer
                
                Text("Copyright © All rights reserved.\nVictor Lee")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(Color.secondary)
            }// Vstack
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismissAction.callAsFunction()
                    } label: {
                        Image(systemName: "xmark")
                    }

                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("ColorBackground"))
        }// NAVigationView
        .tint(themes[self.theme.themeSettings].themeColor)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(IconNames())
    }
}
