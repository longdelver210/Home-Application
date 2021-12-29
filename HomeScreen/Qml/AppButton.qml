import QtQuick 2.12

MouseArea {
    id: root
    implicitWidth: 313
    implicitHeight: 453
    property string icon
    property string title
    property bool tmp

    Image {
        id: idBackgroud
        width: 313
        height: 453
        source: icon + "_n.png"
    }
    Text {
        id: appTitle
        anchors.horizontalCenter: parent.horizontalCenter
        y: 300
        text: title
        font.pixelSize: 36
        color: "white"
    }
    state: "normal"
    states: [
        State {
            name: "Focus"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_f.png"
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_p.png"
            }
        },
        State {
            name: "Normal"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_n.png"
            }
        }
    ]
    onPressed:  root.state = "Pressed"

    onFocusChanged: {
        if (root.focus == true )
            root.state = "Focus"
        else
            root.state = "Normal"
    }
    onTmpChanged: {
        if (root.focus == true )
            root.state = "Focus"
        else
            root.state = "Normal"
    }

}
