//
//  AgoraCustomVideoCanvasView.swift
//  Docs-Examples
//
//  Created by Max Cobb on 23/06/2023.
//

import SwiftUI
import AVKit
import AgoraRtcKit

/// SwiftUI representable for a ``CustomVideoSourcePreview``.
public struct AgoraCustomVideoCanvasView: NSViewRepresentable {
    /// The `AgoraRtcVideoCanvas` object that represents the video canvas for the view.
    @StateObject var canvas = CustomVideoSourcePreview()

    /// Preview layer where the camera frames come into
    var previewLayer: AVCaptureVideoPreviewLayer?

    /// Creates and configures a `NSView` for the view. This NSView will be the view the video is rendered onto.
    /// - Parameter context: The `NSViewRepresentable` context.
    /// - Returns: A `NSView` for displaying the custom local video stream.
    public func makeNSView(context: Context) -> NSView { setupCanvasView() }
    func setupCanvasView() -> NSView { canvas }

    /// Updates the `AgoraRtcVideoCanvas` object for the view with new values, if necessary.
    func updateCanvasValues() {
        if self.previewLayer != canvas.previewLayer, let previewLayer {
            canvas.insertCaptureVideoPreviewLayer(previewLayer: previewLayer)
        }
    }

    /// Updates the Canvas view.
    public func updateNSView(_ nsView: NSView, context: Context) {
        self.updateCanvasValues()
    }
}

/// View to show the custom camera feed for the local camera feed.
open class CustomVideoSourcePreview: NSView, ObservableObject {
    /// Layer that displays video from a camera device.
    open private(set) var previewLayer: AVCaptureVideoPreviewLayer?

    /// Add new frame to the preview layer
    /// - Parameter previewLayer: New `previewLayer` to be displayed on the preview.
    open func insertCaptureVideoPreviewLayer(previewLayer: AVCaptureVideoPreviewLayer) {
        self.previewLayer?.removeFromSuperlayer()
        previewLayer.frame = bounds
        self.wantsLayer = true
        layer!.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }

    /// Tells the delegate a layer's bounds have changed.
    /// - Parameter layer: The layer that requires layout of its sublayers.
    override open func layout() {
        super.layoutSubtreeIfNeeded()
        previewLayer?.frame = bounds
        if let connection = self.previewLayer?.connection {
            let previewLayerConnection: AVCaptureConnection = connection

            if previewLayerConnection.isVideoOrientationSupported {
                self.updatePreviewLayer(
                    layer: previewLayerConnection
                )
            }
        }
    }

    private func updatePreviewLayer(layer: AVCaptureConnection) {
        self.previewLayer?.frame = self.bounds
    }
}
