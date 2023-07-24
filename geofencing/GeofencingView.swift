//
//  GeofencingView.swift
//  Docs-Examples
//
//  Created by Max Cobb on 03/04/2023.
//

import SwiftUI
import AgoraRtcKit

class GeofencingManager: AgoraManager {
    let geoRegions: RegionsType
    init(appId: String, role: AgoraClientRole = .audience, geoRegions: RegionsType) {
        self.geoRegions = geoRegions
        super.init(appId: appId, role: role)
    }
    enum RegionsType: Hashable {
        case absolute(AgoraAreaCodeType)
        case inclusive([AgoraAreaCodeType])
        case exclusive([AgoraAreaCodeType])
    }
    override func setupEngine() -> AgoraRtcEngineKit {
        let engineConfig = AgoraRtcEngineConfig()
        var combinedAreaCode: AgoraAreaCodeType!
        switch geoRegions {
        case .absolute(let region):
            combinedAreaCode = region
        case .inclusive(let regions):
            combinedAreaCode = AgoraAreaCodeType(rawValue: regions.reduce(0, { $0 | $1.rawValue }))!
        case .exclusive(let regions):
            combinedAreaCode = AgoraAreaCodeType(
                rawValue: AgoraAreaCodeType.global.rawValue ^ regions.reduce(0, { $0 | $1.rawValue })
            )!
        }
        engineConfig.areaCode = combinedAreaCode
        let eng = AgoraRtcEngineKit.sharedEngine(with: engineConfig, delegate: self)
        eng.enableVideo()
        eng.setClientRole(role)
        return eng
    }
}

/// A view that authenticates the user with a token and joins them to a channel using Agora SDK.
struct GeofencingView: View {
    /// The Agora SDK manager.
    @ObservedObject var agoraManager: GeofencingManager

    /// Initializes a new ``GeofencingView``.
    ///
    /// - Parameters:
    ///   - channelId: The channel ID to join.
    public init(channelId: String, regions: GeofencingManager.RegionsType) {
        DocsAppConfig.shared.channel = channelId
        agoraManager = GeofencingManager(
            appId: DocsAppConfig.shared.appId,
            role: .broadcaster,
            geoRegions: regions
        )
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ForEach(Array(agoraManager.allUsers), id: \.self) { uid in
                        AgoraVideoCanvasView(manager: agoraManager, uid: uid)
                            .aspectRatio(contentMode: .fit).cornerRadius(10)
                    }
                }.padding(20)
            }
        }.onAppear { await agoraManager.joinChannel(DocsAppConfig.shared.channel)
        }.onDisappear { agoraManager.leaveChannel() }
    }
}

struct GeofencingView_Previews: PreviewProvider {
    static var previews: some View {
        GeofencingView(channelId: "test", regions: .absolute(.global))
    }
}
