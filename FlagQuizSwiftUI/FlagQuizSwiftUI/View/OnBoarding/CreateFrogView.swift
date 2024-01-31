//
//  CreateFrogView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/15/24.
//

import SwiftUI
import Combine
import AppTrackingTransparency

struct CreateFrogView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @StateObject private var viewModel: CreateFrogViewModel
    @AppStorage(UserDefaultKey.ShowOnboarding) private var showOnBoarding: Bool = true
    
    init(viewModel: CreateFrogViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            if height > width {
                VStack {
                    talkingFrog
                    
                    searchACountryView(isPortrait: true)
                    
                    
                    chooseCountryButton
                }
                .padding()
                .background(Color.fqAccent)
                .background(ignoresSafeAreaEdges: .all)
            } else {
                HStack(spacing: 32) {
                    talkingFrog
                    VStack {
                        searchACountryView(isPortrait: false)
                        
                        chooseCountryButton
                    }
                }
                .padding(.vertical)
                .background(Color.fqAccent)
                .background(ignoresSafeAreaEdges: .all)
            }
        }
    }
    
    
    
    @ViewBuilder
    var talkingFrog: some View {
        VStack {
            Spacer()
            
            Image("frogHeadBig")
                .resizable()
                .scaledToFit()
                .frame(width: 180)
            
            Image("LetterBoxCenter")
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottom) {
                    Text("createFrogView.what.is.frogs.country")
                        .font(.custom(FontName.pixel, size: 20))
                        .foregroundStyle(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .offset(y: -24)
                }
            
            Spacer()
        }
    }
    
    func searchACountryView(isPortrait: Bool) -> some View {
        VStack(spacing: 16) {
            chosenCountry
            
            countryList
            
            searchOrChooseRandomCountry(isPortrait: isPortrait)

        }
        .padding()
        .frame(minHeight: isPortrait ? 385 : nil, maxHeight: 390)
        .background(in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    
    @ViewBuilder
    var chooseCountryButton: some View {
        Text("createFrogView.you.can.change.after.using.points")
            .foregroundStyle(.black)
            .font(.caption2)
            .fontWeight(.medium)
            
        Button {
            viewModel.submitCountry()
        } label: {
            Text("createFrogView.select.country.button.title")
        }
        .buttonStyle(
            FQFilledButtonStyle(
                disabled: viewModel.selectedCode == nil,
                isLightModeOnly: true
            )
        )
        .onChange(of: viewModel.didCreateFrog) { didCreate in
            guard didCreate else { return }
            
            if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                navigationModel.navigate(to: OnBoardingDestination.attDescription)
            } else {
                navigationModel.toRoot()
                showOnBoarding = false
            }
            
        }
    }
    
    @ViewBuilder
    var chosenCountry: some View {
        HStack {
            if let selectedCode = viewModel.selectedCode {
                
                Text(selectedCode.flagEmoji ?? "")
                
                Text(selectedCode.localizedName ?? "")
                
                
            } else {
                Text("createFrogView.select.country.below.list")
              
            }
        }
        .font(.subheadline)
        .lineLimit(1)
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(
            .thinMaterial,
            in: RoundedRectangle(cornerRadius: 8, style: .continuous)
        )
        Text("createFrogView.select.country.whatever.your.country")
            .font(.caption2)
            .padding(.vertical, -12)
    }
    
    var countryList: some View {
        List {
            ForEach(viewModel.countryCodes, id: \.id) { code in
                Button {
                    viewModel.send(.selectCountry(code))
                } label: {
                    HStack {
                        Text(code.flagEmoji ?? "")
                            .font(.callout)
                        
                        Text(code.localizedName ?? "")
                            .font(.caption)
                        if let selectedCode = viewModel.selectedCode ,
                           selectedCode == code {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .border(.foreground.opacity(0.1))
    }
    
    @ViewBuilder
    func searchOrChooseRandomCountry(isPortrait: Bool) -> some View {
        if isPortrait {
            TextField("createFrogView.search.title", text: $viewModel.query)
                .font(.caption)
                .padding(8)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            Divider()
                .overlay {
                    Text("createFrogView.or")
                        .font(.caption)
                        .background(.background)
                }
                .padding(.vertical, 4)
        }
        
        Button {
            viewModel.send(.selectRandomCountry)
        } label: {
            Label("createFrogView.shuffle.button.title", systemImage: "shuffle")
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    
    CreateFrogView(
        viewModel: CreateFrogViewModel(
            container: .init(
                services: StubService()
            )
        )
    )
    .environmentObject(NavigationModel())
    
}
