//
//  String+Extension.swift
//  IKEN-Work
//
//  Created by mk on 2021/01/06.
//

import Foundation

public extension String {
	
	func stringToDate(format: String) -> Date? {
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ko_KR")
		dateFormatter.dateFormat = format
		
		return dateFormatter.date(from: self)
	}
    
    func convertRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                       length: utf16.distance(from: from!, to: to!))
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {

            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToMutableAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {

            return try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var withoutHtml: String {
         guard let data = self.data(using: .utf8) else {
             return self
         }

         let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
             .documentType: NSAttributedString.DocumentType.html,
             .characterEncoding: String.Encoding.utf8.rawValue
         ]

         guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
             return self
         }

         return attributedString.string
     }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var glyphCount: Int {
        
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isRealEmoji : Bool {
        if self.count == 1 {
            let emodjiGlyphPattern = "\\p{RI}{2}|(\\p{Emoji}(\\p{EMod}|\\x{FE0F}\\x{20E3}?|[\\x{E0020}-\\x{E007E}]+\\x{E007F})|[\\p{Emoji}&&\\p{Other_symbol}])(\\x{200D}(\\p{Emoji}(\\p{EMod}|\\x{FE0F}\\x{20E3}?|[\\x{E0020}-\\x{E007E}]+\\x{E007F})|[\\p{Emoji}&&\\p{Other_symbol}]))*"

            let fullRange = NSRange(location: 0, length: self.utf16.count)
            if let regex = try? NSRegularExpression(pattern: emodjiGlyphPattern, options: .caseInsensitive) {
                let regMatches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(), range: fullRange)
                if regMatches.count > 0 {
                    // if any range found — it means, that that single character is emoji
                    return true
                }
            }
        }
        return false
    }

    
    var isSingleEmoji: Bool {
        
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        if self.isRealEmoji { return true }
        return unicodeScalars.contains { $0.isEmoji }
        
    }
    
    var containsOnlyEmoji: Bool {
        
        return !isEmpty
            && !unicodeScalars.contains(where: {
                !$0.isEmoji
                    && !$0.isZeroWidthJoiner
            })
    }
    
    // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
    // If anyone has suggestions how to improve this, please let me know
    var emojiString: String {
        
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            
            previousScalar = scalar
        }
        
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map{ String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
    
    /**
     특수문자    => 치환문자
     =    &eq;
     |    &pi;
     ^    &sq;
     %    &ps;
     */
    var encodeMiaps: String {
        var result = self
        result = result.replacingOccurrences(of:"=", with:"&eq;");
        result = result.replacingOccurrences(of:"|", with:"&pi;");
        result = result.replacingOccurrences(of:"^", with:"&sq;");
        result = result.replacingOccurrences(of:"%", with:"&ps;");
        return result
    }
    
    /**
     특수문자    <= 치환문자
     =    &eq;
     |    &pi;
     ^    &sq;
     %    &ps;
     */
    var decodeMiaps: String {
        var result = self
        result = result.replacingOccurrences(of:"&eq;", with:"=")
        result = result.replacingOccurrences(of:"&pi;", with:"|")
        result = result.replacingOccurrences(of:"&sq;", with:"^")
        result = result.replacingOccurrences(of:"&ps;", with:"%")
        return result
    }
}


public extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        //U+1FAB0
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        127000...127600, // Various asian characters
        65024...65039, // Variation selector
        9100...9300, // Misc items
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        
        return value == 8205
    }
    
    
}
 

public extension StringProtocol {
	
	func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
		
		range(of: string, options: options)?.lowerBound
	}
	
	func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
		
		range(of: string, options: options)?.upperBound
	}
	
	func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
		
		ranges(of: string, options: options).map(\.lowerBound)
	}
	
	func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
		
		var result: [Range<Index>] = []
		var startIndex = self.startIndex
		
		while startIndex < endIndex,
			let range = self[startIndex...]
				.range(of: string, options: options) {
			
				result.append(range)
			
				startIndex = range.lowerBound < range.upperBound ? range.upperBound :
					index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
		}
		
		return result
	}
}
