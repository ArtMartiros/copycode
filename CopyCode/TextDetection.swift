//
//  TextDetection.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Vision
import AppKit

typealias VNTextObservationsCompletionHandler = ([VNTextObservation], Error?) -> Void

final class TextDetection {

    func performRequest(cgImage: CGImage, completionHandler: VNTextObservationsCompletionHandler? ) {
        let requests = createRequests(completionHandler: completionHandler)
        performImageRequest(cgImage: cgImage, requests: requests)
    }

    private func createRequests(completionHandler: VNTextObservationsCompletionHandler? ) -> [VNRequest] {
        let textRequest = VNDetectTextRectanglesRequest { request, error in
            let results = request.results?.compactMap { $0 as? VNTextObservation } ?? []
            completionHandler?(results, error)
        }

        textRequest.reportCharacterBoxes = true
        return [textRequest]
    }

    private func performImageRequest(cgImage: CGImage, requests: [VNRequest]) {
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .downMirrored, options: [:])
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print(error)
        }
    }
}
