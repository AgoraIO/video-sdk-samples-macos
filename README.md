# Video SDK reference app (macOS)

This app demonstrates using Agora's Video SDK for real-time communication in a SwiftUI app.

This example app is a robust and comprehensive documentation reference app for macOS, designed to enhance your productivity and understanding. It's built to be flexible, easily extensible, and beginner-friendly.

To understand the contents better, you can go to [Agora's Documentation](https://docs.agora.io), which explains each example in more detail.

## Prerequisites

Before getting started with this example app, please ensure you have the following software installed on your machine:

- Xcode 13.0 or later.
- Swift 5.5 or later.
- A device running macOS 10.11 or later.

## Run the App

1. Clone the repository

To clone the repository to your local machine, open Terminal and navigate to the directory where you want to clone the repository. Then, use the following command:

    ```sh
    git clone https://github.com/AgoraIO/video-sdk-samples-macos.git
    ```

    If you are using a device using the ARM architecture (e.g. MacBook Air M1, M2) take the following additional steps:

        1. Download the latest jq binary for macOS from their [official website](https://jqlang.github.io/jq/download/) and save it on the `/Documents` folder.

        1. Open a terminal window and input the following command:

        ```bash
        sudo ln -s /Users/<your_macos_user_name>/Documents/<file_name_of_downloaded_jq> jq
        ```

        1. Restart your device for the changes to take effect.

2. Open the project

Navigate to [Example-App](Example-App), and open [Docs-Examples.xcodeproj](Example-App/Docs-Examples.xcodeproj).

> All dependencies are installed with Swift Package Manager, so will be fetched automatically by Xcode.

3. Update Signing

As with any Xcode project, head to the target, "Signing & Capabilities", and add your team, and modify the bundle identifier to make it unique.

4. Modify config.json

The file [config.json](agora-manager/config.json) is locaed in the [agora-manager](agora-manager) directory, and must have at least the following modifications made:

- appId: Update to your Agora Project ID, found at https://console.agora.io

You may also need to make these modifications:

- rtcToken: Add in your temporary token if you need and have generated one
- tokenUrl: Add the URL to your token server if you have one; there are a few one-click deployment options [here](https://github.com/AgoraIO-Community/agora-token-service).

5. Build and run the project

To build and run the project, use the build button (Cmd+R) in Xcode. Select your preferred device/simulator as the scheme.

## Examples

You'll find numerous examples illustrating the functionality and features of this reference app in the root directory. Each example is self-contained in its own directory, providing an easy way to understand how to use the app. For more information about each example, see the README file within its directory.

### Get Started
- [SDK quickstart](./get-started-sdk/)
- [Secure authentication with tokens](./authentication-workflow/)

### Core Functionality

- [Connect through restricted networks with Cloud Proxy](./cloud-proxy/)
- [Stream media to a channel](./play-media/)
- [Secure channel encryption](./media-stream-encryption/)
- [Live streaming over multiple channels](./live-streaming-over-multiple-channels/)
- [Call quality best practice](./ensure-channel-quality/)
- [Screen share, volume control and mute](./product-workflow/)
- [Custom video and audio sources](./custom-video-and-audio/)
- [Raw video and audio processing](./stream-raw-audio-and-video/)
<!-- - [Integrate and extension]() -->

### Integrate Features

- [Geofencing](./geofencing/)
- [Virtual background](./virtual-background/)

## Screenshots

| Landing page | Call quality best practice | Custom video and audio sources | Screen share, volume control and mute |
|:-:|:-:|:-:|:-:|
| ![Landing page of the application](Example-App/Docs-Examples/Documentation.docc/Resources/media/landing-page.png) | ![Two streams and quality details in the top left of each stream](Example-App/Docs-Examples/Documentation.docc/Resources/media/ensure-channel-quality.png) | ![Custom camera using the ultra wide iPhone capture](Example-App/Docs-Examples/Documentation.docc/Resources/media/custom-video-and-audio.png) | ![Local and remote olume control + screen sharing option](Example-App/Docs-Examples/Documentation.docc/Resources/media/product-workflow.png) |

## Contact

If you have any questions, issues, or suggestions, please file an issue in our [GitHub Issue Tracker](https://github.com/AgoraIO/video-sdk-samples-macos/issues).

