//
//  ClosetItemTypeButtons.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/1/24.
//

import SwiftUI

struct ClosetItemTypeButtons: View {
    @EnvironmentObject private var closetViewModel: ClosetViewModel
    @Namespace private var closetSelectedType
    
    
    var body: some View {
        ScrollView(.horizontal) {
            
            HStack(spacing: 12) {
                Spacer()
                    .frame(width: 16)
                
                ForEach(FQItemType.allCases, id: \.self) { type in
                    Button {
                        closetViewModel.send(.selectType(type))
                    } label: {
                        Text(type.localizedName)
                            .foregroundStyle(.foreground)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom, 8)
                    .padding(.horizontal, 14)
                    .overlay {
                        if closetViewModel.selectedType == type {
                            Line(.bottom)
                                .stroke(.fqAccent, lineWidth: 2)
                                .matchedGeometryEffect(id: "highlight", in: closetSelectedType)
                        }
                    }
                    .animation(.spring, value: closetViewModel.selectedType)
                }
                
                Spacer()
                    .frame(width: 16)
            }
        }
        .scrollIndicators(.never)
            
        
    }
}

