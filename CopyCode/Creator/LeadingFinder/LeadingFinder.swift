//
//  LeadingFinder.swift
//  CopyCode
//
//  Created by Артем on 13/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LeadingFinder {

    func find(_ block: Block<LetterRectangle>) -> Leading? {
        let lines = block.lines
        let gaps = block.gaps.map { $0.frame }
        let maxLineHeight = block.maxLineHeight()
        
        let startPointFinder = LeadingStartPointFinder(lines: lines, gaps: gaps, maxLineHeight: maxLineHeight)
        let distanceFinder = LeadingDistanceFinder(lines: lines, gaps: gaps, maxLineHeight: maxLineHeight)
        
        let result = distanceFinder.find()
        switch result {
        case .success(let range):
            let leadings = startPointFinder.find(in: range)
            return leadings.last
        case .failure:  return nil
        }
    }
}
