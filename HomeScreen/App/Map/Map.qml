import QtQuick 2.11
import QtQuick.Controls 2.4
import QtLocation 5.6
import QtPositioning 5.6

Item {
    id: root
    width: 1920
    height: 986
    Text {
        id: title
        width: parent.width
        height: 150
        text:"Map"
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

    Item {
        id: startAnimation
        XAnimator{
            target: root
            from: 1920
            to: 0
            duration: 200
            running: true
        }
    }

    Plugin {
        id: mapPlugin
        name: "mapboxgl"
    }
    MapQuickItem {
        id: marker
        anchorPoint.x: image.width/4
        anchorPoint.y: image.height
        coordinate: QtPositioning.coordinate(21.03, 105.78)

        sourceItem: Image {
            id: image
            source: "qrc:/Img/Map/car_icon.png"
        }
    }
    Map {
        id: map
        anchors.top:title.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        plugin: mapPlugin
        center: marker.coordinate//QtPositioning.coordinate(21.03, 105.78)
        zoomLevel: 14
        copyrightsVisible: false
        Component.onCompleted: {
            map.addMapItem(marker)
        }
    }
}
