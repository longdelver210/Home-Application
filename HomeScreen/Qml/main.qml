import QtQuick 2.14
import QtQuick.Window 2.0
import QtQuick.Controls 2.4

ApplicationWindow {
    id: window
    visible: true
    width: 1920
    height: 1080
    visibility: "FullScreen"

    Image {
        id: background
        width: 1920
        height: 1080
        source: "qrc:/Img/bg_full.png"
    }

    StatusBar {
        id: statusBar
        onBntBackClicked: stackView.pop()
        isShowBackBtn: stackView.depth == 1 ? false : true
    }

    StackView {
        id: stackView
        width: 1920
        height: 986
        anchors.top: statusBar.bottom
        initialItem: HomeWidget{
            id:home
        }
        onCurrentItemChanged: {
            currentItem.forceActiveFocus()
        }
        pushExit: Transition {
            XAnimator {
                from: 0
                to: -1920
                duration: 200
                easing.type: Easing.OutCubic
            }
        }


        Keys.onPressed: {
            if(event.key === Qt.Key_Backspace){
                if(statusBar.isShowBackBtn === true)
                    statusBar.bntBackClicked()
            }else{
                home.handleHardkey(event)
            }
        }

    }


}
