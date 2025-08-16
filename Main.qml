import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "black"

    // Background image
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "backgrounds/sun_sakura.png"
        fillMode: Image.PreserveAspectCrop
    }

    // Login area positioned on the left with 120px margin
    Item {
        id: loginArea
        anchors {
            left: parent.left
            leftMargin: 120
            verticalCenter: parent.verticalCenter
        }
        width: 300
        height: childrenRect.height

        Column {
            spacing: 10
            
            // User avatar (simple circle)
            Rectangle {
                width: 120
                height: 120
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 60
                color: "#333"
                border.color: passwordBox.activeFocus ? "#04a5e5" : "#666"
                border.width: 3
                
                Image {
                    id: avatar
                    anchors.centerIn: parent
                    width: 110
                    height: 110
                    source: userModel.data(userModel.index(userBox.currentIndex, 0), Qt.UserRole + 2) || ""
                    fillMode: Image.PreserveAspectCrop
                    
                    // Simple circular clipping
                    Rectangle {
                        anchors.fill: parent
                        radius: 55
                        color: "transparent"
                        clip: true
                        
                        Image {
                            anchors.fill: parent
                            source: avatar.source
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }
            }

            // Username
            Text {
                id: usernameText
                anchors.horizontalCenter: parent.horizontalCenter
                text: userModel.data(userModel.index(userBox.currentIndex, 0), Qt.DisplayRole) || "User"
                font.family: "Ubuntu Sans"
                font.pixelSize: 16
                font.weight: Font.Bold
                color: "#FFFFFF"
            }

            // Username dropdown (hidden unless multiple users)
            Rectangle {
                width: 150
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#BF000000"
                radius: 5
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
                    
                    onCurrentIndexChanged: {
                        usernameText.text = userModel.data(userModel.index(currentIndex, 0), Qt.DisplayRole)
                    }
                }
            }

            // Password input and login button row
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0
                
                Rectangle {
                    id: passwordContainer
                    width: 150
                    height: 30
                    color: "#BF000000"
                    
                    Row {
                        anchors.centerIn: parent
                        spacing: 5
                        
                        // Password icon
                        Text {
                            text: "🔒"
                            font.pixelSize: 12
                            color: "#FFFFFF"
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
                        }
                    }
                }
                
                Rectangle {
                    id: loginButton
                    width: 40
                    height: 30
                    color: loginMouseArea.pressed ? "#FF000000" : "#BF000000"
                    
                    Text {
                        text: "→"
                        font.pixelSize: 18
                        color: "#FFFFFF"
                        anchors.centerIn: parent
                    }
                    
                    MouseArea {
                        id: loginMouseArea
                        anchors.fill: parent
                        onClicked: root.login()
                    }
                }
            }

            // Status/error messages
            Text {
                id: statusMessage
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Ubuntu Sans"
                font.pixelSize: 11
                color: "#FFFFFF"
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

    // Session selection (bottom right)
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
        visible: sessionModel.count > 1
        
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
                font.family: "Ubuntu Sans"
                font.pixelSize: 10
                color: "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                leftPadding: 10
            }
        }
    }

    // Power buttons
    Column {
        anchors {
            left: parent.left
            leftMargin: 50
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: 100
        }
        spacing: 10
        
        // Power button
        Rectangle {
            width: 30
            height: 30
            color: powerMouseArea.pressed ? "#FF000000" : "#BF000000"
            
            Text {
                text: "⏻"
                font.pixelSize: 16
                color: "#FFFFFF"
                anchors.centerIn: parent
            }
            
            MouseArea {
                id: powerMouseArea
                anchors.fill: parent
                onClicked: sddm.powerOff()
            }
        }
        
        // Restart button
        Rectangle {
            width: 30
            height: 30
            color: restartMouseArea.pressed ? "#FF000000" : "#BF000000"
            
            Text {
                text: "↻"
                font.pixelSize: 16
                color: "#FFFFFF"
                anchors.centerIn: parent
            }
            
            MouseArea {
                id: restartMouseArea
                anchors.fill: parent
                onClicked: sddm.reboot()
            }
        }
    }

    // Connect to SDDM
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
