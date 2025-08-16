pragma Singleton
import QtQuick 2.15

QtObject {
    // Background settings
    property string background: config.stringValue("background") || "sun_sakura.png"
    property string backgroundFillMode: config.stringValue("background-fill-mode") || "fill"
    
    // Login area settings  
    property string loginPosition: config.stringValue("login-position") || "left"
    property int loginMargin: config.intValue("login-margin") || 120
    
    // Avatar settings
    property string avatarShape: config.stringValue("avatar-shape") || "circle"
    property int avatarSize: config.intValue("avatar-size") || 120
    property string avatarBorderColor: config.stringValue("avatar-border-color") || "#04a5e5"
    property int avatarBorderWidth: config.intValue("avatar-border-width") || 5
    
    // Font settings
    property string fontFamily: config.stringValue("font-family") || "Ubuntu Sans"
    property int usernameFontSize: config.intValue("username-font-size") || 16
    property int passwordFontSize: config.intValue("password-font-size") || 12
    property int statusFontSize: config.intValue("status-font-size") || 11
    
    // Color settings
    property string usernameColor: config.stringValue("username-color") || "#FFFFFF"
    property string passwordBackgroundColor: config.stringValue("password-background-color") || "#BF000000"
    property string passwordTextColor: config.stringValue("password-text-color") || "#FFFFFF"
    property string buttonBackgroundColor: config.stringValue("button-background-color") || "#BF000000"
    property string buttonTextColor: config.stringValue("button-text-color") || "#FFFFFF"
    property string statusColor: config.stringValue("status-color") || "#FF6666"
    
    // Button settings
    property int passwordWidth: config.intValue("password-width") || 150
    property int passwordHeight: config.intValue("password-height") || 30
    property int buttonWidth: config.intValue("button-width") || 40
    property int buttonHeight: config.intValue("button-height") || 30
    property int buttonRadius: config.intValue("button-radius") || 5
    
    // Power button settings
    property bool showPowerButtons: config.boolValue("show-power-buttons") !== false
    property int powerButtonSize: config.intValue("power-button-size") || 30
    property int powerButtonMargin: config.intValue("power-button-margin") || 50
    property int powerButtonOffset: config.intValue("power-button-offset") || 100
    
    // Session settings
    property bool showSessionSelector: config.boolValue("show-session-selector") !== false
    property int sessionWidth: config.intValue("session-width") || 200
    property int sessionHeight: config.intValue("session-height") || 30
}
