//
//  ATTDescriptionView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/16/24.
//

import SwiftUI
import AppTrackingTransparency

struct ATTDescriptionView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @AppStorage(UserDefaultKey.ShowOnboarding) private var showOnBoarding: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
    
            Text("지구리가 서비스 활동정보를 사용하도록 허용하시겠습니까?")
                .font(.title.bold())
                .padding(.top, 64)
                .padding(.bottom, 16)
        
            
            Text("아래 계속하기 버튼을 누르면 나오게 되는 알람에서")
                .padding(.bottom, 8)
            
            Text("허용하시면")
                .font(.headline)
                .background(.background)
                .padding(.leading)
                .offset(y: 10)
                .zIndex(1)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("앱 내에서 맞춤화된 광고를 표시합니다.")
                
                Text("지구리 서비스를 계속해서 무료로 제공하는데 도움이 됩니다.")
                
                Text("광고를 통해 고객에게 도달하려는 비즈니스를 지원합니다.")
            }
            .padding(24)
            .font(.callout)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.fqAccent, lineWidth: 2.0)
            }
            
            Spacer()
            
            Button {
                requestAuthorization()
            } label: {
                Text("계속하기")
            }
            .buttonStyle(QuizFilledButtonStyle(disabled: false))
        }
        .padding()
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func requestAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { _ in
            DispatchQueue.main.async {
                navigationModel.toRoot()
                showOnBoarding = false
            }
        }
    }
}

#Preview {
    ATTDescriptionView()
        .environmentObject(NavigationModel())
}
