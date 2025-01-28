//
//  Query+EXT.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Michael on 1/28/25.
//

import Foundation
import Combine
import FirebaseFirestore

extension Query {
    
//    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable { // Generic type (T)
//        let snapshot = try await self.getDocuments()
//
//        return try snapshot.documents.map { document in
//            try document.data(as: T.self)
//        }
//    }
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable { // Generic type (T)
        try await getDocumentsWithSnapshot(as: type).products
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let products =  try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
        return (products, snapshot.documents.last)
    }
    
    func startOptionally(afterDocuments lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self}
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration)  where T : Decodable {
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents...")
                return
            }
            
            let products: [T] = documents.compactMap { try? $0.data(as: T.self) }
            publisher.send(products)
        }
        return (publisher.eraseToAnyPublisher(), listener)
    }
}

