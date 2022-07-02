//
//  KBType.swift
//  Kolonbase
//
//  Created by mk on 2020/10/13.
//

import Foundation

// MARK: - Response
public struct KBChildResponse<T: Codable>: Codable {
	
	public var code: String
	public var message: String?
	public var data: String?
	public var child: KBDataResponse<T>
}

public struct KBDataResponse<T: Codable>: Codable {
	
	public var code: String
    public var message: String?
	public var data: T?
	public var child: String?
}

public struct KBResultData<T: Codable>: Codable {
	
    public var zResultCd: String
    public var zResultMsg: String
	public var data: T
}

public struct KBResultCode: Codable {
	
	public var resultCode: String
	public var resultMsg: String
}

public struct KBBaseResponse<T: Codable>: Codable {
    
    public var code: String?
    public var message: String?
    public var data: T?
    public var child: KBDataResponse<T>?
}
