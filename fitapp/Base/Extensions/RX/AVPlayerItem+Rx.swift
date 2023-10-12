//
//  AVPlayerItem+Rx.swift
//  
//
//  Created by  on 9/30/20.
//  Copyright © 2020 Nikola Milic. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa

// MARK: - KVO
extension Reactive where Base: AVPlayerItem {
    
    var asset: Observable<AVAsset?> {
        return self.observe(
            AVAsset.self, #keyPath(AVPlayerItem.asset)
        )
    }
    
    var duration: Observable<CMTime> {
        return self.observe(
            CMTime.self, #keyPath(AVPlayerItem.duration)
        ).map { $0 ?? CMTime.zero }
    }
}

extension Reactive where Base: AVPlayer {
    
    func periodicTimeObserver(interval: CMTime) -> Observable<CMTime> {
        return Observable.create { observer in
            let t = self.base.addPeriodicTimeObserver(forInterval: interval, queue: nil) { time in
                observer.onNext(time)
            }
            
            return Disposables.create { self.base.removeTimeObserver(t) }
        }
    }
    
    func boundaryTimeObserver(times: [CMTime]) -> Observable<Void> {
        return Observable.create { observer in
            let timeValues = times.map() { NSValue(time: $0) }
            let t = self.base.addBoundaryTimeObserver(forTimes: timeValues, queue: nil) {
                observer.onNext(())
            }
            
            return Disposables.create { self.base.removeTimeObserver(t) }
        }
    }
}
