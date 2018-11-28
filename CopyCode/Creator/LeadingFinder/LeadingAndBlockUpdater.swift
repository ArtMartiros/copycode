//
//  LeadingAndBlockUpdater.swift
//  CopyCode
//
//  Created by Артем on 16/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class LeadingAndBlockUpdater {
    private let gridCorrelator = GridLineCorrelator()
    private let startPointGenerator = LeadingStartPointGenerator()
    private let accuracyFinder = LeadingMostAccurateFinder()
    private let chunksCreator = ChunksCreator()
    private let kStandartLowRatio: CGFloat = 0.52 // 0.5384
    private let kLowStandartLowRatio: CGFloat = 0.56
    private let isRetina: Bool
    let grid: TypographicalGrid
    init(grid: TypographicalGrid, isRetina: Bool) {
        self.grid = grid
        self.isRetina = isRetina
    }

    func update(block: SimpleBlock) -> [SimpleBlock] {
        let lowDiffInfos = getDifference(from: block, type: .low, grid: grid)
        getDifference(from: block, type: .lowWithTail, grid: grid)
        let chunks = chunksCreator.create(from: lowDiffInfos, fontSize: grid.leading.fontSize)
        let infos = getLeadingInfos(from: chunks)
        var blocks: [SimpleBlock] = []

        var newGrid = grid
        for (index, info) in infos.enumerated() where index == 0 {
            guard let leading = updatedLeadingSizeAndSpacing(from: info, block: block) else { continue }
            newGrid.update(leading)
            getDifference(from: block, type: .low, grid: newGrid)
            getDifference(from: block, type: .lowWithTail, grid: newGrid)
            let lines = Array(block.lines[info.startLineIndex...info.endLineIndex])
            let blockFrame = lines.map { $0.frame }.compoundFrame
            let updatedBlock = Block(lines: lines, frame: blockFrame, column: block.column, typography: .grid(newGrid))
            let newLeading = updateLeadingStartPoint(oldLeading: leading, with: updatedBlock)
            newGrid.update(newLeading)
            updatedBlock.update(.grid(newGrid))
            getDifference(from: updatedBlock, type: .low, grid: newGrid)
            getDifference(from: updatedBlock, type: .lowWithTail, grid: newGrid)
            blocks.append(updatedBlock)
        }

        return blocks
    }

   private func updateLeadingStartPoint(oldLeading: Leading, with block: SimpleBlock) -> Leading {
        let checker = LeadingChecker()
        var leadingErrors: [LeadigError] = []

        for point in startPointGenerator.generate(from: oldLeading.startPointTop) {
            let leading = Leading(fontSize: oldLeading.fontSize, lineSpacing: oldLeading.lineSpacing, startPointTop: point)
            guard case .success(let error, let precise) = checker.check(block.lines, with: leading) else { continue }
            let leadingError = LeadigError(errorRate: error, preciseRate: precise, leading: leading)
            leadingErrors.append(leadingError)
        }
        guard let newLeading = accuracyFinder.find(from: leadingErrors) else { return oldLeading }
        return newLeading
    }

    private func getDifference(from block: SimpleBlock, type: DifferenceType, grid: TypographicalGrid) -> [DifferenceInfo] {
        print("♦️Leading \(grid.leading) type: \(type)")
        let arrayOfFrames = grid.getArrayOfFrames(from: block.frame)
        let lines = block.lines
        let gridLineCorrelations = gridCorrelator.correlate(lines: lines, arrayOfFrames: arrayOfFrames)
        var diffInfos: [DifferenceInfo] = []
        for (gridIndex, lineIndex) in gridLineCorrelations {
            let standartFrame = arrayOfFrames[gridIndex][0]
            guard let lineIndex = lineIndex,
                let difference = getDifference(for: lines[lineIndex], standardFrame: standartFrame, type: type)
                else { continue }

            let differentInfo = DifferenceInfo(lineIndex: lineIndex, gridIndex: gridIndex, diff: difference)
            diffInfos.append(differentInfo)
            print("type \(type), gi: \(gridIndex), li: \(lineIndex), d: \(difference.rounded(toPlaces: 4))")
        }
        return diffInfos
    }

   private func updatedLeadingSizeAndSpacing(from leadingInfo: LeadingInfo, block: SimpleBlock) -> Leading? {
        let lines = Array(block.lines[leadingInfo.startLineIndex...leadingInfo.endLineIndex])
        let oldLeading = grid.leading
        let lagValue = getLagValue(from: leadingInfo)

        guard let ratio = getLowLetterRatio(lines, height: oldLeading.fontSize)
            else { return nil }

    let standartRatio = useLow(fontSize: oldLeading.fontSize) ? kLowStandartLowRatio : kStandartLowRatio
        print("Bukaki current \(ratio), standart \(standartRatio)")

        let newFontSize = oldLeading.fontSize / (standartRatio / ratio)
        let sizeDiff = newFontSize - oldLeading.fontSize
        let spacing = oldLeading.lineSpacing - lagValue - sizeDiff
        let leading = Leading(fontSize: newFontSize, lineSpacing: spacing, startPointTop: oldLeading.startPointTop)
        return leading
    }

     //в сцене 11 тот же коэф как и в норм разрешении
    //kStandartLowRatio используется только со стандартным шрифтом при ретине дисплее
    private func useLow(fontSize: CGFloat) -> Bool {
        if isRetina {
            return false
        } else {
            return fontSize < 30
        }
    }
    ///difference between first and last diff element
   private func getLagValue(from leadingInfo: LeadingInfo) -> CGFloat {
        guard leadingInfo.diffInfos.count > 1,
            let firstDiff = leadingInfo.diffInfos.first,
            let lastDiff = leadingInfo.diffInfos.last else { return  0 }

        let count = (firstDiff.gridIndex..<lastDiff.gridIndex).count
        let diff = lastDiff.diff - firstDiff.diff
        return diff / CGFloat(count)
    }

    private func getLowLetterRatio(_ lines: [SimpleLine], height: CGFloat) -> CGFloat? {
        let symbolsCountToProve = 100
        var ratioDictionaries: [CGFloat: Int] = [:]
        for line in lines {
            let sortedRatios = line.words
                .map { $0.letters.filter { $0.type == .low } }
                .reduce([], +)
                .map { $0.frame.height / height }
                .sorted()

            let sortedChunks = sortedRatios
                .chunkForSorted { $0 == $1 }
                .sorted { $0.count > $1.count }

            for chunk in sortedChunks {
                guard let ratio = chunk.first else { continue }
                ratioDictionaries[ratio] = (ratioDictionaries[ratio] ?? 0) + chunk.count
            }

            let values = ratioDictionaries.sorted { $0.value > $1.value }
            guard let item = values.first, item.value > symbolsCountToProve else { continue }
            return item.key
        }

        return ratioDictionaries.sorted { $0.value > $1.value }.first?.key
    }

   private func getLeadingInfos(from chunks: [[DifferenceInfo]]) -> [LeadingInfo] {
        var infos: [LeadingInfo] = []

        for (index, chunk) in chunks.enumerated() {
            let nextIndex = index + 1
            var endGridIndex: Int?
            if let endExtended = chunks.optional(atIndex: nextIndex)?.first?.gridIndex {
                endGridIndex = endExtended - 1
            }

            if let leading = LeadingInfo(infos: chunk, endExtendedGridIndex: endGridIndex) {
                infos.append(leading)
            }
        }
        return infos
    }

  private func getDifference(for line: SimpleLine, standardFrame: CGRect, type: DifferenceType) -> CGFloat? {
        switch type {
        case .low:
            let letters = line.words.map { $0.letters.filter { $0.type == .low } }.reduce([], +)

             let differences = letters
                .map { difference($0, with: standardFrame) }
                .sorted { $0 > $1 }

             let differenceChunks = differences.chunkForSorted { $0 == $1 }

            let sortedChunks = differenceChunks.sorted { $0.count > $1.count }
            guard let chunk = sortedChunks.first, let difference = chunk.first else { return nil }
            return difference

        case .lowWithTail:
            guard let first = line.words.sortedFromBottomToTop().first
                else { return nil }
            return difference(first, with: standardFrame)
        }
    }

   private func difference(_ rect: Rectangle, with frame: CGRect) -> CGFloat {
        return rect.frame.bottomY - frame.bottomY
    }
}

