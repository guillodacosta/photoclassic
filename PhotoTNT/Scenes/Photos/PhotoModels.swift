//
//  PhotoModels.swift
//  Photo
//
//  Created by Guillermo Diaz on 8/17/22.
//

enum Photo {
    
    enum FetchPhotos {
        
        struct RequestPaginated {
            let limit: Int
            let start: Int
        }
        
        struct Response: Codable {
            let albumId: Int
            let id: Int
            let thumbnailUrl: String
            let title: String
            let url: String
        }
        
        struct ViewModel {
            let id: Int
            let thumbnailUrl: String
            let title: String
            let url: String
        }
    }
    
    enum ShowDetail {
        struct ViewModel {
            let id: Int
            let thumbnailUrl: String
            let title: String
            let url: String
        }
    }
}
