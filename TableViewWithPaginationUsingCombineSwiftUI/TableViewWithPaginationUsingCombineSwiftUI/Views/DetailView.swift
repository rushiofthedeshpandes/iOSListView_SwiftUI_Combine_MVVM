//
//  DetailView.swift
//  TableViewWithPaginationUsingCombineSwiftUI
//
//  Created by Rushikesh Deshpande on 25/04/24.
//


import SwiftUI

struct DetailView: View {
    let item: Item
    let viewModel: ItemViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack{
                Text("\(item.id)")
                    .font(.largeTitle)
                Text(item.title)
                    .font(.headline)
            }
            
            Text(item.body)
                .font(.subheadline)
            
            if let result = item.heavyTaskResult, let timeTaken = item.heavyTaskTimeTaken {
                HStack{
                    Text("Heavy Task Result: \(result)")
                        .font(.footnote)
                    Text("Time Taken: \(String(format: "%.4f", timeTaken)) seconds")
                        .foregroundColor(.blue)
                        .font(.footnote)
                }
            } else {
                Text("Computing heavy task...")
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Detail")
        .onAppear {
            viewModel.updateHeavyTaskResultIfNeeded(for: item)
        }
    }
}