extension LeadingAndBlockUpdater {
    struct DifferenceInfo {
        let lineIndex: Int
        let gridIndex: Int
        let diff: CGFloat

        func getDiff(previous: DifferenceInfo) -> CGFloat {
            let diff = previous.diff - self.diff
            let index = gridIndex - previous.gridIndex
            guard index != 0 else { return 0 }
            return diff / CGFloat(index)
        }
    }

    struct LeadingInfo {
        var startGridIndex: Int { return diffInfos.first?.gridIndex ?? 0 }
        var endGridIndex: Int { return diffInfos.last?.gridIndex ?? 0 }
        var startLineIndex: Int { return diffInfos.first?.lineIndex ?? 0 }
        var endLineIndex: Int { return diffInfos.last?.lineIndex ?? 0 }
        let diffInfos: [DifferenceInfo]
        let endExtendedGridIndex: Int?

        init?(infos: [DifferenceInfo], endExtendedGridIndex: Int?) {
            guard !infos.isEmpty else { return nil }
            diffInfos = infos
            self.endExtendedGridIndex = endExtendedGridIndex
        }
    }

    enum DifferenceType {
        case low
        case lowWithTail
    }

//    enum SequenceType {
//        case ascending
//        case descending
//        case same
//
//        init<T: Comparable>(_ first: T, compareTo second: T) {
//            self = first < second ? .ascending : (first > second ? .descending : .same)
//        }
//    }
}

extension LeadingAndBlockUpdater {
    struct ChunksCreator {
        private let kAllowablePercent: CGFloat = 11

        func create(from differenceInfos: [DifferenceInfo], fontSize: CGFloat) -> [[DifferenceInfo]] {
            guard differenceInfos.count > 1 else { return [] }
            var chunks: [[DifferenceInfo]] = []
            var chunk: [DifferenceInfo] = []
            for (previous, current, next) in differenceInfos.previousCurrentNext() {
                let splitOperation = {
                    chunks.append(chunk)
                    chunk = []
                }

                guard let previous = previous else {
                    chunk.append(current)
                    continue
                }
                guard isSameDiff(past: previous, current: current, fontSize: fontSize) else {
                    splitOperation()
                    continue
                }
                chunk.append(current)
                if next == nil, !chunk.isEmpty {
                    chunks.append(chunk)
                }
            }

            return chunks
        }

        private func isSameDiff(past: DifferenceInfo, current: DifferenceInfo, fontSize: CGFloat) -> Bool {
            let difference = current.diff - past.diff
            print("percent \(fontSize.percent(of: difference))")
            let result = abs(fontSize.percent(of: difference)) < kAllowablePercent
            return result
        }
    }
}

extension Array where Element == LeadingAndBlockUpdater.DifferenceInfo {
    fileprivate var averageDiff: CGFloat? {
        guard self.count > 1 else { return nil }
        return last!.getDiff(previous: first!)
    }
}
