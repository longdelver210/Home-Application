import QtQuick 2.0

Item {
    id: root
    width: 1920
    height: 986
    Text {
        id: title
        width: parent.width
        height: 150
        text:"Phone"
        font.pointSize: 35
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        z:1
    }
    Rectangle{
        width: parent.width
        height: 150
        color: "gray"
        z:0
    }


}
