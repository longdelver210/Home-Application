import QtQuick 2.0

Item {
    property alias playlistButtonStatus: playlist_button.status
    signal clickPlaylistButton
    Rectangle {
        id: headerItem
        width: parent.width
        height: 150
        color: "gray"
        SwitchButton {
            id: playlist_button
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            icon_off: "qrc:/App/Media/Image/drawer.png"
            icon_on: "qrc:/App/Media/Image/back.png"
            onClicked: {
                clickPlaylistButton()
            }
        }
        Text {
            anchors.left: playlist_button.right
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Playlist")
            color: "white"
            font.pixelSize: 32
        }
        Text {
            id: headerTitleText
            anchors.centerIn: parent
            text: qsTr("Media Player")
            color: "white"
            font.pointSize: 35

        }
    }
}
