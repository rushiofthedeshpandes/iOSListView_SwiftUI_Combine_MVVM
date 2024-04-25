//
//  ListView.swift
//  TableViewWithPaginationUsingCombineSwiftUI
//
//  Created by Rushikesh Deshpande on 25/04/24.
//

import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = ItemViewModel()
    @State private var selectedItem: Item?
    @State var loadingToggle = false
    var body: some View {
        
        NavigationView {
                List(viewModel.items) { item in
                ItemCell(item: item, viewModel: viewModel)
                    .onTapGesture {
                        selectedItem = item
                    }
                    .onAppear {
                        if item.id == viewModel.items.last?.id {
                            viewModel.fetchItems()
                        }
                        viewModel.updateHeavyTaskResultIfNeeded(for: item)
                    }
            }
            .navigationTitle("Posts")
            .onAppear {
                viewModel.fetchItems()
            }
            .overlay(
                viewModel.isLoading
                ? ActivityIndicatorView(isDisplayed: $loadingToggle, content: {
                    Text("")
                })                  : nil
            )
        }
        .sheet(item: $selectedItem) { item in
            DetailView(item: item, viewModel: viewModel)
        }
    }
}

#Preview {
    ListView()
}

