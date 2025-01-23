//
//  ProductView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Michael on 1/23/25.
//

import SwiftUI

@MainActor final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil

    
//    func getAllProducts() async throws {
//        self.products = try await ProductsManager.shared.getAllProducts()
//    }
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDecending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    func filterSelected(option: FilterOption) async throws {
        self.selectedFilter = option
        self.getProducts()

//        switch option {
//        case .priceHigh:
//            self.products = try await ProductsManager.shared.getAllproductsSortedByPrice(descending: true)
//        case .priceLow:
//            self.products = try await ProductsManager.shared.getAllproductsSortedByPrice(descending: false)
//        case .noFilter:
//            self.products = try await ProductsManager.shared.getAllProducts()
//        }
    }
    
    enum CategoryOption: String, CaseIterable {
        case beauty
        case fragrances
        case furniture
        case noCategory
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
    }
    
    
    
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        self.getProducts()

//        switch option {
//        case .beauty, .furniture ,.fragrances :
//            self.products = try await ProductsManager.shared.getAllproductsSortedForCategory(category: option.rawValue)
//        case .noCategory:
//            self.products = try await ProductsManager.shared.getAllProducts()
//        }
    }
    
    func getProducts() {
        Task {
            self.products = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDecending, forCategory: selectedCategory?.categoryKey)
        }

    }
}

struct ProductView: View {
    
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
            }
        }
        .navigationTitle("Products")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    ForEach(ProductsViewModel.FilterOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await  viewModel.filterSelected(option: option)
                            }
                        }
                    }
                } label: {
                    Text("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")")
                }

            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await  viewModel.categorySelected(option: option)
                            }
                        }
                    }
                } label: {
                    Text("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")")
                }

            }
        })
        .onAppear {
            viewModel.getProducts()
        }
    }
}

#Preview {
    NavigationStack {
        ProductView()
    }
}
