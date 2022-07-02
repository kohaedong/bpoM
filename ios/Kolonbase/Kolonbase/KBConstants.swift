//  Desc : 각 모듈에서 사용되는 설정 데이터
//
//  KBConstants.swift
//  Kolonbase
//
//  Created by mk on 2020/10/14.
//

import Foundation

public class KBConstants {
    public static let shared = KBConstants()
    let reply_max: CGFloat = 1000
}

// 번들 ID
public let baseBundleId : String = "com.kolon.kolonbase"

public var API_URL : String = {
    if KB.KeyChain.isDev{
        return "https://appdev.kolon.com"
    }else{
        return "https://apps.kolon.com"
    }
}()

// 호스트 정보
public var login_host : String = {
    // ID/PW 로그인 - IKEN 앱에서는 사용 안 함
    if KB.KeyChain.isDev{
        return API_URL + "/common/v2/api/basiclogin/auth"
    }else{
        return API_URL + "/common/v2/api/basiclogin/auth"
    }
}()

public var auth_host : String = {
    // OAuth 로그인 - IKEN 앱에서 사용
    if KB.KeyChain.isDev{
        return API_URL + "/common/oauth/token"
    }else{
        return API_URL + "/common/oauth/token"
    }
}()

public var api_host : String = {
    // API 호스트
    if KB.KeyChain.isDev{
        return API_URL + "/ikenapp/v2/api"
    }else{
        return API_URL + "/ikenapp/v2/api"
    }
}()

public var rest_host : String = {
    // REST 호스트 (업데이트, 공지, 캡처)
    if KB.KeyChain.isDev{
        return API_URL + "/common/v2/api"
    }else{
        return API_URL + "/common/v2/api"
    }
}()

public var fcmNotice_host : String = {
    // FCM 공지 URL
    if KB.KeyChain.isDev{
        return "https://iken-app.web.app/iken_app_trouble/"
    }else{
        return "https://iken-app.web.app/iken_app_trouble/"
    }
}()


// 회사 코드
public enum CompanyCode: String {
	
	case noncode = "NONCODE"
	case mod = "MOD"
	case kfnt = "KFNT"
	case kib = "KIB"
	case whcc = "WHCC"
	case nbg = "NBG"
	case swm = "SWM"
	case kic = "KIC"
	case kii = "KII"
	case csh = "CSH"
	case khr = "KHR"
	case kec = "KEC"
	case kgt = "KGT"
	case kda = "KDA"
	case kfm = "KFM"
	case kbi = "KBI"
	case ls = "LS"
	case kls = "KLS"
	case kat = "KAT"
	case kam = "KAM"
	case kac = "KAC"
	case kap = "KAP"
	case ipp = "IPP"
	case kpc = "KPC"
	case tgi = "TGI"
	case ktp = "KTP"
	case khv = "KHV"
	case kaf = "KAF"

	public var name: String {
		
		switch self {
			
			case .noncode:
				return "코오롱"
			case .mod:
				return "(주)MOD"
			case .kfnt:
				return "(주)케이에프엔티"
			case .kib:
				return "KOLON INDUSTRIES BINH DUONG"
			case .whcc:
				return "그린나래(주)"
			case .nbg:
				return "네이처브리지(주)"
			case .swm:
				return "스위트밀(주)"
			case .kic:
				return "인더스트리 FnC부문"
			case .kii:
				return "인더스트리 제조부문"
			case .csh:
				return "코오롱"
			case .khr:
				return "코오롱LSI(주)"
			case .kec:
				return "코오롱글로벌"
			case .kgt:
				return "코오롱글로텍"
			case .kda:
				return "코오롱데크컴퍼지트"
			case .kfm:
				return "코오롱머티리얼(주)"
			case .kbi:
				return "코오롱바스프이노폼"
			case .ls:
				return "코오롱베니트"
			case .kls:
				return "코오롱생명과학(주)"
			case .kat:
				return "코오롱아우토(주)"
			case .kam:
				return "코오롱오토모티브"
			case .kac:
				return "코오롱오토케어서비스(주)"
			case .kap:
				return "코오롱오토플랫폼(주)"
			case .ipp:
				return "코오롱인베스트먼트"
			case .kpc:
				return "코오롱제약"
			case .tgi:
				return "코오롱티슈진(주)"
			case .ktp:
				return "코오롱플라스틱(주)"
			case .khv:
				return "코오롱하우스비전(주)"
			case .kaf:
				return "코오롱화이버 주식회사"
		}
	}
}

// 카페 코드
public enum CafeCode: String {
	
	case 과천본사 = "1"
	case 코오롱_구미공장 = "5"
	case 코오롱_경산공장 = "6"
	case 코오롱_김천공장 = "7"
	case KOLON_OneAndOnly_TOWER = "8"
	case 코오롱_인천공장 = "9"
	case 코오롱_울산공장 = "10"
	case 제약_대전공장 = "11"
	case 코오롱_대산공장 = "12"
	case 글로텍_구미공장 = "13"
	
	public var name: String {
		
		switch self {
			
			case .과천본사:
				return "과천 본사"
			case .코오롱_구미공장:
				return "코오롱 구미공장"
			case .코오롱_경산공장:
				return "코오롱 경산공장"
			case .코오롱_김천공장:
				return "코오롱 김천공장"
			case .KOLON_OneAndOnly_TOWER:
				return "KOLON One&Only TOWER(개발)"
			case .코오롱_인천공장:
				return "코오롱 인천공장"
			case .코오롱_울산공장:
				return "코오롱 울산공장"
			case .제약_대전공장:
				return "제약 대전공장"
			case .코오롱_대산공장:
				return "코오롱 대산공장"
			case .글로텍_구미공장:
				return "글로텍 구미공장"
		}
	}
}
