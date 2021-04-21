//
//  PermissionUtil.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 21/04/2021.
//

import Foundation
import RxSwift
import MediaPlayer
import Photos

class PermissionUtil {
    static func requestMPMediaLibraryPermission() -> Completable {
        Completable.create { (completable) -> Disposable in
            MPMediaLibrary.requestAuthorization({(newPermissionStatus: MPMediaLibraryAuthorizationStatus) in
                switch (newPermissionStatus) {
                case .authorized:
                    completable(.completed)
                case .notDetermined:
                    MPMediaLibrary.requestAuthorization { (status) in
                        switch (status) {
                        case .authorized:
                            completable(.completed)
                        case .denied:
                            completable(.error(HError.permissionDenied))
                        case .restricted:
                            completable(.error(HError.permissionDenied))
                        case .notDetermined:
                            completable(.error(HError.permissionDenied))
                        @unknown default:
                            completable(.error(HError.permissionDenied))
                        }
                    }
                case .denied:
                    completable(.error(HError.permissionDenied))
                case .restricted:
                    completable(.error(HError.permissionDenied))
                @unknown default:
                    completable(.error(HError.permissionDenied))
                }
            })
            return Disposables.create()
        }
    }
    
    static func requestPHPhotoLibraryPermission() -> Completable {
        Completable.create { (completable) -> Disposable in
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                completable(.completed)
            case .notDetermined, .limited:
                PHPhotoLibrary.requestAuthorization({status in
                    switch (status) {
                    case .authorized:
                        completable(.completed)
                    case .denied:
                        completable(.error(HError.permissionDenied))
                    case .restricted:
                        completable(.error(HError.permissionDenied))
                    case .notDetermined:
                        completable(.error(HError.permissionDenied))
                    case .limited:
                        completable(.completed)
                    @unknown default:
                        completable(.error(HError.permissionDenied))
                    }
                })
            case .denied:
                completable(.error(HError.permissionDenied))
            case .restricted:
                completable(.error(HError.permissionDenied))
            default:
                completable(.error(HError.permissionDenied))
            }
            return Disposables.create()
        }
    }
    
    static func requestCameraVideoPermission() -> Completable {
        Completable.create { (completable) -> Disposable in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                completable(.completed)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        completable(.completed)
                    } else {
                        completable(.error(HError.permissionDenied))
                    }
                }
            case .denied:
                completable(.error(HError.permissionDenied))
            case .restricted:
                completable(.error(HError.permissionDenied))
            @unknown default:
                completable(.error(HError.permissionDenied))
            }
            return Disposables.create()
        }
    }
    
    static func requestRecordAudioPermission() -> Completable {
        Completable.create { (completable) -> Disposable in
            switch AVAudioSession.sharedInstance().recordPermission {
            case .undetermined:
                AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                    if granted {
                        completable(.completed)
                    } else {
                        completable(.error(HError.permissionDenied))
                    }
                })
            case .granted:
                completable(.completed)
            case .denied:
                completable(.error(HError.permissionDenied))
            @unknown default:
                completable(.error(HError.permissionDenied))
            }
            return Disposables.create()
        }
    }
}
