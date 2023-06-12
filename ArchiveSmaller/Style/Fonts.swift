//
//  Font.swift
//  ArchiveSmaller
//
//  Created by Dylan Southard on 2023-06-12.
//

import Foundation
import SwiftUI

extension Font {
    //MARK: - === FUTURA ===
    static func futuraMedium(size:CGFloat)->Font{
        return Font.custom( "Futura-Medium", size: size)
    }
    static func futuraBold(size:CGFloat)->Font{
        return Font.custom( "Futura-Bold", size: size)
    }
    
    static func futuraItalic(size:CGFloat)->Font{
        return Font.custom("Futura-MediumItalic", size: size)
    }
    
    static func futuraCondensedMedium(size:CGFloat)->Font{
        return Font.custom( "Futura-CondensedMedium", size: size)
    }
    
    static func futuraCondensedExtraBold(size:CGFloat)->Font{
        return Font.custom("Futura-CondensedExtraBold", size: size)
    }
    
    //MARK: - === PT SANS ===
    static func ptSansRegular(size:CGFloat)->Font{
        return Font.custom( "PTSans-Regular", size: size)
    }
    static func ptSansBold(size:CGFloat)->Font{
        return Font.custom( "PTSans-Bold", size: size)
    }
    
    static func ptSansItalic(size:CGFloat)->Font{
        return Font.custom("PTSans-Italic", size: size)
    }
    
    
    //MARK: - =============== FONT USAGE ===============
    static func primaryRegular(size:CGFloat)->Font{
        return Font.system(size: size)
    }
    static func primaryBold(size:CGFloat)->Font{
        return Font.ptSansBold(size: size)
    }
    
    static func primaryItalic(size:CGFloat)->Font{
        return Font.ptSansItalic(size: size)
    }
    
    static func titleRegular(size:CGFloat)->Font{
        return Font.futuraMedium(size: size)
    }
    static func titleBold(size:CGFloat)->Font{
        return Font.futuraBold(size: size)
    }
    
    static func titleItalic(size:CGFloat)->Font{
        return Font.futuraItalic(size: size)
    }
    
    //MARK: - ===============  ===============
    static var baseTxt:Font {
        return primaryRegular(size: 14)
    }
    
  
}
