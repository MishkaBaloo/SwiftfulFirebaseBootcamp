//
//  ProductView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Michael on 1/23/25.
//

import SwiftUI
import FirebaseFirestore

struct ProductView: View {
    
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
                    .contextMenu {
                        Button("Add to favorites") {
                            viewModel.addUserFavoriteProduct(productId: product.id)
                        }
                    }
                
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
