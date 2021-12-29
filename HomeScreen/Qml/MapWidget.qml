import QtQuick 2.12
import QtLocation 5.6
import QtPositioning 5.6
MouseArea {
    id: root
    preventStealing: true
    propagateComposedEvents: true
    implicitWidth: 632
    implicitHeight: 513
    property bool tmp
    Rectangle {
        id: nen
        anchors.fill: parent
        opacity: 0.7
        color: "#111419"
    }
    Item {
        id: map
        width: 632
        height: 513
        Plugin {
            id: mapPlugin
            name: "mapboxgl" //"osm" // , "esri", ...
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
            id: mapView
            anchors.fill: parent
            plugin: mapPlugin
            center: QtPositioning.coordinate(21.03, 105.78)
            zoomLevel: 14
            copyrightsVisible: false
            enabled: false
            Component.onCompleted: {
                mapView.addMapItem(marker)
            }
        }
    }
    Image {
        id: idBackgroud
        width: 632
        height: 513
        source: ""
    }

    states: [
        State {
            name: "Focus"
            PropertyChanges {
                target: idBackgroud
                source: "qrc:/Img/HomeScreen/bg_widget_f.png"
                width: 632
                height: 513
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: idBackgroud
                source: "qrc:/Img/HomeScreen/bg_widget_p.png"
                width: 632
                height: 513
            }
        },
        State {
            name: "Normal"
            PropertyChanges {
                target: idBackgroud
                source: ""
            }
        }
    ]
    onPressed: root.state = "Pressed"

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
