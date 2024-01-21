//
//  InformationView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/13/24.
//

import SwiftUI

struct InformationView: View {
    private let pinnedInfo: FQInfo?
    private let infos: [FQInfo]
    
    init(pinnedInfo: FQInfo?, infos: [FQInfo]) {
        self.pinnedInfo = pinnedInfo
        self.infos = infos
    }
    
    var body: some View {
        List {
            if let pinnedInfo {
                Section {
                    InformationRow(info: pinnedInfo)
                }
            }
            
            Section {
                ForEach(infos, id: \.self) { info in
                    InformationRow(info: info)
                        .listRowBackground(Color.fqBg)
                }
            }
        }
        .listStyle(.grouped)
    }
}
