import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    width: Screen.width
    height: Screen.height
    
    // Your background
    Image {
        anchors.fill: parent
        source: "backgrounds/sun_sakura.png"
        fillMode: Image.PreserveAspectCrop
    }
    
    // Login on the left (120px from edge)
    Column {
        anchors {
            left: parent.left
            leftMargin: 120
            verticalCenter: parent.verticalCenter
        }
        spacing: 20
        
        Text {
            text: "Welcome"
            color: "white"
            font.pixelSize: 24
        }
        
        Rectangle {
            width: 200
            height: 40
            color: "#80000000"
            
            TextInput {
                id: pwd
                anchors.fill: parent
                anchors.margins: 10
                color: "white"
                echoMode: TextInput.Password
                Keys.onReturnPressed: {
                    sddm.login("psalms", pwd.text, 0)
                }
            }
        }
        
        Rectangle {
            width: 100
            height: 40
            color: "#80000000"
            
            Text {
                anchors.centerIn: parent
                text: "Login"
                color: "white"
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    sddm.login("psalms", pwd.text, 0)
                }
            }
        }
    }
}
