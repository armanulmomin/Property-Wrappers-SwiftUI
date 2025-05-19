//
//  ContentView.swift
//  PropertyWrappersBootcamp
//
//  Created by Arman on 19/5/25.
//

import SwiftUI

struct FruitModel: Identifiable{
    let id: String = UUID().uuidString

    let name: String
    let count: Int
}

class FruitViewModel: ObservableObject{
    @Published var fruitArray: [FruitModel] = []
    @Published var isLoading: Bool = false
    
    init()
    {
        getFruits()
    }
    func getFruits(){
        let fruit1 = FruitModel(name: "Banana", count: 10)
        let fruit2 = FruitModel(name: "Orange", count: 15)
        let fruit3 = FruitModel(name: "Pineapple", count: 20)
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fruitArray.append(fruit1)
            self.fruitArray.append(fruit2)
            self.fruitArray.append(fruit3)
            self.isLoading = false
        }
        
        
        
    }
    func deleteFruit(index: IndexSet){
        fruitArray.remove(atOffsets: index)
    }
}

struct ContentView: View {
   //@StateObject -> Use this on creation
   //@ObservedObject -> for subviews
    @StateObject var fruitViewModel: FruitViewModel = FruitViewModel()
    var body: some View {
        NavigationView{
            List{
                if fruitViewModel.isLoading{
                    ProgressView()
                }
                else
                {
                    ForEach(fruitViewModel.fruitArray)
                    {
                        fruit in
                        HStack{
                            Text("\(fruit.count)")
                            Text(fruit.name)
                        }
                    }
                    .onDelete { indexset in
                        fruitViewModel.deleteFruit(index: indexset)
                    }
                }
                
                
            }
            .navigationBarItems(trailing: NavigationLink(
                destination: RandomScreen(fruitViewModel: fruitViewModel), label: {
                    Image(systemName: "arrow.right").font(.title)
                }
            ))
            
            .listStyle(GroupedListStyle())
            .navigationTitle("Fruit List")
            
        }
        
    }

}
struct RandomScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var fruitViewModel: FruitViewModel
    var body: some View{
        ZStack{
            Color.green.ignoresSafeArea()
            VStack{
                ForEach(fruitViewModel.fruitArray)
                {
                    fruit in
                    Text(fruit.name)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
