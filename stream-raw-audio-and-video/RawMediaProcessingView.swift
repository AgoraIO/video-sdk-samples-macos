//
//  RawMediaProcessingView.swift
//  Docs-Examples
//
//  Created by Max Cobb on 24/07/2023.
//

import SwiftUI
import AgoraRtcKit

public class MediaProcessingManager: AgoraManager, HasModifyVideo, HasModifyAudio {
    @Published var videoModification: VideoModification = .none
    @Published var audioModification: AudioModification = .none
    var videoFrameDelegate: ModifyVideoFrameDelegate?
    var audioFrameDelegate: ModifyAudioFrameDelegate?
    override init(appId: String, role: AgoraClientRole = .audience) {
        super.init(appId: appId, role: role)

        // Video Setup
        self.videoFrameDelegate = ModifyVideoFrameDelegate(modifyController: self)
        agoraEngine.setVideoFrameDelegate(videoFrameDelegate)

        // Audio Setup
        self.audioFrameDelegate = ModifyAudioFrameDelegate(modifyController: self)
        agoraEngine.setAudioFrameDelegate(audioFrameDelegate)
        agoraEngine.setRecordingAudioFrameParametersWithSampleRate(
            44100, channel: 1, mode: .readWrite, samplesPerCall: 4410
        )
        agoraEngine.setMixedAudioFrameParametersWithSampleRate(
            44100, channel: 1, samplesPerCall: 4410
        )
        agoraEngine.setPlaybackAudioFrameParametersWithSampleRate(
            44100, channel: 1, mode: .readWrite, samplesPerCall: 4410
        )
    }
}

internal enum VideoModification: String, CaseIterable {
    case none
    case zoom
    case comic
    case invert
    case mirrorVertical // upside down
}

internal enum AudioModification: String, CaseIterable {
    case none
    case louder
    case reverb
}

// MARK: - UI

/// A view that displays the video feeds of all participants in a channel.
public struct RawMediaProcessingView: View {
    @ObservedObject public var agoraManager = MediaProcessingManager(
        appId: DocsAppConfig.shared.appId, role: .broadcaster
    )

    public var body: some View {
        VStack {
            // Show a scrollable view of video feeds for all participants.
            ScrollView {
                VStack {
                    // Show the video feeds for each participant.
                    ForEach(Array(agoraManager.allUsers), id: \.self) { uid in
                        AgoraVideoCanvasView(manager: agoraManager, uid: uid)
                            .aspectRatio(contentMode: .fit).cornerRadius(10)
                    }
                }.padding(EdgeInsets(
                    top: 20, leading: 20, bottom: 5, trailing: 20
                ))
            }
            HStack {
                Image(systemName: "photo")
                Picker("Choose Video Modification", selection: $agoraManager.videoModification) {
                    ForEach([VideoModification.none, .comic, .invert, .zoom], id: \.rawValue) {
                        Text($0.rawValue).tag($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }.padding(.all.subtracting(.bottom))

            HStack {
                Image(systemName: "speaker.wave.3")
                Picker("Choose Audio Modification", selection: $agoraManager.audioModification) {
                    ForEach([AudioModification.none, .reverb, .louder], id: \.rawValue) { Text($0.rawValue).tag($0) }
                }.pickerStyle(SegmentedPickerStyle())
            }.padding()

        }.onAppear {
            agoraManager.agoraEngine.joinChannel(
                byToken: DocsAppConfig.shared.rtcToken,
                channelId: DocsAppConfig.shared.channel,
                info: nil, uid: DocsAppConfig.shared.uid
            )
        }.onDisappear {
            agoraManager.leaveChannel()
        }
    }

    init(channelId: String) {
        DocsAppConfig.shared.channel = channelId
    }
}

struct RawMediaProcessingView_Previews: PreviewProvider {
    static var previews: some View {
        RawMediaProcessingView(channelId: "test")
    }
}
