import QtQuick 2.15
import SddmComponents 2.0
import "." as Theme

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "black"

    // Add property to track current user
    property int currentUserIndex: userModel.lastIndex

    // Background image
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "backgrounds/" + Theme.Config.background
        fillMode: {
            if (Theme.Config.backgroundFillMode === "stretch") {
                return Image.Stretch
            } else if (Theme.Config.backgroundFillMode === "fit") {
                return Image.PreserveAspectFit
            } else {
                return Image.PreserveAspectCrop
            }
        }
    }

    // Login area
    Item {
        id: loginArea
        anchors {
            left: Theme.Config.loginPosition === "left" ? parent.left : undefined
            right: Theme.Config.loginPosition === "right" ? parent.right : undefined
            horizontalCenter: Theme.Config.loginPosition === "center" ? parent.horizontalCenter : undefined
            leftMargin: Theme.Config.loginPosition === "left" ? Theme.Config.loginMargin : 0
            rightMargin: Theme.Config.loginPosition === "right" ? Theme.Config.loginMargin : 0
            verticalCenter: parent.verticalCenter
        }
        width: 300
        height: childrenRect.height

        Column {
            spacing: 10
            
            // User avatar
            Rectangle {
                width: Theme.Config.avatarSize
                height: Theme.Config.avatarSize
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Theme.Config.avatarShape === "circle" ? width / 2 : 0
                color: "transparent"
                border.color: passwordBox.activeFocus ? Theme.Config.avatarBorderColor : "transparent"
                border.width: Theme.Config.avatarBorderWidth
                
                Image {
                    id: avatar
                    anchors.centerIn: parent
                    width: parent.width - 10
                    height: parent.height - 10
                    source: userModel.data(userModel.index(currentUserIndex, 0), Qt.UserRole + 2) || ""
                    fillMode: Image.PreserveAspectCrop
                    clip: true
                }
            }

            // Username display
            Text {
                id: usernameText
                anchors.horizontalCenter: parent.horizontalCenter
                text: userModel.data(userModel.index(currentUserIndex, 0), Qt.DisplayRole) || "User"
                font.family: Theme.Config.fontFamily
                font.pixelSize: Theme.Config.usernameFontSize
                font.weight: Font.Bold
                color: Theme.Config.usernameColor
            }

            // User selector (hidden unless multiple users) - NO COMBOBOX
            Rectangle {
                width: Theme.Config.passwordWidth
                height: Theme.Config.passwordHeight
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.Config.passwordBackgroundColor
                radius: Theme.Config.buttonRadius
                visible: userModel.count > 1
                
                Text {
                    id: userSelector
                    anchors.centerIn: parent
                    text: userModel.data(userModel.index(0, 0), Qt.DisplayRole) || "User"
                    font.family: Theme.Config.fontFamily
                    font.pixelSize: Theme.Config.passwordFontSize
                    color: Theme.Config.passwordTextColor
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Cycle through users on click
                        var nextIndex = (currentUserIndex + 1) % userModel.count
                        currentUserIndex = nextIndex
                        userSelector.text = userModel.data(userModel.index(nextIndex, 0), Qt.DisplayRole)
                        usernameText.text = userSelector.text
                    }
                }
            }

            // Password input and login button
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0
                
                Rectangle {
                    width: Theme.Config.passwordWidth
                    height: Theme.Config.passwordHeight
                    color: Theme.Config.passwordBackgroundColor
                    radius: Theme.Config.buttonRadius
                    
                    TextInput {
                        id: passwordBox
                        anchors.centerIn: parent
                        width: parent.width - 20
                        height: parent.height
                        font.family: Theme.Config.fontFamily
                        font.pixelSize: Theme.Config.passwordFontSize
                        color: Theme.Config.passwordTextColor
                        echoMode: TextInput.Password
                        
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                root.login()
                            }
                        }
                    }
                }
                
                Rectangle {
                    width: Theme.Config.buttonWidth
                    height: Theme.Config.buttonHeight
                    color: loginMouseArea.pressed ? "#FF000000" : Theme.Config.buttonBackgroundColor
                    radius: Theme.Config.buttonRadius
                    
                    Text {
                        text: "→"
                        anchors.centerIn: parent
                        font.pixelSize: 18
                        color: Theme.Config.buttonTextColor
                    }
                    
                    MouseArea {
                        id: loginMouseArea
                        anchors.fill: parent
                        onClicked: root.login()
                    }
                }
            }

            // Status message
            Text {
                id: statusMessage
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: Theme.Config.fontFamily
                font.pixelSize: Theme.Config.statusFontSize
                color: Theme.Config.statusColor
                visible: text.length > 0
                
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

    // Session selector (bottom right) - NO COMBOBOX
    Rectangle {
        id: sessionArea
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }
        width: Theme.Config.sessionWidth
        height: Theme.Config.sessionHeight
        color: Theme.Config.passwordBackgroundColor
        radius: Theme.Config.buttonRadius
        visible: Theme.Config.showSessionSelector && sessionModel.count > 1
        
        property int currentSessionIndex: sessionModel.lastIndex
        
        Text {
            id: sessionSelector
            anchors.centerIn: parent
            text: sessionModel.data(sessionModel.index(parent.currentSessionIndex, 0), Qt.DisplayRole) || "Session"
            font.family: Theme.Config.fontFamily
            font.pixelSize: Theme.Config.passwordFontSize
            color: Theme.Config.passwordTextColor
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Cycle through sessions on click
                var nextIndex = (parent.currentSessionIndex + 1) % sessionModel.count
                parent.currentSessionIndex = nextIndex
                sessionSelector.text = sessionModel.data(sessionModel.index(nextIndex, 0), Qt.DisplayRole)
            }
        }
    }

    // Power buttons
    Column {
        anchors {
            left: parent.left
            leftMargin: Theme.Config.powerButtonMargin
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: Theme.Config.powerButtonOffset
        }
        spacing: 10
        visible: Theme.Config.showPowerButtons
        
        // Power button
        Rectangle {
            width: Theme.Config.powerButtonSize
            height: Theme.Config.powerButtonSize
            color: powerMouseArea.pressed ? "#FF000000" : Theme.Config.buttonBackgroundColor
            radius: Theme.Config.buttonRadius
            
            Text {
                text: "⏻"
                anchors.centerIn: parent
                font.pixelSize: 16
                color: Theme.Config.buttonTextColor
            }
            
            MouseArea {
                id: powerMouseArea
                anchors.fill: parent
                onClicked: sddm.powerOff()
            }
        }
        
        // Restart button
        Rectangle {
            width: Theme.Config.powerButtonSize
            height: Theme.Config.powerButtonSize
            color: restartMouseArea.pressed ? "#FF000000" : Theme.Config.buttonBackgroundColor
            radius: Theme.Config.buttonRadius
            
            Text {
                text: "↻"
                anchors.centerIn: parent
                font.pixelSize: 16
                color: Theme.Config.buttonTextColor
            }
            
            MouseArea {
                id: restartMouseArea
                anchors.fill: parent
                onClicked: sddm.reboot()
            }
        }
    }

    // SDDM connections
    Connections {
        target: sddm
        
        function onLoginSucceeded() {
            statusMessage.text = "Login successful!"
        }
        
        function onLoginFailed() {
            statusMessage.showError("Login failed")
            passwordBox.text = ""
            passwordBox.forceActiveFocus()
        }
    }

    function login() {
        if (passwordBox.text.length === 0) {
            statusMessage.showError("Please enter password")
            return
        }
        
        sddm.login(
            userModel.data(userModel.index(currentUserIndex, 0), Qt.UserRole),
            passwordBox.text,
            sessionArea.currentSessionIndex
        )
    }

    Component.onCompleted: {
        passwordBox.forceActiveFocus()
    }
}
