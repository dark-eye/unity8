AbstractButton { 
                id: root; 
                property var template; 
                property var components; 
                property var cardData; 
                property var artShapeBorderSource: undefined; 
                property real fontScale: 1.0; 
                property color foregroundColor: "grey";
                property int headerAlignment: Text.AlignLeft;
                property int fixedHeaderHeight: -1; 
                property size fixedArtShapeSize: Qt.size(-1, -1); 
                readonly property string title: cardData && cardData["title"] || ""; 
                property bool asynchronous: true; 
                property bool showHeader: true; 
                implicitWidth: childrenRect.width; 
readonly property size artShapeSize: Qt.size(-1, -1);
readonly property int headerHeight: row.height;
Row { 
                    id: row; 
                    objectName: "outerRow"; 
                    property real margins: units.gu(1); 
                    spacing: margins; 
                    height: root.fixedHeaderHeight != -1 ? root.fixedHeaderHeight : implicitHeight;
                    anchors { top: parent.top; 
                                     topMargin: units.gu(1);
                    left: parent.left;
}
                    anchors.right: parent.right; 
                    anchors.margins: margins;
data: [ Loader { 
                        id: mascotShapeLoader; 
                        objectName: "mascotShapeLoader"; 
                        asynchronous: root.asynchronous; 
                        active: mascotImage.status === Image.Ready; 
                        visible: showHeader && active && status == Loader.Ready; 
                        width: units.gu(6); 
                        height: units.gu(5.625); 
                        sourceComponent: UbuntuShape { image: mascotImage } 
                        anchors { verticalCenter: parent.verticalCenter; }
                    }

,
Image { 
                    id: mascotImage; 
                    objectName: "mascotImage"; 
                    anchors { verticalCenter: parent.verticalCenter; }
                    readonly property int maxSize: Math.max(width, height) * 4; 
                    source: cardData && cardData["mascot"]; 
                    width: units.gu(6); 
                    height: units.gu(5.625); 
                    sourceSize { width: maxSize; height: maxSize } 
                    fillMode: Image.PreserveAspectCrop; 
                    horizontalAlignment: Image.AlignHCenter; 
                    verticalAlignment: Image.AlignVCenter; 
                    visible: false; 
                }

,
Column { 
                        anchors.verticalCenter: parent.verticalCenter; 
                        spacing: units.dp(2); 
                        width: parent.width - x;
data: [ Label { 
                    id: titleLabel; 
                    objectName: "titleLabel"; 
                    anchors { left: parent.left; right: parent.right }
                    elide: Text.ElideRight; 
                    fontSize: "small"; 
                    wrapMode: Text.Wrap; 
                    maximumLineCount: 2; 
                    font.pixelSize: Math.round(FontUtils.sizeToPixels(fontSize) * fontScale); 
                    color: root.foregroundColor;
                    visible: showHeader ; 
                    text: root.title; 
                    font.weight: components && components["subtitle"] ? Font.DemiBold : Font.Normal; 
                    horizontalAlignment: root.headerAlignment; 
                }
,
Label { 
                        id: subtitleLabel; 
                        objectName: "subtitleLabel"; 
                        anchors { left: parent.left; right: parent.right }

                        elide: Text.ElideRight; 
                        fontSize: "small"; 
                        font.pixelSize: Math.round(FontUtils.sizeToPixels(fontSize) * fontScale); 
                        color: root.foregroundColor;
                        visible: titleLabel.visible && titleLabel.text; 
                        text: cardData && cardData["subtitle"] || ""; 
                        font.weight: Font.Light; 
                        horizontalAlignment: root.headerAlignment; 
                    }
]
}
]
}
implicitHeight: row.y + row.height + units.gu(1);
}
