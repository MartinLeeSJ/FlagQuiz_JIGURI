//
//  FQCountryISOCode.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import Foundation
import IsoCountryCodes

struct FQCountryISOCode: Codable {
    var numericCode: String
    
    init(_ numericCode: String) {
        self.numericCode = numericCode
    }
    
    var localizedName: String? {
        if let alpha2 = IsoCountryCodes.find(key: numericCode)?.alpha2 {
            return Locale.current.localizedString(forRegionCode: alpha2)
        }
        return nil
    }
    
    var flagEmoji: String? {
        IsoCountryCodes.find(key: numericCode)?.flag
    }
    
}


extension FQCountryISOCode: Equatable { }

extension FQCountryISOCode: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(numericCode)
    }
}

extension FQCountryISOCode {
    
    static func todaysCode() -> FQCountryISOCode? {
        let calendar = Calendar.current
        let today = Date.now
        guard let startOfYear = calendar.dateInterval(of: .year, for: today)?.start,
              let daySinceStartOfYear: Int = calendar.dateComponents([.day], from: startOfYear, to: today).day else {
            return nil
        }
        
        let allCountryCount = FQCountryISOCode.safeAllCodesCount
        let todayIndex = daySinceStartOfYear % allCountryCount
        return FQCountryISOCode.safeAllCodes[todayIndex]
        
    }
    
    static func randomCode(of count: Int, except: FQCountryISOCode?) -> [FQCountryISOCode] {
        Array(Self.safeAllCodes.filter {
            if let except {
                return ($0 != except)
            }
            return true
        }.shuffled().prefix(upTo: count))
    }
    
    static var safeAllCodesCount: Int {
        Self.safeAllCodes.count
    }
    
