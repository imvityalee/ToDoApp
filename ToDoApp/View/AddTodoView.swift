//
//  AddTodoView.swift
//  ToDoApp
//
//  Created by Victor Lee on 24/1/22.
//

import SwiftUI

struct AddTodoView: View {
    //MARK: - PROPERTIES
    @State private var name: String = ""
    @State private var priority: String = "Normal"
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismissPresentation
    
    @StateObject var theme = ThemeSettings()
    
    var themes: [Theme] = themeData
    
    let priorities: [String] = ["High", "Normal", "Low"]
    //MARK: - BODY
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    //MARK: - TODO Name
                    TextField("Todo", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    
                    //MARK: - TODO PRIORITY
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                             Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    //MARK: - SAVE Button
                    Button {
                        guard !name.isEmpty else {
                            errorShowing = true
                            errorTitle = "Inavlid Name"
                            errorMessage = "Make sure to enter something for\nthe new todo item."
                            return
                        }
                        
                        let item = Item(context: self.viewContext)
                        item.name = self.name
                        item.priority = self.priority
                        
                        do {
                            try self.viewContext.save()
                        } catch {
                            print(error)
                        }
                        dismissPresentation.callAsFunction()
                    } label: {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(themes[self.theme.themeSettings].themeColor)
                            .cornerRadius(9)
                            .foregroundColor(Color.white)
                    }

                } // Vstack
                .padding(.horizontal)
                .padding(.vertical, 30)
                
                Spacer()
                
            } // VSTACK
            .navigationTitle("New ToDo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismissPresentation.callAsFunction()
                    } label: {
                        Image(systemName: "xmark")
                    }

                }
            }
            .alert(errorTitle, isPresented: $errorShowing) {
                //Actions
            } message: {
                Text(errorMessage)
            }

          
        } //: NAVIGATION
        .environmentObject(theme)
        .tint(themes[self.theme.themeSettings].themeColor)
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
