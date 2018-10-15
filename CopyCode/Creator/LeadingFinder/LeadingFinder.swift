//
//  LeadingFinder.swift
//  CopyCode
//
//  Created by Артем on 13/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LeadingFinder {
    
    private let mostAccurateFinder = LeadingMostAccurateFinder()
    
    func find(_ block: Block<LetterRectangle>) -> Leading? {
        let distanceFinder = LeadingDistanceFinder(block: block)
        let startPointGenerator = LeadingStartPointGenerator()
        let spaceFinder = LeadingSpaceFinder(block: block)
        
        let result = distanceFinder.find()
        switch result {
        case .success(let range):
            let point = block.lineWithMaxHeight().frame.topY
            let leadingErrors = startPointGenerator.generate(from: point)
                .map { spaceFinder.find(in: range, startPoint: $0)}
                .reduce([], +)
            
            return mostAccurateFinder.find(from: leadingErrors)
        case .failure:  return nil
        }
    }
}
