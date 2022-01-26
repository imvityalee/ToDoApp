//
//  ContentView.swift
//  ToDoApp
//
//  Created by Victor Lee on 24/1/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var iconsettings: IconNames

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    //MARK: - State properties
    

    private var items: FetchedResults<Item>
    
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    @State private var showingSettingsView: Bool = false
    @StateObject var theme = ThemeSettings.init()
    var themes: [Theme] = themeData

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorize(priority: item.priority ?? "Normal"))
                            Text(item.name ?? "Unknown")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(item.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                )
                        }
                        .padding(.vertical, 10)
                    }
                    .onDelete(perform: deleteItems)
                }// List
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                            .tint(themes[self.theme.themeSettings].themeColor)
                    }
                    ToolbarItem {
                        Button {
                            self.showingSettingsView.toggle()
                        } label: {
                            Image(systemName: "paintbrush")
                        }
                        .tint(themes[self.theme.themeSettings].themeColor)
                        .sheet(isPresented: $showingSettingsView) {
                            SettingsView().environmentObject(self.iconsettings)
                            
                        }

                    }
             }// toolbar
                if items.isEmpty {
                    EmptyListView()
                }
            } // Zstack
            .sheet(isPresented: $showingAddTodoView) {
                AddTodoView().environment(\.managedObjectContext, self.viewContext)
            }
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(animatingButton ? 0.2: 0)
                            .scaleEffect(animatingButton ? 1: 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(animatingButton ? 0.15: 0)
                            .scaleEffect(animatingButton ? 1: 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    .animation(Animation.easeInOut(duration: 0.02).repeatForever(autoreverses: true), value: 2)
                    Button(action: {
                        addItem()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color(LocalizbleEmptyListView.backgroundColor)))
                            .frame(width: 48, height: 48, alignment: .center)
                    })
                        .tint(themes[self.theme.themeSettings].themeColor)
                        .onAppear {
                        animatingButton.toggle()
                    }
                }//Zstack
                
                    .padding()
                ,alignment: .bottomTrailing
                
            )
            .environmentObject(theme)
        }// Nav View
        
    }

    private func addItem() {
        withAnimation {
            showingAddTodoView.toggle()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    private func colorize(priority: String) -> Color  {
        switch priority {
        case "High":
            return .pink
        case "Normal":
            return .green
        case "Low":
            return .blue
        default:
            return .gray
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
