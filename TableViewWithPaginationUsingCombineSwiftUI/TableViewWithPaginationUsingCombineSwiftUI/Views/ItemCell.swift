//
//  ItemCell.swift
//  TableViewWithPaginationUsingCombineSwiftUI
//
//  Created by Rushikesh Deshpande on 25/04/24.
//

import SwiftUI

struct ItemCell: View {
    let item: Item
    let viewModel: ItemViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("\(item.id)")
                    .font(.largeTitle)
                Text(item.title)
                    .font(.headline)
            }
           
            Spacer(minLength: 2)
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
                    .onAppear {
                        let (result, timeTaken) = viewModel.computeHeavyTask(input: 1000) // Example input
                        viewModel.updateHeavyTaskResult(for: item, result: result, timeTaken: timeTaken)
                    }
            }
        }
        .padding(.vertical, 8)
    }
}
