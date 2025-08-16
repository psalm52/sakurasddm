import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "black"

    // Background image
    Image {
        anchors.fill: parent
        source: "backgrounds/sun_sakura.png"
        fillMode: Image.PreserveAspectCrop
    }

    // Login area
    Column {
        anchors {
            left: parent.left
            leftMargin: 120
            verticalCenter: parent.verticalCenter
        }
        spacing: 20
        
        // Username
        Text {
            text: "Welcome"
            font.family: "Ubuntu Sans"
            font.pixelSize: 24
            color: "#FFFFFF"
        }
        
        // Password field
        Rectangle {
            width: 200
            height: 40
            color: "#BF000000"
            radius: 5
            
            TextInput {
                id: passwordBox
                anchors.centerIn: parent
                width: parent.width - 20
                height: parent.height
                font.family: "Ubuntu Sans"
                font.pixelSize: 14
                color: "#FFFFFF"
                echoMode: TextInput.Password
                
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        root.login()
                    }
                }
            }
        }
        
        // Login button
        Rectangle {
            width: 100
            height: 40
            color: loginMouse.pressed ? "#FF000000" : "#BF000000"
            radius: 5
            
            Text {
                text: "Login"
                anchors.centerIn: parent
                font.family: "Ubuntu Sans"
                font.pixelSize: 14
                color: "#FFFFFF"
            }
            
            MouseArea {
                id: loginMouse
                anchors.fill: parent
                onClicked: root.login()
            }
        }
        
        // Status message
        Text {
            id: statusText
            font.family: "Ubuntu Sans"
            font.pixelSize: 12
            color: "#FF6666"
            visible: text.length > 0
        }
    }

    // Power button (bottom left)
    Rectangle {
        anchors {
            left: parent.left
            bottom: parent.bottom
            margins: 20
        }
        width: 40
        height: 40
        color: powerMouse.pressed ? "#FF000000" : "#BF000000"
        radius: 5
        
        Text {
            text: "⏻"
            anchors.centerIn: parent
            font.pixelSize: 16
            color: "#FFFFFF"
        }
        
        MouseArea {
            id: powerMouse
            anchors.fill: parent
            onClicked: sddm.powerOff()
        }
    }

    // SDDM connections
    Connections {
        target: sddm
        
        function onLoginSucceeded() {
            statusText.text = "Success!"
        }
        
        function onLoginFailed() {
            statusText.text = "Login failed"
            passwordBox.text = ""
            passwordBox.forceActiveFocus()
        }
    }

    function login() {
        if (passwordBox.text.length === 0) {
            statusText.text = "Enter password"
            return
        }
        
        // Use first user and first session for simplicity
        sddm.login(
            userModel.data(userModel.index(0, 0), Qt.UserRole),
            passwordBox.text,
            0
        )
    }

    Component.onCompleted: {
        passwordBox.forceActiveFocus()
    }
}
