////
////  StorageReference.swift
////  CopyCode
////
////  Created by Артем on 11/12/2018.
////  Copyright © 2018 Artem Martirosyan. All rights reserved.
////
//
//import Foundation
//import FirebaseStorage
//import BoltsSwift
//
//extension StorageReference {
//    func putFileTask(from url: URL, metadata: StorageMetadata?) -> Task<StorageMetadata> {
//        let taskCompletionSource = TaskCompletionSource<StorageMetadata>()
//        putFile(from: url, metadata: metadata) { (data, error) in
//            if let error = error {
//                taskCompletionSource.set(error: error)
//            } else if let data = data {
//                taskCompletionSource.set(result: data)
//            } else {
//                taskCompletionSource.cancel()
//            }
//        }
//        return taskCompletionSource.task
//    }
//
//    func putDataTask(_ uploadedData: Data, metadata: StorageMetadata?) -> Task<StorageMetadata> {
//        let taskCompletionSource = TaskCompletionSource<StorageMetadata>()
//        putData(uploadedData, metadata: metadata) { (data, error) in
//            if let error = error {
//                taskCompletionSource.set(error: error)
//            } else if let data = data {
//                taskCompletionSource.set(result: data)
//            } else {
//                taskCompletionSource.cancel()
//            }
//        }
//        return taskCompletionSource.task
//    }
//
//    func downloadURLTask() -> Task<URL> {
//        let taskCompletionSource = TaskCompletionSource<URL>()
//        downloadURL { (url, error) in
//            if let error = error {
//                taskCompletionSource.set(error: error)
//            } else if let url = url {
//                taskCompletionSource.set(result: url)
//            } else {
//                taskCompletionSource.cancel()
//            }
//        }
//        return taskCompletionSource.task
//    }
//
//}
