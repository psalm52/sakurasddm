import QtQuick 2.15
import QtMultimedia 6.0
import QtQuick.Effects 6.0
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "black"

    // Background container
    Item {
        id: backgroundContainer
        anchors.fill: parent

        // Video background
        Video {
            id: backgroundVideo
            anchors.fill: parent
            source: "backgrounds/sun_sakura.mp4"
            autoPlay: true
            loops: MediaPlayer.Infinite
            fillMode: VideoOutput.PreserveAspectCrop
            muted: true
            
            Component.onCompleted: {
                if (source && source.toString().length > 0) {
                    play()
                }
            }
            
            onErrorOccurred: function(error) {
                if (error !== MediaPlayer.NoError) {
                    // Fall back to placeholder image
                    placeholderImage.visible = true
                }
            }
        }

        // Fallback placeholder image
        Image {
            id: placeholderImage
            anchors.fill: parent
            source: "backgrounds/sun_sakura.png"
            fillMode: Image.PreserveAspectCrop
            visible: backgroundVideo.playbackState !== MediaPlayer.PlayingState
        }
    }

    // Background effects (blur, brightness, saturation)
    MultiEffect {
        id: backgroundEffect
        source: backgroundContainer
        anchors.fill: parent
        
        // Blur properties
        blurEnabled: blurAmount > 0
        blur: blurAmount > 0 ? 1.0 : 0.0
        blurMax: blurAmount
        
        // Color adjustments
        brightness: brightnessAmount
        saturation: saturationAmount
        
        autoPaddingEnabled: false
        
        // Animation properties
        property real blurAmount: 0
        property real brightnessAmount: 0.0
        property real saturationAmount: 0.0
        
        Behavior on blurMax {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }
        
        Behavior on brightness {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }
        
        Behavior on saturation {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }
    }

    // Login area positioned on the left with 120px margin (matching your config)
    Item {
        id: loginArea
        anchors {
            left: parent.left
            leftMargin: 120
            verticalCenter: parent.verticalCenter
        }
        width: 300
        height: childrenRect.height

        // Add entrance animation
        scale: 0.5
        opacity: 0.0
        
        Component.onCompleted: {
            entranceAnimation.start()
        }
        
        PropertyAnimation {
            id: entranceAnimation
            target: loginArea
            properties: "scale,opacity"
            to: 1.0
            duration: 600
            easing.type: Easing.OutBack
        }

        Column {
            spacing: 10
            
            // User avatar (circular with blue border when focused, matching your config)
            Item {
                width: 120
                height: 120
                anchors.horizontalCenter: parent.horizontalCenter
                
                Image {
                    id: avatar
                    anchors.fill: parent
                    source: userModel.data(userModel.index(userBox.currentIndex, 0), Qt.UserRole + 2) || ""
                    fillMode: Image.PreserveAspectCrop
                    
                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: "transparent"
                        border.color: passwordBox.activeFocus || userBox.activeFocus ? "#04a5e5" : "transparent"
                        border.width: 5
                        
                        Behavior on border.color {
                            ColorAnimation {
                                duration: 250
                            }
                        }
                    }
                    
                    // Circular mask
                    layer.enabled: true
                    layer.effect: Item {
                        Rectangle {
                            anchors.fill: parent
                            radius: width / 2
                            color: "black"
                        }
                    }
                }
            }

            // Username (matching your font settings)
            Text {
                id: usernameText
                anchors.horizontalCenter: parent.horizontalCenter
                text: userModel.data(userModel.index(userBox.currentIndex, 0), Qt.DisplayRole) || "User"
                font.family: "Ubuntu Sans"
                font.pixelSize: 16
                font.weight: Font.Bold
                color: "#000000"
            }

            // Username dropdown (hidden, but functional)
            ComboBox {
                id: userBox
                width: 150
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                model: userModel
                textRole: "display"
                currentIndex: userModel.lastIndex
                visible: userModel.count > 1
                
                background: Rectangle {
                    color: "#BF000000" // 0.75 opacity black
                    radius: 5
                }
                
                onCurrentIndexChanged: {
                    usernameText.text = userModel.data(userModel.index(currentIndex, 0), Qt.DisplayRole)
                }
            }

            // Password input and login button row (matching your config design)
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0
                
                Rectangle {
                    id: passwordContainer
                    width: 150
                    height: 30
                    color: "#BF000000" // 0.75 opacity black
                    radius: 10
                    
                    // Only round left corners
                    Rectangle {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 10
                        color: parent.color
                    }
                    
                    Row {
                        anchors.centerIn: parent
                        spacing: 5
                        
                        // Password icon
                        Image {
                            source: "icons/password.svg"
                            width: 16
                            height: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        TextInput {
                            id: passwordBox
                            width: 110
                            height: 20
                            font.family: "Ubuntu Sans"
                            font.pixelSize: 12
                            color: "#FFFFFF"
                            echoMode: TextInput.Password
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Keys.onPressed: {
                                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    root.login()
                                }
                            }
                            
                            onActiveFocusChanged: {
                                if (activeFocus) {
                                    // Add subtle blur when focusing on password
                                    backgroundEffect.blurAmount = 5
                                    backgroundEffect.brightnessAmount = -0.2
                                } else {
                                    // Remove blur when unfocused
                                    backgroundEffect.blurAmount = 0
                                    backgroundEffect.brightnessAmount = 0.0
                                }
                            }
                        }
                    }
                }
                
                Rectangle {
                    id: loginButton
                    width: 40
                    height: 30
                    color: loginMouseArea.pressed ? "#FF000000" : "#BF000000"
                    radius: 10
                    
                    // Only round right corners
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 10
                        color: parent.color
                    }
                    
                    Image {
                        source: "icons/arrow-right.svg"
                        width: 18
                        height: 18
                        anchors.centerIn: parent
                    }
                    
                    MouseArea {
                        id: loginMouseArea
                        anchors.fill: parent
                        onClicked: {
                            root.login()
                        }
                    }
                    
                    // Subtle glow effect on hover
                    scale: loginMouseArea.containsMouse ? 1.05 : 1.0
                    Behavior on scale {
                        NumberAnimation {
                            duration: 150
                        }
                    }
                    
                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }
            }

            // Status/error messages
            Text {
                id: statusMessage
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Ubuntu Sans"
                font.pixelSize: 11
                color: "#000000"
                visible: text.length > 0
                
                // Fade in/out animation
                opacity: text.length > 0 ? 1.0 : 0.0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 250
                    }
                }
                
                function showError(msg) {
                    text = msg
                    errorTimer.restart()
                }
                
                Timer {
                    id: errorTimer
                    interval: 3000
                    onTriggered: statusMessage.text = ""
                }
            }
        }
    }

    // Session selection (bottom right, matching your config)
    Rectangle {
        id: sessionArea
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }
        width: 200
        height: 30
        color: "#BF000000"
        radius: 5
        visible: sessionModel.count > 1
        
        // Slide in from right animation
        x: root.width
        Component.onCompleted: {
            sessionSlideAnimation.start()
        }
        
        PropertyAnimation {
            id: sessionSlideAnimation
            target: sessionArea
            property: "x"
            to: root.width - sessionArea.width - 20
            duration: 800
            easing.type: Easing.OutCubic
        }
        
        Row {
            anchors.centerIn: parent
            spacing: 8
            
            Image {
                id: sessionIcon
                source: getSessionIcon(sessionBox.currentIndex)
                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                id: sessionBox
                width: 160
                model: sessionModel
                textRole: "display"
                currentIndex: sessionModel.lastIndex
                
                background: Rectangle {
                    color: "transparent"
                }
                
                contentItem: Text {
                    text: sessionBox.displayText
                    font.family: "Ubuntu Sans"
                    font.pixelSize: 10
                    color: "#FFFFFF"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 5
                }
                
                onCurrentIndexChanged: {
                    sessionIcon.source = getSessionIcon(currentIndex)
                }
            }
        }
    }

    // Power/system buttons (matching your menu area config)
    Column {
        id: powerButtons
        anchors {
            left: parent.left
            leftMargin: 50
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: 100
        }
        spacing: 10
        
        // Slide in from left animation
        x: -60
        Component.onCompleted: {
            powerSlideAnimation.start()
        }
        
        PropertyAnimation {
            id: powerSlideAnimation
            target: powerButtons
            property: "x"
            to: 50
            duration: 1000
            easing.type: Easing.OutCubic
        }
        
        // Power button
        Rectangle {
            width: 30
            height: 30
            color: powerMouseArea.pressed ? "#FF000000" : "#BF000000"
            radius: 5
            
            Image {
                source: "icons/power.svg"
                width: 16
                height: 16
                anchors.centerIn: parent
            }
            
            MouseArea {
                id: powerMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.powerOff()
            }
            
            scale: powerMouseArea.containsMouse ? 1.1 : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: 150
                }
            }
        }
        
        // Restart button
        Rectangle {
            width: 30
            height: 30
            color: restartMouseArea.pressed ? "#FF000000" : "#BF000000"
            radius: 5
            
            Image {
                source: "icons/power-reboot.svg"
                width: 16
                height: 16
                anchors.centerIn: parent
            }
            
            MouseArea {
                id: restartMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.reboot()
            }
            
            scale: restartMouseArea.containsMouse ? 1.1 : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: 150
                }
            }
        }
    }

    // Connect to SDDM
    Connections {
        target: sddm
        
        function onLoginSucceeded() {
            statusMessage.text = "Login successful!"
            // Animate blur and fade out on success
            backgroundEffect.blurAmount = 20
            backgroundEffect.brightnessAmount = -0.5
            loginArea.opacity = 0.0
        }
        
        function onLoginFailed() {
            statusMessage.showError("Login failed")
            passwordBox.text = ""
            passwordBox.forceActiveFocus()
            
            // Shake animation on login failure
            shakeAnimation.start()
        }
        
        // Shake animation for login failure
        PropertyAnimation {
            id: shakeAnimation
            target: loginArea
            property: "anchors.leftMargin"
            from: 120
            to: 130
            duration: 100
            loops: 4
            onStopped: {
                loginArea.anchors.leftMargin = 120
            }
        }
    }

    function login() {
        if (passwordBox.text.length === 0) {
            statusMessage.showError("Please enter password")
            return
        }
        
        sddm.login(
            userModel.data(userModel.index(userBox.currentIndex, 0), Qt.UserRole),
            passwordBox.text,
            sessionBox.currentIndex
        )
    }

    function getSessionIcon(sessionIndex) {
        if (sessionIndex < 0 || sessionIndex >= sessionModel.count) {
            return "icons/sessions/default.svg"
        }
        
        var sessionName = sessionModel.data(sessionModel.index(sessionIndex, 0), Qt.DisplayRole).toLowerCase()
        
        // Map session names to icons
        var iconMap = {
            "niri": "icons/sessions/niri.svg",
            "hyprland": "icons/sessions/hyprland.svg",
            "cosmic": "icons/sessions/cosmic.svg",
            "plasma": "icons/sessions/plasma.svg",
            "kde": "icons/sessions/plasma.svg", 
            "gnome": "icons/sessions/gnome.svg",
            "ubuntu": "icons/sessions/ubuntu.svg",
            "xfce": "icons/sessions/xfce.svg",
            "i3": "icons/sessions/i3.svg",
            "sway": "icons/sessions/sway.svg",
            "xorg": "icons/sessions/xorg.svg",
            "wayland": "icons/sessions/wayland.svg"
        }
        
        // Check for exact matches first
        if (iconMap[sessionName]) {
            return iconMap[sessionName]
        }
        
        // Check for partial matches
        for (var key in iconMap) {
            if (sessionName.includes(key)) {
                return iconMap[key]
            }
        }
        
        return "icons/sessions/default.svg"
    }

    Component.onCompleted: {
        passwordBox.forceActiveFocus()
    }
}
