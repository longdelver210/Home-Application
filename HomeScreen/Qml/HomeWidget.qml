import QtQuick 2.14
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQml.Models 2.2
import QtQml 2.12


Item {
    id: root
    width: 1920
    height: 986
    //ham mo ung dung
    function openApplication(url){
        parent.push(url)
    }
    property int focusArea:0                            //vung focus 0-widget, 1-app
    property int indexWidget: 1                         //chi muc cho cac widget:0-1-2
    property int indexApp: 0                            //chi muc cho cac app trong list app:0-1-2-3-.....
    property int countListApp: appv.count               //so app trong app menu
    property string appUrl                              //duong link cua app trong list app dang duoc focus
    property int tabview: ((appv.count - 1)/6) + 1      //so khung nhin cua app menu
    property double step: 1/tabview                     //buoc nhay khi chuyen khung nhin bang phim cung
    property bool increIndexApp                         // bien xac dinh indexApp tang hay giam
    property int oldIndexApp


    //ham xu ly kien phim cung
    function handleHardkey(event){
       // root.hove = false
        switch(event.key){
        case Qt.Key_Right:
            if(focusArea == 0){
                indexWidget++
                if(indexWidget > 2)
                    indexWidget = 0
            }else{
                indexApp++
                increIndexApp = true
                if(indexApp == countListApp){
                    indexApp = 0
                    increIndexApp = false
                }
            }
            break
        case Qt.Key_Left:
            if(focusArea == 0){
                indexWidget--
                if(indexWidget < 0)
                    indexWidget = 2
            }else{
                indexApp--
                increIndexApp = false
                if(indexApp < 0){
                    indexApp = countListApp - 1
                    increIndexApp = true
                }
            }
            break
        case Qt.Key_Up:
        case Qt.Key_Down:
            if(focusArea == 0){
                focusArea = 1
            }else{
                focusArea = 0
            }
            break
        case Qt.Key_Return:
        case Qt.Key_Enter:
            if(focusArea == 0){
                if( indexWidget == 0){
                    openApplication("qrc:/App/Map/Map.qml")
                }
                if(indexWidget == 1){
                    openApplication("qrc:/App/Climate/Climate.qml")
                }
                if(indexWidget == 2){
                    openApplication("qrc:/App/Media/Media.qml")
                }
            }else{
                openApplication(appUrl)
            }
            break
        }
    }


    //widgets
    ListView {
        id: lvWidget
        anchors.left: parent.left ; anchors.leftMargin: 6
        width: 1914 ; height: 513
        implicitWidth: 1914
        spacing: 6
        orientation: ListView.Horizontal
        interactive: false
//        displaced: Transition {
//            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
//        }

        model: DelegateModel {
            id: visualModelWidget
            model: ListModel {
                id: widgetModel
                // @disable-check M16
                ListElement { type: "map" }
                // @disable-check M16
                ListElement { type: "climate" }
                // @disable-check M16
                ListElement { type: "media" }
            }

            delegate: DropArea {
                id: delegateRootWidget
                width: 632; height: 513
                Loader {
                    id: iconWidget
                    property int visualIndex: 0
                    width: 632; height: 513
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }
                    sourceComponent: {
                        switch(model.type) {
                        case "map": return mapWidget
                        case "climate": return climateWidget;
                        case "media": return mediaWidget
                        }
                    }
                }
            }
        }

        Component {
            id: mapWidget
            MapWidget{
                tmp:true
                onReleased: {
                    openApplication("qrc:/App/Map/Map.qml")
                    tmp = tmp?false:true
                    root.focusArea = 0
                    root.indexWidget = 0
                }

                focus: (root.focusArea === 0 && root.indexWidget === 0)?true:false
            }
        }
        Component {
            id: climateWidget
            ClimateWidget {
                tmp: true
                onReleased: {
                    openApplication("qrc:/App/Climate/Climate.qml")
                    tmp = tmp?false:true
                    root.focusArea = 0
                    root.indexWidget = 1
                }

                focus:(root.focusArea === 0 && root.indexWidget === 1)?true:false
            }
        }
        Component {
            id: mediaWidget
            MediaWidget{
                tmp: true
                onReleased: {
                  openApplication("qrc:/App/Media/Media.qml")
                    tmp = tmp?false:true
                    root.focusArea = 0
                    root.indexWidget = 2
                }

                focus: (root.focusArea == 0 && root.indexWidget == 2)?true:false
            }
        }
    }

    //app menu
    ListView {
        id: appv
        anchors.top: lvWidget.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 6
        width: 1914; height: 453
        orientation: ListView.Horizontal
        interactive: true
        spacing: 6

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

        model: DelegateModel {
            id: visualModel
            model: appsModel
            delegate: DropArea {
                id: delegateRoot
                width: 313; height: 453
                keys: "AppButton"
                onEntered:visualModel.items.move(drag.source.visualIndex, icon.visualIndex)
                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: icon; property: "visualIndex"; value: visualIndex }

                Item {
                    id: icon
                    property int visualIndex: 0
                    width: 313; height: 453
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }

                    AppButton{
                        id: app
                        anchors.fill: parent
                        title: model.title
                        icon: model.iconPath
                        tmp: true
                        property bool held: false

                        drag.axis: Drag.XAxis
                        drag.target:held?parent:undefined

                        onClicked: openApplication(model.url)

                        //khi reoder xong
                        onReleased: {
                           tmp = tmp?false:true
                           root.focusArea = 1
                           root.indexApp = icon.visualIndex
                            if((root.oldIndexApp !== icon.visualIndex) && held == true){
                                xmlHandler.save(icon.visualIndex + 1, model.title, model.iconPath, model.url, oldIndexApp + 1);
                            }
                            held = false
                        }

                        hoverEnabled: held
                        onPositionChanged: {
                            root.indexApp = icon.visualIndex
                        }

                        onCanceled: {
                            tmp = tmp?false:true
                            root.focusArea = 1
                            root.indexApp = icon.visualIndex
                        }

                        onPressAndHold: {
                            held = true
                            root.oldIndexApp = icon.visualIndex
                        }

                        //isFocus phu thuoc theo bien chi muc
                        focus: (root.focusArea === 1 && root.indexApp === icon.visualIndex)? true:false

                        //khi focus thay doi thi gan lai bien appUrl va luu lai vi tri cua cac app vao file xml
                        onFocusChanged: {
                            if(focus){
                                root.appUrl = model.url
                            }
                        }
                    }

                    Drag.active: app.drag.active
                    Drag.keys: "AppButton"

                    states: [
                        State {
                            when: icon.Drag.active
                            ParentChange {
                                target: icon
                                parent: appv
                            }
                            AnchorChanges {
                                target: icon
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
        }

        ScrollBar.horizontal: ScrollBar {
            id: scrollBarId
            parent:appv
            anchors.bottom: appv.top
            anchors.left: appv.left
            anchors.right: appv.right
            snapMode: ScrollBar.SnapOnRelease
            stepSize: root.step
            active: appv.count > 6?true:false
            property int tmp:root.indexApp // bien trung gian ghi lai khi indexApp thay doi
            onTmpChanged: {
                if((root.indexApp % 6 == 0 && root.indexApp !=0) && increIndexApp == true){
                    scrollBarId.increase()
                }else if(root.indexApp == appv.count - 1 ){
                    for(var i = 0 ; i < tabview; i++){
                        scrollBarId.increase()
                    }
                }
                else if((appv.count -1 - root.indexApp)%6 == 0 && increIndexApp == false){
                    scrollBarId.decrease()
                }else if(root.indexApp == 0){
                    for(var j = 0 ; j < tabview; j++){
                        scrollBarId.decrease()
                    }
                }
            }
        }
    }
}

