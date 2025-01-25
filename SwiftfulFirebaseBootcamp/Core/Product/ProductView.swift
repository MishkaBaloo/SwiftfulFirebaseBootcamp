//
//  ProductView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Michael on 1/23/25.
//

import SwiftUI
import FirebaseFirestore

@MainActor final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    private var lastDocument: DocumentSnapshot? = nil
    
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
        self.products = []
        self.lastDocument = nil
        self.getProducts()
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
        self.products = []
        self.lastDocument = nil
        self.getProducts()
    }
    
    func getProducts() {
        Task {
            let (newProducts, lastDocument) = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDecending, forCategory: selectedCategory?.categoryKey, count: 10, lastDocument: lastDocument)
            
            self.products.append(contentsOf: newProducts)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
//    func getProductsCount() {
//        Task {
//            let count = try await ProductsManager.shared.getAllProductsCount()
//            print("All product count: \(count)")
//        }
//    }
    
//    func getProductByRating() {
//        Task {
////            let newProducts = try await ProductsManager.shared.getProductsByRating(count: 3, lastRating: self.products.last?.rating)
//            let (newProducts, lastDocument) = try await ProductsManager.shared.getProductsByRating(count: 3, lastDocument: lastDocument)
//            self.products.append(contentsOf: newProducts)
//            self.lastDocument = lastDocument
//        }
//    }
}

struct ProductView: View {
    
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
                
                if product == viewModel.products.last {
                    ProgressView()
                        .onAppear {
                            viewModel.getProducts()
                        }
                }
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
