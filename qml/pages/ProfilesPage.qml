import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {

    id: dialog
    allowedOrientations : Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        Column {
            id: column

            width: parent.width
            spacing: Theme.paddingLarge
            anchors.margins: Theme.horizontalPageMargin

            DialogHeader {
                title: qsTr("Profiles")
            }

            Label {
                text: qsTr("OSM Scout Server uses profiles to simplify the selection " +
                           "of backends and the sets of downloaded databases."
                           )
                x: Theme.horizontalPageMargin
                width: parent.width-2*x
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.highlightColor
            }

            ComboBox {
                id: profileSelection
                label: qsTr("Profile")

                menu: ContextMenu {
                    MenuItem { text: qsTr("Default") }
                    MenuItem { text: qsTr("<i>libosmscout</i> with <i>Geocoder-NLP</i>") }
                    MenuItem { text: qsTr("<i>libosmscout</i>") }
                    MenuItem { text: qsTr("Custom") }
                }

                Component.onCompleted: {
                    currentIndex = settings.valueInt(settingsGeneralPrefix + "profile")
                }
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width-2*x
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor

                text: qsTr("Default profile uses <i>Mapnik</i> to render maps, <i>Geocoder-NLP</i> to search for locations "+
                           "and <i>Valhalla</i> to calculate the routes. " +
                           "This profile is a recommended one.<br><br>" +

                           "Profile where <i>libosmscout</i> is combined with <i>Geocoder-NLP</i> " +
                           "has smaller storage requirements when compared with the default one. " +
                           "However, rendering of the maps and routing would be limited only to one territory. " +
                           "In addition, rendering quality is inferior and routing speed is slower when " +
                           "compared with the default profile.<br><br>" +

                           "<i>libosmscout</i> profile has the smallest storage requirements among all profiles. " +
                           "However, rendering of the maps and routing would be limited only to one territory in the " +
                           "implementation used by the server. In addition, rendering quality and search is inferior as well as " +
                           "routing speed is slower when " +
                           "compared with the default profile.<br><br>" +

                           "When using Custom profile, Settings and Map Manager Storage are not set by profiles " +
                           "and should be specified by user. " +
                           "This profile allows to select rendering, search, and routing components individually. Note that " +
                           "the user is responsible for adjusting the settings to make them consistent between requirements of " +
                           "the used backends and storage." )
            }
        }

        VerticalScrollDecorator {}
    }

    onAccepted: {
        settings.setValue(settingsGeneralPrefix + "profile", profileSelection.currentIndex)
    }
}
