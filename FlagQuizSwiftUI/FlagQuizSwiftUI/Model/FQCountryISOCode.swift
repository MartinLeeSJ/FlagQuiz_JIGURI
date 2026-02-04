//
//  FQCountryISOCode.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import Foundation
import IsoCountryCodes

struct FQCountryISOCode: Codable {
    var cca3: String
    var numericCode: String?
    init(_ cca3: String) {
        self.cca3 = cca3
        self.numericCode = IsoCountryCodes.find(key: cca3)?.numeric
    }
    
    init?(numeric: String) {
        guard let alpha3 = IsoCountryCodes.find(key: numeric)?.alpha3 else { return nil }
        self.cca3 = alpha3
        self.numericCode = numeric
    }
    
    init?(_ cca3: String?) {
        guard let cca3 else { return nil }
        self.cca3 = cca3
        self.numericCode = IsoCountryCodes.find(key: cca3)?.numeric
    }
    
    var localizedName: String? {
        
        if let alpha2 = IsoCountryCodes.find(key: cca3)?.alpha2 {
            return Locale.current.localizedString(forRegionCode: alpha2)
        }
        return nil
    }
    
    var flagEmoji: String? {
        IsoCountryCodes.find(key: cca3)?.flag
    }
    
}

extension FQCountryISOCode: Identifiable {
    var id: String { cca3}
}
extension FQCountryISOCode: Equatable { }

