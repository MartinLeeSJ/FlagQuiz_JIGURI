//
//  ATTDescriptionView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/16/24.
//

import SwiftUI
import AppTrackingTransparency

struct ATTDescriptionView: View {
    @EnvironmentObject private var container: DIContainer
    @AppStorage(UserDefaultKey.ShowOnboarding) private var showOnBoarding: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(
                String(
                    localized: "attDescriptionView.title",
                    defaultValue: "Would you allow 'FlagFrog' to use service activity information?"
                )
                
            )
            .font(.title.bold())
            .padding(.top, 64)
            .padding(.bottom, 16)
            
            
            Text(
                String(
                    localized: "attDescriptionView.instruction.there.will.be.alert",
                    defaultValue: "In the alert that appears when you press the 'Continue' button below"
                )
            )
            .padding(.bottom, 8)
            
            Text(
                String(
                    localized: "attDescriptionView.instruction.if.you.allow",
                    defaultValue: "IF YOU ALLOW"
                )
            )
            .font(.headline)
            .background(.background)
            .padding(.leading)
            .offset(y: 10)
            .zIndex(1)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(
                    String(
                        localized: "attDescriptionView.instruction.personalized",
                        defaultValue: "Displays personalized ads within the app."
                    )
                )
                
                Text(
                    String(
                        localized: "attDescriptionView.instruction.support.developer",
                        defaultValue: "It helps us continue to offer \"FlagFrog\" services for free."
                    )
                )
                
                Text(
                    String(
                        localized: "attDescriptionView.instruction.support.business",
                        defaultValue: "Support businesses that want to reach customers through advertising"
                    )
                )
            }
            .padding(24)
            .font(.callout)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.fqAccent, lineWidth: 2.0)
            }
            
            Spacer()
            
            Button {
                requestTrackingAuthorization()
            } label: {
                Text(
                    String(
                        localized: "attDescriptionView.continue",
                        defaultValue: "Continue"
                    )
                )
            }
            .buttonStyle(FQFilledButtonStyle(disabled: false))
        }
        .padding()
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { _ in
                DispatchQueue.main.async {
                    container.navigationModel.toRoot()
                    showOnBoarding = false
                }
        }
    }
}

#Preview {
    ATTDescriptionView()
        .environmentObject(DIContainer(services: StubService()))
}
