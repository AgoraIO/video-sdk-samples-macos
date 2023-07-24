//
//  StreamMediaView.swift
//  Docs-Examples
//
//  Created by Max Cobb on 24/07/2023.
//

import SwiftUI
import AgoraRtcKit

public class StreamMediaManager: AgoraManager, AgoraRtcMediaPlayerDelegate {
    var mediaPlayer: AgoraRtcMediaPlayerProtocol?
    /// Starts streaming a video from a URL
    /// - Parameter url: Source URL of the media file. Could be local or remote.
    ///
    /// This method is picked up later by ``StreamMediaManager/AgoraRtcMzediaPlayer(_:didChangedTo:error:)``
    func startStreaming(from url: URL) {
        // Create an instance of the media player
        mediaPlayer = agoraEngine.createMediaPlayer(with: self)
        // Open the media file
        mediaPlayer!.open(url.absoluteString, startPos: 0)
        label = "Opening Media File..."
    }

    /// Update the AgoraRtcChannelMediaOptions to control the media player publishing behavior.
    ///
    /// - Parameter publishMediaPlayer: A boolean value indicating whether the media player should be published or not.
    func updateChannelPublishOptions(_ publishMediaPlayer: Bool) {
        let channelOptions: AgoraRtcChannelMediaOptions = AgoraRtcChannelMediaOptions()

        // Set the options based on the `publishMediaPlayer` flag
        channelOptions.publishMediaPlayerAudioTrack = publishMediaPlayer
        channelOptions.publishMediaPlayerVideoTrack = publishMediaPlayer
        channelOptions.publishMicrophoneTrack = true
        channelOptions.publishCameraTrack = !publishMediaPlayer

        // If publishing media player, set the media player ID
        if publishMediaPlayer { channelOptions.publishMediaPlayerId = Int(mediaPlayer!.getMediaPlayerId()) }

        // Update the AgoraRtcChannel with the new media options
        agoraEngine.updateChannel(with: channelOptions)
    }

    // swiftlint:disable identifier_name
    /// This method is called when the AgoraRtcMediaPlayer changes its state.
    /// - Parameters:
    ///   - playerKit: The AgoraRtcMediaPlayerProtocol that triggered the state change.
    ///   - state: The new state of the media player.
    ///   - error: An optional error indicating the reason for the state change.
    public func AgoraRtcMediaPlayer(
        _ playerKit: AgoraRtcMediaPlayerProtocol,
        didChangedTo state: AgoraMediaPlayerState,
        error: AgoraMediaPlayerError
    ) {
        switch state {
        case .openCompleted:
            // Media file opened successfully
            // Update the UI, and start playing
            DispatchQueue.main.async {[weak self] in
                guard let self else { return }
                self.mediaDuration = self.mediaPlayer!.getDuration()
                self.updateChannelPublishOptions(true)
                self.label = "Playback started"
                self.mediaPlayer?.play()
                mediaPlaying = true
            }
        case .playBackAllLoopsCompleted:
            // Media file finished playing
            DispatchQueue.main.async {[weak self] in
                self?.mediaPlaying = false
                self?.label = "Playback finished"
                self?.updateChannelPublishOptions(false)
            }
            // Clean up
            agoraEngine.destroyMediaPlayer(mediaPlayer)
            mediaPlayer = nil
        default: break
        }
    }

    /// This method is called when the AgoraRtcMediaPlayer updates the playback position.
    /// - Parameters:
    ///   - playerKit: The AgoraRtcMediaPlayerProtocol that triggered the position change.
    ///   - position: The new position in the media file (in milliseconds).
    public func AgoraRtcMediaPlayer(_ playerKit: AgoraRtcMediaPlayerProtocol, didChangedTo position: Int) {
        if mediaDuration > 0 {
            let result = (Float(position) / Float(mediaDuration))
            DispatchQueue.main.async { [weak self] in
                guard let weakself = self else { return }
                weakself.label = "Playback progress: \(Int(result * 100))%"
            }
        }
    }
    // swiftlint:enable identifier_name

    @Published var label: String?
    @Published var mediaPlaying: Bool = false
    @Published var mediaDuration: Int = 0
    @Published var playerButtonText = "Open Media File"
}

/// A view that displays the video feeds of all participants in a channel.
public struct StreamMediaView: View {
    @ObservedObject public var agoraManager = StreamMediaManager(appId: DocsAppConfig.shared.appId, role: .broadcaster)

    public var body: some View {
        ZStack {
            // Show a scrollable view of video feeds for all participants.
            ScrollView {
                VStack {
                    if agoraManager.mediaPlaying, let mediaPlayer = agoraManager.mediaPlayer {
                        AgoraVideoCanvasView(
                            manager: agoraManager, canvasIdType: .mediaSource(
                                .mediaPlayer, mediaPlayerId: mediaPlayer.getMediaPlayerId()
                            )
                        ).aspectRatio(contentMode: .fit).cornerRadius(10)
                    }
                    // Show the video feeds for each participant.
                    ForEach(Array(agoraManager.allUsers), id: \.self) { uid in
                        AgoraVideoCanvasView(manager: agoraManager, uid: uid)
                            .aspectRatio(contentMode: .fit).cornerRadius(10)
                    }
                }.padding(20)
            }
            VStack {
                Text(agoraManager.label ?? "").padding(4)
                    .background {
                        #if os(iOS)
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .cornerRadius(5).blur(radius: 1).opacity(0.75)
                        #else
                        Color.secondary
                            .cornerRadius(5).blur(radius: 1).opacity(0.75)
                        #endif
                    }.padding(4)
                Spacer()
            }
        }.onAppear {
            await agoraManager.joinChannel(DocsAppConfig.shared.channel)
            agoraManager.startStreaming(from: streamURL)
        }.onDisappear {
            agoraManager.leaveChannel()
        }
    }

    var streamURL: URL
    init(channelId: String, url: URL) {
        DocsAppConfig.shared.channel = channelId
        streamURL = url
    }
}

struct StreamMediaView_Previews: PreviewProvider {
    static var previews: some View {
        StreamMediaView(channelId: "test", url: URL(string: "")!)
    }
}
