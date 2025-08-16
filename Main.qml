import QtQuick 2.15
import SddmComponents 2.0
import "." as Theme

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "black"

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
                    source: userModel.data(userModel.index(userBox.currentIndex, 0), Qt.UserRole + 2) || ""
                    fillMode: Image.PreserveAspectCrop
                    clip: true
                }
            }

            // Username display
            Text {
                id: usernameText
                anchors.horizontalCenter: parent.horizontalCenter
                text: userModel.data(userModel.index(userBox.currentIndex, 0), Qt.DisplayRole) || "User"
                font.family: Theme.Config.fontFamily
                font.pixelSize: Theme.Config.usernameFontSize
                font.weight: Font.Bold
                color: Theme.Config.usernameColor
            }

            // User selector (hidden unless multiple users)
            Rectangle {
                width: Theme.Config.passwordWidth
                height: Theme.Config.passwordHeight
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.Config.passwordBackgroundColor
                radius: Theme.Config.buttonRadius
                visible: userModel.count > 1
                
                ComboBox {
                    id: userBox
                    anchors.fill: parent
                    model: userModel
                    textRole: "display"
                    currentIndex: userModel.lastIndex
                    
                    background: Rectangle {
                        color: "transparent"
                    }
                    
                    contentItem: Text {
                        text: userBox.displayText
                        font.family: Theme.Config.fontFamily
                        font.pixelSize: Theme.Config.passwordFontSize
                        color: Theme.Config.passwordTextColor
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 10
                    }
                    
                    onActivated: {
                        usernameText.text = userModel.data(userModel.index(currentIndex, 0), Qt.DisplayRole)
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

    // Session selector (bottom right)
    Rectangle {
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
        
        ComboBox {
            id: sessionBox
            anchors.fill: parent
            model: sessionModel
            textRole: "display"
            currentIndex: sessionModel.lastIndex
            
            background: Rectangle {
                color: "transparent"
            }
            
            contentItem: Text {
                text: sessionBox.displayText
                font.family: Theme.Config.fontFamily
                font.pixelSize: Theme.Config.passwordFontSize
                color: Theme.Config.passwordTextColor
                verticalAlignment: Text.AlignVCenter
                leftPadding: 10
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
            userModel.data(userModel.index(userBox.currentIndex, 0), Qt.UserRole),
            passwordBox.text,
            sessionBox.currentIndex
        )
    }

    Component.onCompleted: {
        passwordBox.forceActiveFocus()
    }
}
