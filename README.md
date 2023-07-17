# Video SDK for macOS code examples

Use the contents in this repo to compare the following ways of presenting runnable code examples in an open source 
repository. In all examples, the code corresponds to a page in the Agora developer documentation. 

Each folder contains the runnable code explained in the documentation. 

Advantages are that we supply runnable code where the UI is abstracted so we concentrate more clearly on Agora
    SDK. This means the docs become much shorter and simpler. Possible disadvantage is that we have to write the
    code for the project. TBH, we already have the code, we are just putting it in a better format for learning.
- [SDK quickstart](get-started-sdk)
- [Call quality](ensure-channel-quality)
- [Secure authentication with tokens](authentication-workflow)


## Run this project

To run the example project in this folder, take the following steps:

1. Clone the Git repository by executing the following command in a terminal window:

    ```bash
    git clone https://github.com/AgoraIO/video-sdk-samples-macos.git
    ```

    If you are using a device using the ARM architecture (e.g. MacBook Air M1, M2) take the following additional steps:

    1. Download the latest jq binary for macOS from their [official website](https://jqlang.github.io/jq/download/) and save it on the `/Documents` folder.

    1. Open a terminal window and input the following command:

    ```bash
    sudo ln -s /Users/<your_macos_user_name>/Documents/<file_name_of_downloaded_jq> jq
    ```

    1. Restart your device for the changes to take effect.

1. Launch Xcode. From the **File** menu, select **Open...**, then choose the folder for the sample project you want to run. Wait for dependency installations to complete.

1. Open the `config.json` file inside the `AgoraManager` directory and update the values to match your configurations.

1. Refer to the README file in the selected project folder and follow the link to view complete project documentation for your product of interest.

1. In Xcode, click the **Run** button. A moment later, you see the project installed on your device.

1. Choose a feature from the app UI and test the results.
