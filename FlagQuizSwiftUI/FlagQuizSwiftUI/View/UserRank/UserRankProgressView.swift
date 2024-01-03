//
//  UserRankProgressView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/2/24.
//

import SwiftUI

struct UserRankProgressView: View {
    private let min: Double
    private let minValueText: String
    private let max: Double
    private let maxValueText: String
    private let currentValue: Double
    private let currentValueText: String
    
    init(
        min: Double,
        minValueText: String,
        max: Double,
        maxValueText: String,
        currentValue: Double,
        currentValueText: String
    ) {
        self.min = min
        self.minValueText = minValueText
        self.max = max
        self.maxValueText = maxValueText
        self.currentValue = currentValue
        self.currentValueText = currentValueText
    }
   
    
    private var total: Double {
        max - min
    }
    
    private var adjustedValue: Double {
        let value: Double = currentValue - min
        return value <= total ? value : total
    }
    
    
    var body: some View {
        ProgressView(
            value: adjustedValue,
            total: total
        ) {
            label
        } 
        .frame(maxHeight: 90)
        .padding([.horizontal, .bottom])
        .background(in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .backgroundStyle(.thinMaterial)
        .overlay(alignment: .top) {
            Text(currentValueText)
                .font(.title3)
                .fontWeight(.medium)
                .padding(.top, 8)
        }
    }
    
    private var label: some View {
        VStack {
            Spacer()
            HStack {
                Text(minValueText)
                Spacer()
                Text(maxValueText)
            }
        }
        .font(.caption2)
        .fontWeight(.medium)
        .frame(height: 55)
    }
    
  
}


