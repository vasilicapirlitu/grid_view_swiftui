//
//  ContentView.swift
//  GridViewSwiftUI
//
//  Created by Pirlitu Vasilica on 18/08/2020.
//  Copyright © 2020 Pirlitu Vasilica. All rights reserved.
//

import SwiftUI


class SGConvenience{
    #if os(watchOS)
    static var deviceWidth:CGFloat = WKInterfaceDevice.current().screenBounds.size.width
    #elseif os(iOS)
    static var deviceWidth:CGFloat = UIScreen.main.bounds.size.width
    #elseif os(macOS)
    static var deviceWidth:CGFloat = NSScreen.main?.frame.size.width ?? 0
    #endif
}

class WillResign {
    #if os(watchOS)
    static var name: NSNotification.Name = UIApplication.willResignActiveNotification
    #elseif os(iOS)
    static var name: NSNotification.Name = UIApplication.willResignActiveNotification
    #elseif os(macOS)
    static var name: NSNotification.Name = NSApplication.willResignActiveNotification
    #endif
}



extension Text {
    var customMediumText: Text {
        self.font(.custom("ArialRoundedMTBold", size: 24))
    }
    
    var customSmallText: Text {
        self.font(.custom("ArialRoundedMTBold", size: 12))
    }
    
    func customSize(size: CGFloat) -> Text  {
        self.font(.custom("ArialRoundedMTBold", size: size))
    }
    
    var customLargeText: Text {
        self.font(.custom("ArialRoundedMTBold", size: 36))
    }
    
    func arialSize(size: CGFloat) -> Text  {
        self.font(.custom("ArialRoundedMTBold", size: size))
    }
    
    func arialSize() -> Text  {
        self.font(.custom("ArialRoundedMTBold", size: SGConvenience.deviceWidth > 500 ? 30 : 20))
    }
    
    func arialSizeMedium() -> Text  {
        self.font(.custom("ArialRoundedMTBold", size: SGConvenience.deviceWidth > 500 ? 20 : 15))
    }
    
    func arialSizeSmall() -> Text  {
        self.font(.custom("ArialRoundedMTBold", size: SGConvenience.deviceWidth > 500 ? 18 : 10))
    }
}

extension Font {
    static func arialSize() -> Font {
        .custom("ArialRoundedMTBold", size: SGConvenience.deviceWidth > 500 ? 30 : 20)
    }
    
    static func arialSizeMedium() -> Font {
        .custom("ArialRoundedMTBold", size: SGConvenience.deviceWidth > 500 ? 20 : 10)
    }
    
    static func arialSizeSmall() -> Font {
        .custom("ArialRoundedMTBold", size: SGConvenience.deviceWidth > 500 ? 20 : 12)
    }
}

