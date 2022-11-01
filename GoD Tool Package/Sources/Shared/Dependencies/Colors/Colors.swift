//
//  Colors.swift
//  
//
//  Created by Stars Momodu on 15/06/2022.
//

import Foundation

public enum Colors {}

public extension Colors {
    enum Reds: Int, HexColor, CaseIterable {
        case lightCoral = 0xF08080
        case indianRed = 0xCD5C5C
        case crimson = 0xDC143C
        case firebrick = 0xB22222
        case darkred = 0x8B0000
        case red = 0xFF0000
        case coral = 0xFF7F50
        case tomato = 0xFF6347
        case orangered = 0xFF4500
        case maroon = 0x80000
    }
}
public extension Colors {
    enum Oranges: Int, HexColor, CaseIterable {
        case lightSalmon = 0xFFA07A
        case salmon = 0xFA8072
        case darkSalmon = 0xE9967A
        case orangered = 0xFF4500
        case gold = 0xFFD700
        case orange = 0xFFA500
        case darkorange = 0xFF8C00
        case peachpuff = 0xFFDAB9
        case blanchedalmond = 0xFFEBCD
        case bisque = 0xFFE4C4
        case navajowhite = 0xFFDEAD
        case sandybrown = 0xF4A460
    }
}

public extension Colors {
    enum Yellows: Int, HexColor, CaseIterable {
        case lightyellow = 0xFFFFE0
        case lemonchiffon = 0xFFFACD
        case lightgoldenrodyellow = 0xFAFAD2
        case papayawhip = 0xFFEFD5
        case moccasin = 0xFFE4B5
        case palegoldenrod = 0xEEE8AA
        case khaki = 0xF0E68C
        case darkkhaki = 0xBDB76B
        case yellow = 0xFFFF00
        case beige = 0xF5F5DC
        case cornsilk = 0xFFF8DC
        case goldenrod = 0xDAA520
    }
}

public extension Colors {
    enum Greens: Int, HexColor, CaseIterable {
        case lawngreen = 0x7CFC00
        case chartreuse = 0x7FFF00
        case limegreen = 0x32CD32
        case lime = 0x00FF00
        case forestgreen = 0x228B22
        case green = 0x008000
        case darkgreen = 0x006400
        case greenyellow = 0xADFF2F
        case yellowgreen = 0x9ACD32
        case springgreen = 0x00FF7F
        case mediumspringgreen = 0x00FA9A
        case lightgreen = 0x90EE90
        case palegreen = 0x98FB98
        case darkseagreen = 0x8FBC8F
        case mediumseagreen = 0x3CB371
        case seagreen = 0x2E8B57
        case olive = 0x808000
        case darkolivegreen = 0x556B2F
        case olivedrab = 0x6B8E23
        case paleturquoise = 0xAFEEEE
        case turquoise = 0x40E0D0
        case lightseagreen = 0x20B2AA
        case aquamarine = 0x7FFFD4
        case mediumaquamarine = 0x66CDAA
    }
}

public extension Colors {
    enum Blues: Int, HexColor, CaseIterable {
        case lightcyan = 0xE0FFFF
        case cyan = 0x00FFFF
        case aqua = 0x00FFFF
        case paleturquoise = 0xAFEEEE
        case turquoise = 0x40E0D0
        case mediumturquoise = 0x48D1CC
        case darkturquoise = 0x00CED1
        case cadetblue = 0x5F9EA0
        case darkcyan = 0x008B8B
        case teal = 0x008080
        case powderblue = 0xB0E0E6
        case lightblue = 0xADD8E6
        case lightskyblue = 0x87CEFA
        case skyblue = 0x87CEEB
        case deepskyblue = 0x00BFFF
        case lightsteelblue = 0xB0C4DE
        case dodgerblue = 0x1E90FF
        case cornflowerblue = 0x6495ED
        case steelblue = 0x4682B4
        case royalblue = 0x4169E1
        case blue = 0x0000FF
        case mediumblue = 0x0000CD
        case darkblue = 0x00008B
        case navy = 0x000080
        case midnightblue = 0x191970
        case mediumslateblue = 0x7B68EE
        case slateblue = 0x6A5ACD
        case darkslateblue = 0x483D8B
        case blueviolet = 0x8A2BE2
        case indigo = 0x4B0082
    }
}

public extension Colors {
    enum Purples: Int, HexColor, CaseIterable {
        case lavender = 0xE6E6FA
        case thistle = 0xD8BFD8
        case plum = 0xDDA0DD
        case violet = 0xEE82EE
        case orchid = 0xDA70D6
        case mediumorchid = 0xBA55D3
        case mediumpurple = 0x9370DB
        case blueviolet = 0x8A2BE2
        case darkviolet = 0x9400D3
        case darkorchid = 0x9932CC
        case darkmagenta = 0x8B008B
        case purple = 0x800080
        case mediumvioletred = 0xC71585
    }
}

public extension Colors {
    enum Pinks: Int, HexColor, CaseIterable {
        case fuchsia = 0xFF00FF
        case magenta = 0xFF00FF
        case pink = 0xFFC0CB
        case lightpink = 0xFFB6C1
        case hotpink = 0xFF69B4
        case deeppink = 0xFF1493
        case palevioletred = 0xDB7093
    }
}

public extension Colors {
    enum Browns: Int, HexColor, CaseIterable {
        case linen = 0xFAF0E6
        case wheat = 0xF5DEB3
        case burlywood = 0xDEB887
        case tan = 0xD2B48C
        case rosybrown = 0xBC8F8F
        case peru = 0xCD853F
        case chocolate = 0xD2691E
        case saddlebrown = 0x8B4513
        case sienna = 0xA0522D
        case brown = 0xA52A2A
    }
}

public extension Colors {
    enum Whites: Int, HexColor, CaseIterable {
        case white = 0xFFFFFF
    }
}

public extension Colors {
    enum Blacks: Int, HexColor, CaseIterable {
        case black = 0x000000
    }
}

public extension Colors {
    enum Greys: Int, HexColor, CaseIterable {
        case whitesmoke = 0xF5F5F5
        case gainsboro = 0xDCDCDC
        case lightgray = 0xD3D3D3
        case lightgrey = 0xD3D3D3
        case silver = 0xC0C0C0
        case darkgray = 0xA9A9A9
        case darkgrey = 0xA9A9A9
        case gray = 0x808080
        case grey = 0x808080
        case dimgray = 0x696969
        case lightslategray = 0x778899
        case lightslategrey = 0x778899
        case slategray = 0x708090
        case slategrey = 0x708090
        case darkslategray = 0x2F4F4F
        case darkslategrey = 0x2F4F4F
    }
}