extension FQCountryISOCode: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(cca3)
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
        FQCountryISOCode("TUN"),
        FQCountryISOCode("AND"),
        FQCountryISOCode("VNM"),
        FQCountryISOCode("ECU"),
        FQCountryISOCode("PRI"),
        FQCountryISOCode("USA"),
        FQCountryISOCode("SGS"),
        FQCountryISOCode("ISR"),
        FQCountryISOCode("GBR"),
        FQCountryISOCode("VGB"),
        FQCountryISOCode("MMR"),
        FQCountryISOCode("POL"),
        FQCountryISOCode("TCA"),
        FQCountryISOCode("AFG"),
        FQCountryISOCode("GLP"),
        FQCountryISOCode("KEN"),
        FQCountryISOCode("ASM"),
        FQCountryISOCode("AGO"),
        FQCountryISOCode("BTN"),
        FQCountryISOCode("MLT"),
        FQCountryISOCode("JEY"),
        FQCountryISOCode("RUS"),
        FQCountryISOCode("NPL"),
        FQCountryISOCode("GNB"),
        FQCountryISOCode("IRQ"),
        FQCountryISOCode("SDN"),
        FQCountryISOCode("PYF"),
        FQCountryISOCode("DJI"),
        FQCountryISOCode("MOZ"),
        FQCountryISOCode("VIR"),
        FQCountryISOCode("ABW"),
        FQCountryISOCode("SHN"),
        FQCountryISOCode("ZAF"),
        FQCountryISOCode("LIE"),
        FQCountryISOCode("STP"),
        FQCountryISOCode("BDI"),
        FQCountryISOCode("RWA"),
        FQCountryISOCode("BEL"),
        FQCountryISOCode("GUM"),
        FQCountryISOCode("JOR"),
        FQCountryISOCode("MNP"),
        FQCountryISOCode("GNQ"),
        FQCountryISOCode("MHL"),
        FQCountryISOCode("NIU"),
        FQCountryISOCode("ESP"),
        FQCountryISOCode("KGZ"),
        FQCountryISOCode("BVT"),
        FQCountryISOCode("MRT"),
        FQCountryISOCode("WSM"),
        FQCountryISOCode("MWI"),
        FQCountryISOCode("PAN"),
        FQCountryISOCode("THA"),
        FQCountryISOCode("TUR"),
        FQCountryISOCode("PHL"),
        FQCountryISOCode("PCN"),
        FQCountryISOCode("SVN"),
        FQCountryISOCode("ARE"),
        FQCountryISOCode("GEO"),
        FQCountryISOCode("GRC"),
        FQCountryISOCode("ARM"),
        FQCountryISOCode("CCK"),
        FQCountryISOCode("CRI"),
        FQCountryISOCode("KIR"),
        FQCountryISOCode("TZA"),
        FQCountryISOCode("SSD"),
        FQCountryISOCode("IRN"),
        FQCountryISOCode("FSM"),
        FQCountryISOCode("SJM"),
        FQCountryISOCode("MNG"),
        FQCountryISOCode("MDA"),
        FQCountryISOCode("NZL"),
        FQCountryISOCode("SWZ"),
        FQCountryISOCode("SOM"),
        FQCountryISOCode("LCA"),
        FQCountryISOCode("GUY"),
        FQCountryISOCode("IMN"),
        FQCountryISOCode("FRO"),
        FQCountryISOCode("BLM"),
        FQCountryISOCode("WLF"),
        FQCountryISOCode("IND"),
        FQCountryISOCode("NER"),
        FQCountryISOCode("SXM"),
        FQCountryISOCode("COD"),
        FQCountryISOCode("COG"),
        FQCountryISOCode("KOR"),
        FQCountryISOCode("CIV"),
        FQCountryISOCode("MDV"),
        FQCountryISOCode("SRB"),
        FQCountryISOCode("MLI"),
        FQCountryISOCode("DZA"),
        FQCountryISOCode("LAO"),
        FQCountryISOCode("CMR"),
        FQCountryISOCode("FIN"),
        FQCountryISOCode("ZWE"),
        FQCountryISOCode("MSR"),
        FQCountryISOCode("BOL"),
        FQCountryISOCode("LSO"),
        FQCountryISOCode("HUN"),
        FQCountryISOCode("TKM"),
        FQCountryISOCode("NOR"),
        FQCountryISOCode("PER"),
        FQCountryISOCode("CUB"),
        FQCountryISOCode("LTU"),
        FQCountryISOCode("KNA"),
        FQCountryISOCode("GGY"),
        FQCountryISOCode("MUS"),
        FQCountryISOCode("SAU"),
        FQCountryISOCode("CUW"),
        FQCountryISOCode("BEN"),
        FQCountryISOCode("SVK"),
        FQCountryISOCode("IOT"),
        FQCountryISOCode("TUV"),
        FQCountryISOCode("GRL"),
        FQCountryISOCode("CPV"),
        FQCountryISOCode("UZB"),
        FQCountryISOCode("SWE"),
        FQCountryISOCode("BGD"),
        FQCountryISOCode("TWN"),
        FQCountryISOCode("ITA"),
        FQCountryISOCode("TCD"),
        FQCountryISOCode("SYR"),
        FQCountryISOCode("CHL"),
        FQCountryISOCode("SEN"),
        FQCountryISOCode("BFA"),
        FQCountryISOCode("ROU"),
        FQCountryISOCode("BRA"),
        FQCountryISOCode("MYT"),
        FQCountryISOCode("DMA"),
        FQCountryISOCode("EST"),
        FQCountryISOCode("TGO"),
        FQCountryISOCode("KHM"),
        FQCountryISOCode("DOM"),
        FQCountryISOCode("NFK"),
        FQCountryISOCode("CAN"),
        FQCountryISOCode("ATF"),
        FQCountryISOCode("PRY"),
        FQCountryISOCode("KAZ"),
        FQCountryISOCode("IDN"),
        FQCountryISOCode("LUX"),
        FQCountryISOCode("ESH"),
        FQCountryISOCode("COM"),
        FQCountryISOCode("ATG"),
        FQCountryISOCode("BGR"),
        FQCountryISOCode("FLK"),
        FQCountryISOCode("HND"),
        FQCountryISOCode("URY"),
        FQCountryISOCode("SPM"),
        FQCountryISOCode("ETH"),
        FQCountryISOCode("TJK"),
        FQCountryISOCode("TKL"),
        FQCountryISOCode("BWA"),
        FQCountryISOCode("ALB"),
        FQCountryISOCode("NGA"),
        FQCountryISOCode("GMB"),
        FQCountryISOCode("CYP"),
        FQCountryISOCode("BES"),
        FQCountryISOCode("VUT"),
        FQCountryISOCode("PRT"),
        FQCountryISOCode("CHN"),
        FQCountryISOCode("SGP"),
        FQCountryISOCode("DNK"),
        FQCountryISOCode("GHA"),
        FQCountryISOCode("VCT"),
        FQCountryISOCode("MAF"),
        FQCountryISOCode("LBR"),
        FQCountryISOCode("HKG"),
        FQCountryISOCode("GTM"),
        FQCountryISOCode("SLE"),
        FQCountryISOCode("MCO"),
        FQCountryISOCode("LBN"),
        FQCountryISOCode("SYC"),
        FQCountryISOCode("ZMB"),
        FQCountryISOCode("VEN"),
        FQCountryISOCode("SUR"),
        FQCountryISOCode("REU"),
        FQCountryISOCode("UKR"),
        FQCountryISOCode("LVA"),
        FQCountryISOCode("DEU"),
        FQCountryISOCode("ERI"),
        FQCountryISOCode("HRV"),
        FQCountryISOCode("PNG"),
        FQCountryISOCode("PLW"),
        FQCountryISOCode("BIH"),
        FQCountryISOCode("MNE"),
        FQCountryISOCode("LBY"),
        FQCountryISOCode("QAT"),
        FQCountryISOCode("PAK"),
        FQCountryISOCode("PRK"),
        FQCountryISOCode("SMR"),
        FQCountryISOCode("GIN"),
        FQCountryISOCode("AIA"),
        FQCountryISOCode("BRN"),
        FQCountryISOCode("MDG"),
        FQCountryISOCode("AZE"),
        FQCountryISOCode("PSE"),
        FQCountryISOCode("CAF"),
        FQCountryISOCode("GRD"),
        FQCountryISOCode("BHR"),
        FQCountryISOCode("AUT"),
        FQCountryISOCode("FRA"),
        FQCountryISOCode("GIB"),
        FQCountryISOCode("SLV"),
        FQCountryISOCode("MKD"),
        FQCountryISOCode("GUF"),
        FQCountryISOCode("NAM"),
        FQCountryISOCode("AUS"),
        FQCountryISOCode("MAR"),
        FQCountryISOCode("IRL"),
        FQCountryISOCode("BMU"),
        FQCountryISOCode("NIC"),
        FQCountryISOCode("ALA"),
        FQCountryISOCode("BHS"),
        FQCountryISOCode("OMN"),
        FQCountryISOCode("CHE"),
        FQCountryISOCode("CZE"),
        FQCountryISOCode("ISL"),
        FQCountryISOCode("JPN"),
        FQCountryISOCode("NLD"),
        FQCountryISOCode("BLZ"),
        FQCountryISOCode("BRB"),
        FQCountryISOCode("BLR"),
        FQCountryISOCode("TLS"),
        FQCountryISOCode("UGA"),
        FQCountryISOCode("YEM"),
        FQCountryISOCode("MTQ"),
        FQCountryISOCode("HTI"),
        FQCountryISOCode("ARG"),
        FQCountryISOCode("EGY"),
        FQCountryISOCode("KWT"),
        FQCountryISOCode("CYM"),
        FQCountryISOCode("COK"),
        FQCountryISOCode("ATA"),
        FQCountryISOCode("GAB"),
        FQCountryISOCode("LKA"),
        FQCountryISOCode("TTO"),
        FQCountryISOCode("COL"),
        FQCountryISOCode("VAT"),
        FQCountryISOCode("CXR"),
        FQCountryISOCode("HMD"),
        FQCountryISOCode("MAC"),
        FQCountryISOCode("MEX"),
        FQCountryISOCode("NCL"),
        FQCountryISOCode("SLB"),
        FQCountryISOCode("UNK"),
        FQCountryISOCode("NRU"),
        FQCountryISOCode("TON"),
        FQCountryISOCode("MYS"),
        FQCountryISOCode("FJI"),
        FQCountryISOCode("JAM"),
        FQCountryISOCode("UMI")
    ]
}
