import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2 as QQC

Rectangle {
    // Rectangle, since we do really want to cover all

    id: iconPicker

    signal iconChoosed(string iconName, string iconUtf)
    signal canceled()


    // TODO: Add microanimations

    color: "white" // TODO: Use color from Constants
    AppPaper {
        anchors {
            fill: parent
            margins: dp(Constants.defaultSpacing)
        }
        radius: dp(Constants.defaultSpacing)
        background.color: "white" // TODO: Use color from Constants
        clip: true

        SortFilterProxyModel {
            id: filteredModel
            sourceModel: IconTypeHelper.iconsModel
            filters: [
                RegExpFilter {
                    roleName: "iconText"
                    pattern: ".*" + searchBar.text
                    enabled: searchBar.text != ""
                    caseSensitivity: Qt.CaseInsensitive
                }]
        }

        Rectangle {
            anchors {
                fill: parent
                margins: 0.5 * dp(Constants.defaultPadding)
            }
            color: iconPicker.color

            ColumnLayout {
                anchors {
                    fill: parent
                }
                AppText {
                    text: qsTr("Find best icon:")
                    fontSize: Constants.fontSizeNormal
                    Layout.alignment: Qt.AlignHCenter
                }

                SearchBar {
                    id: searchBar
                    Layout.fillWidth: true
                }

                QQC.ScrollView {
                    clip: true
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    GridView {
                        id: grid
                        delegate: Item {
                            id: delegate
                            width: grid.cellWidth
                            height: grid.cellHeight
                            Column {
                                anchors.fill: parent
                                IconButton {
                                    icon: iconUtf
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    onClicked: {
                                        console.log("Choosed: ", iconUtf, " which is ", iconText)
                                        iconChoosed(iconText, iconUtf)
                                    }
                                }
                                AppText {
                                    text: iconText
                                    fontSize: Constants.fontSizeSmall
                                    width: delegate.width - dp(Constants.defaultSpacing)
                                    elide: Text.ElideRight
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }
                        model: filteredModel
                    }
                }

                AppButton {
                    text: qsTr("Cancel")
                    Layout.fillWidth: true
                    onClicked: {
                        console.log("Canceled")
                        canceled()
                    }
                }
            }
        }
    }
}

