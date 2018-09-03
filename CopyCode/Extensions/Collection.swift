//
//  Collection.swift
//  CopyCode
//
//  Created by Артем on 04/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension Collection {
    func chunkForSorted(_ compare: (Element, Element) -> Bool ) -> [[Element]] {
        var chunk: [Element] = []
        var chunks: [[Element]] = []
        var itemForCompare: Element!
        for (index, item) in self.enumerated() {
            //первоначальная установка
            if index == 0 { itemForCompare = item }
            
            //сама логика
            if compare(itemForCompare, item) {
                chunk.append(item)
            } else {
                chunks.append(chunk)
                itemForCompare = item
                chunk = [item]
            }
            
            //если последний элемент то надо записать все, что в буфере
            let isLastElement = index + 1 == self.count
            guard !isLastElement else  {
                chunks.append(chunk)
                continue
            }
            
        }
        return chunks
    }
}
