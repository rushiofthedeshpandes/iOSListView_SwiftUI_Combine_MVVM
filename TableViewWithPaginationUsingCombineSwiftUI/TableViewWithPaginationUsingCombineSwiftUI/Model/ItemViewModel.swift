//
//  ItemViewModel.swift
//  TableViewWithPaginationUsingCombineSwiftUI
//
//  Created by Rushikesh Deshpande on 25/04/24.

import Foundation
import Combine

class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading: Bool = false
    private var currentPage: Int = 1
    private let itemsPerPage: Int = 10
    private var cancellables: Set<AnyCancellable> = []
    private var memoizedResults: [Int: (result: Int, timeTaken: TimeInterval)] = [:]
    
    func fetchItems() {
        guard !isLoading else { return }
        
        isLoading = true
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(currentPage)&_limit=\(itemsPerPage)")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: [Item].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
            }, receiveValue: { [weak self] newItems in
                self?.items.append(contentsOf: newItems)
                self?.currentPage += 1
            })
            .store(in: &cancellables)
    }
    
    func computeHeavyTask(input: Int) -> (Int, TimeInterval) {
        let startTime = CFAbsoluteTimeGetCurrent()
        var result = 0
        for i in 1...input {
            result += i
        }
        let endTime = CFAbsoluteTimeGetCurrent()
        let timeTaken = endTime - startTime
        return (result, timeTaken)
    }
    
    func updateHeavyTaskResult(for item: Item, result: Int, timeTaken: TimeInterval) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].heavyTaskResult = result
            items[index].heavyTaskTimeTaken = timeTaken
        }
    }
    
    func updateHeavyTaskResultIfNeeded(for item: Item) {
        if item.heavyTaskResult == nil || item.heavyTaskTimeTaken == nil {
            let (result, timeTaken) = computeHeavyTask(input: 1000) // Example input
            updateHeavyTaskResult(for: item, result: result, timeTaken: timeTaken)
        }
    }
    
}
