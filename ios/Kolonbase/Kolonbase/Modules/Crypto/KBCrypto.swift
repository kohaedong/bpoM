//  Desc : 암호화 처리 (AES 256 CBC)
//
//  KBCrypto.swift
//  Kolonbase
//
//  Created by mk on 2020/10/15.
//

import Foundation
import CommonCrypto

// MARK: -  KB Crypto
public class KBCrypto: NSObject {
	
	static let shared = KBCrypto()
		
	private override init() {}
	
	// for AES256
	let key256 = "ZmuYwVKPlNBHNRYTFsPT5skkV4FVuzlL"	// 32 Bytes
	let iv = "ZmuYwVKPlNBHNRYT"						// 16 Bytes
	
	public func encrypt(text: String) -> Data? {
		
		let aes = AES(key: key256, iv: iv)
		let data = aes?.encrypt(string: text)
		
		return data
	}
	
	public func decrypt(data: Data) -> String? {
		
		let aes = AES(key: key256, iv: iv)
		let string = aes?.decrypt(data: data)
		
		return string
	}
}


struct AES {
	
	private let key: Data
	private let iv: Data
	
	init?(key: String, iv: String) {
		guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
			debugPrint("Error: Failed to set a key.")
			return nil
		}
		
		guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
			debugPrint("Error: Failed to set an initial vector.")
			return nil
		}
		
		
		self.key = keyData
		self.iv  = ivData
	}
	
	
	func encrypt(string: String) -> Data? {
		return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
	}
	
	func decrypt(data: Data?) -> String? {
		guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
		return String(bytes: decryptedData, encoding: .utf8)
	}
	
	func crypt(data: Data?, option: CCOperation) -> Data? {
		guard let data = data else { return nil }
		
		let cryptLength = data.count + kCCBlockSizeAES128
		var cryptData   = Data(count: cryptLength)
		
		let keyLength = key.count
		let options   = CCOptions(kCCOptionPKCS7Padding)
		
		var bytesLength = Int(0)
		
		let status = cryptData.withUnsafeMutableBytes { cryptBytes in
			data.withUnsafeBytes { dataBytes in
				iv.withUnsafeBytes { ivBytes in
					key.withUnsafeBytes { keyBytes in
						CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
					}
				}
			}
		}
		
		guard UInt32(status) == UInt32(kCCSuccess) else {
			debugPrint("Error: Failed to crypt data. Status \(status)")
			return nil
		}
		
		cryptData.removeSubrange(bytesLength..<cryptData.count)
		return cryptData
	}
}
