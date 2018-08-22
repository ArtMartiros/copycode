//
//  CustomColumnCreator.swift
//  CopyCode
//
//  Created by Артем on 21/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

class CustomColumnCreator<WordChild: Rectangle> {
    func create(from words: [Word<WordChild>]) ->  [CustomColumn]  {
        let distance: CGFloat = 10
        let dictionary = createColumnDictionary(from: words, withDistance: distance)
        let updatedDictionary = updatedColumnDictionary(dictionary: dictionary, distance: distance)
        let findedColumns = findCustomColumns(from: updatedDictionary, columns: 3)
        let columns = columnsFrom(from: findedColumns)
        return columns
    }
    
    private func createColumnDictionary(from words: [Word<WordChild>], withDistance distance: CGFloat) -> [CGFloat: [StandartRectangle]] {
        let wordsSortedByX = words.sorted { $0.frame.leftX < $1.frame.leftX }
        
        var dictionary: [CGFloat: [StandartRectangle]] = [:]
        for word in wordsSortedByX {
            var currentLeftX = CGFloat(Int(word.frame.leftX / distance) * Int(distance))
            while true {
                let nextLeftX = currentLeftX + distance
                //вышел за пределы, больше нет смысла дальше
                if word.frame.rightX <= currentLeftX { break }
                
                dictionary.append(element: word, toKey: currentLeftX)
                currentLeftX = nextLeftX
            }
        }
        return dictionary
    }
    
    private func updatedColumnDictionary(dictionary: [CGFloat: [StandartRectangle]],
                                         distance: CGFloat) -> [CGFloat: [ClosedRange<CGFloat>]] {
        let lastKey = dictionary.keys.sorted().last ?? 0
        let lastElement = Int(lastKey / distance)
        
        var allGaps: [CGFloat: [ClosedRange<CGFloat>]] = [:]
        let gapsCreator = GapsCreator()
        for index in 0...lastElement {
            let leftX = CGFloat(index) * distance
            if let rects = dictionary[leftX] {
                let sortedRects = rects.sorted { $0.frame.bottomY < $1.frame.bottomY }
                let gaps = gapsCreator.createVertical(from: sortedRects, last: 1440)
                    .filter { $0.distance > 50 }
                    .sorted { $0.distance > $1.distance }
                allGaps[leftX] = gaps
            } else {
                allGaps[leftX] = [0...1440]
            }
        }
        return allGaps
    }
    
    private func findCustomColumns(from gaps: [CGFloat: [ClosedRange<CGFloat>]], columns: Int) -> [CGFloat: [ClosedRange<CGFloat>]] {
        var dictionary: [CGFloat: [ClosedRange<CGFloat>]] = [:]
        var sortedGaps = gaps.sorted { $0.value[0].distance > $1.value[0].distance }
        
        for _ in 0..<columns {
            let maxGap = sortedGaps[0]
            dictionary[maxGap.key] = maxGap.value
            let range = (maxGap.key - 200)...(maxGap.key + 200)
            sortedGaps = sortedGaps.filter { !range.contains($0.key) }
        }
        
        return dictionary
        
    }
    
    private func columnsFrom(from dictionary: [CGFloat: [ClosedRange<CGFloat>]]) -> [CustomColumn] {
        var newGaps: [CustomColumn] = []
        
        for item in dictionary {
            let value = item.value[0]
            let rect = CGRect(x: item.key, y: value.lowerBound, width: 4, height: value.distance)
            newGaps.append(CustomColumn(frame: rect))
        }
        return newGaps
    }
}