    static let safeAllCodes: [FQCountryISOCode] = [
            FQCountryISOCode("004"),
            FQCountryISOCode("248"),
            FQCountryISOCode("008"),
            FQCountryISOCode("012"),
            FQCountryISOCode("016"),
            FQCountryISOCode("020"),
            FQCountryISOCode("024"),
            FQCountryISOCode("660"),
            FQCountryISOCode("028"),
            FQCountryISOCode("032"),
            FQCountryISOCode("051"),
            FQCountryISOCode("533"),
            FQCountryISOCode("036"),
            FQCountryISOCode("040"),
            FQCountryISOCode("031"),
            FQCountryISOCode("044"),
            FQCountryISOCode("048"),
            FQCountryISOCode("050"),
            FQCountryISOCode("052"),
            FQCountryISOCode("112"),
            FQCountryISOCode("056"),
            FQCountryISOCode("084"),
            FQCountryISOCode("204"),
            FQCountryISOCode("060"),
            FQCountryISOCode("064"),
            FQCountryISOCode("068"),
            FQCountryISOCode("535"),
            FQCountryISOCode("070"),
            FQCountryISOCode("072"),
            FQCountryISOCode("074"),
            FQCountryISOCode("076"),
            FQCountryISOCode("086"),
            FQCountryISOCode("096"),
            FQCountryISOCode("100"),
            FQCountryISOCode("854"),
            FQCountryISOCode("108"),
            FQCountryISOCode("132"),
            FQCountryISOCode("116"),
            FQCountryISOCode("120"),
            FQCountryISOCode("124"),
            FQCountryISOCode("136"),
            FQCountryISOCode("140"),
            FQCountryISOCode("148"),
            FQCountryISOCode("152"),
            FQCountryISOCode("156"),
            FQCountryISOCode("162"),
            FQCountryISOCode("166"),
            FQCountryISOCode("170"),
            FQCountryISOCode("174"),
            FQCountryISOCode("178"),
            FQCountryISOCode("180"),
            FQCountryISOCode("184"),
            FQCountryISOCode("188"),
            FQCountryISOCode("384"),
            FQCountryISOCode("191"),
            FQCountryISOCode("192"),
            FQCountryISOCode("531"),
            FQCountryISOCode("196"),
            FQCountryISOCode("203"),
            FQCountryISOCode("208"),
            FQCountryISOCode("262"),
            FQCountryISOCode("212"),
            FQCountryISOCode("214"),
            FQCountryISOCode("218"),
            FQCountryISOCode("818"),
            FQCountryISOCode("222"),
            FQCountryISOCode("226"),
            FQCountryISOCode("232"),
            FQCountryISOCode("233"),
            FQCountryISOCode("748"),
            FQCountryISOCode("231"),
            FQCountryISOCode("238"),
            FQCountryISOCode("234"),
            FQCountryISOCode("242"),
            FQCountryISOCode("246"),
            FQCountryISOCode("250"),
            FQCountryISOCode("254"),
            FQCountryISOCode("258"),
            FQCountryISOCode("260"),
            FQCountryISOCode("266"),
            FQCountryISOCode("270"),
            FQCountryISOCode("268"),
            FQCountryISOCode("276"),
            FQCountryISOCode("288"),
            FQCountryISOCode("292"),
            FQCountryISOCode("300"),
            FQCountryISOCode("304"),
            FQCountryISOCode("308"),
            FQCountryISOCode("312"),
            FQCountryISOCode("316"),
            FQCountryISOCode("320"),
            FQCountryISOCode("831"),
            FQCountryISOCode("324"),
            FQCountryISOCode("624"),
            FQCountryISOCode("328"),
            FQCountryISOCode("332"),
            FQCountryISOCode("334"),
            FQCountryISOCode("336"),
            FQCountryISOCode("340"),
            FQCountryISOCode("344"),
            FQCountryISOCode("348"),
            FQCountryISOCode("352"),
            FQCountryISOCode("356"),
            FQCountryISOCode("360"),
            FQCountryISOCode("364"),
            FQCountryISOCode("368"),
            FQCountryISOCode("372"),
            FQCountryISOCode("833"),
            FQCountryISOCode("376"),
            FQCountryISOCode("380"),
            FQCountryISOCode("388"),
            FQCountryISOCode("392"),
            FQCountryISOCode("832"),
            FQCountryISOCode("400"),
            FQCountryISOCode("398"),
            FQCountryISOCode("404"),
            FQCountryISOCode("296"),
            FQCountryISOCode("408"),
            FQCountryISOCode("410"),
            FQCountryISOCode("414"),
            FQCountryISOCode("417"),
            FQCountryISOCode("418"),
            FQCountryISOCode("428"),
            FQCountryISOCode("422"),
            FQCountryISOCode("426"),
            FQCountryISOCode("430"),
            FQCountryISOCode("434"),
            FQCountryISOCode("438"),
            FQCountryISOCode("440"),
            FQCountryISOCode("442"),
            FQCountryISOCode("446"),
            FQCountryISOCode("450"),
            FQCountryISOCode("454"),
            FQCountryISOCode("458"),
            FQCountryISOCode("462"),
            FQCountryISOCode("466"),
            FQCountryISOCode("470"),
            FQCountryISOCode("584"),
            FQCountryISOCode("474"),
            FQCountryISOCode("478"),
            FQCountryISOCode("480"),
            FQCountryISOCode("175"),
            FQCountryISOCode("484"),
            FQCountryISOCode("583"),
            FQCountryISOCode("498"),
            FQCountryISOCode("492"),
            FQCountryISOCode("496"),
            FQCountryISOCode("499"),
            FQCountryISOCode("500"),
            FQCountryISOCode("504"),
            FQCountryISOCode("508"),
            FQCountryISOCode("104"),
            FQCountryISOCode("516"),
            FQCountryISOCode("520"),
            FQCountryISOCode("524"),
            FQCountryISOCode("528"),
            FQCountryISOCode("540"),
            FQCountryISOCode("554"),
            FQCountryISOCode("558"),
            FQCountryISOCode("562"),
            FQCountryISOCode("566"),
            FQCountryISOCode("570"),
            FQCountryISOCode("574"),
            FQCountryISOCode("807"),
            FQCountryISOCode("580"),
            FQCountryISOCode("578"),
            FQCountryISOCode("512"),
            FQCountryISOCode("586"),
            FQCountryISOCode("585"),
            FQCountryISOCode("275"),
            FQCountryISOCode("591"),
            FQCountryISOCode("598"),
            FQCountryISOCode("600"),
            FQCountryISOCode("604"),
            FQCountryISOCode("608"),
            FQCountryISOCode("612"),
            FQCountryISOCode("616"),
            FQCountryISOCode("620"),
            FQCountryISOCode("630"),
            FQCountryISOCode("634"),
            FQCountryISOCode("638"),
            FQCountryISOCode("642"),
            FQCountryISOCode("643"),
            FQCountryISOCode("646"),
            FQCountryISOCode("652"),
            FQCountryISOCode("654"),
            FQCountryISOCode("659"),
            FQCountryISOCode("662"),
            FQCountryISOCode("663"),
            FQCountryISOCode("666"),
            FQCountryISOCode("670"),
            FQCountryISOCode("882"),
            FQCountryISOCode("674"),
            FQCountryISOCode("678"),
            FQCountryISOCode("682"),
            FQCountryISOCode("686"),
            FQCountryISOCode("688"),
            FQCountryISOCode("690"),
            FQCountryISOCode("694"),
            FQCountryISOCode("702"),
            FQCountryISOCode("534"),
            FQCountryISOCode("703"),
            FQCountryISOCode("705"),
            FQCountryISOCode("090"),
            FQCountryISOCode("706"),
            FQCountryISOCode("710"),
            FQCountryISOCode("239"),
            FQCountryISOCode("728"),
            FQCountryISOCode("724"),
            FQCountryISOCode("144"),
            FQCountryISOCode("729"),
            FQCountryISOCode("740"),
            FQCountryISOCode("744"),
            FQCountryISOCode("752"),
            FQCountryISOCode("756"),
            FQCountryISOCode("760"),
            FQCountryISOCode("158"),
            FQCountryISOCode("762"),
            FQCountryISOCode("834"),
            FQCountryISOCode("764"),
            FQCountryISOCode("626"),
            FQCountryISOCode("768"),
            FQCountryISOCode("772"),
            FQCountryISOCode("776"),
            FQCountryISOCode("780"),
            FQCountryISOCode("788"),
            FQCountryISOCode("792"),
            FQCountryISOCode("795"),
            FQCountryISOCode("796"),
            FQCountryISOCode("798"),
            FQCountryISOCode("800"),
            FQCountryISOCode("804"),
            FQCountryISOCode("784"),
            FQCountryISOCode("826"),
            FQCountryISOCode("581"),
            FQCountryISOCode("840"),
            FQCountryISOCode("858"),
            FQCountryISOCode("860"),
            FQCountryISOCode("548"),
            FQCountryISOCode("862"),
            FQCountryISOCode("704"),
            FQCountryISOCode("092"),
            FQCountryISOCode("850"),
            FQCountryISOCode("876"),
            FQCountryISOCode("732"),
            FQCountryISOCode("887"),
            FQCountryISOCode("894"),
            FQCountryISOCode("716"),
    ]
}


