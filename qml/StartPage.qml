/*
 * Copyright (C) 2016-2019 Rinigus https://github.com/rinigus
 *                    2019 Purism SPC
 *
 * This file is part of OSM Scout Server.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import "."
import "platform"

PagePL {
    id: rootPage
    title: qsTr("OSM Scout Server")

    Column {
        id: column

        width: rootPage.width
        spacing: styler.themePaddingLarge

        //////////////////////////////////////////////////////////////////////////////////
        //// Check for installed modules
        Column {
            id: modulesNotAvailable
            width: rootPage.width
            spacing: styler.themePaddingLarge

            property string dname: ""

            SectionHeaderPL {
                text: qsTr("Missing modules")
            }

            LabelPL {
                id: noModuleText
                x: styler.themeHorizontalPageMargin
                width: parent.width-2*x
                wrapMode: Text.WordWrap
                color: styler.themeHighlightColor
            }

            Connections {
                target: modules
                onModulesChanged: modulesNotAvailable.checkModules()
            }

            Rectangle { // just extra space to highlight the message
                height: styler.themePaddingLarge*3
                width: parent.width
                color: "transparent"
            }

            Component.onCompleted: checkModules()

            function checkModules() {
                modulesNotAvailable.visible = ( !modules.fonts || !modules.valhallaRoute )
                noModuleText.text =
                        qsTr("<i>OSM Scout Server</i> uses several modules that have to be installed separately " +
                             "for full functionality.<br><br>Your device is missing the following module(s) " +
                             "that are required by the current profile:<ul>")

                if (!modules.fonts)
                    noModuleText.text += qsTr("<li>OSM Scout Server Module: Fonts</li>")
                if (!modules.valhallaRoute)
                    noModuleText.text += qsTr("<li>OSM Scout Server Module: Route</li>")

                noModuleText.text += qsTr("</ul><br>Please install missing modules via Harbour or OpenRepos. " +
                                          "After installation of the module(s), please restart OSM Scout Server.")
            }
        }


        //////////////////////////////////////////////////////////////////////////////////
        //// Welcome messages for new users

        Column {
            id: storageNotAvailable
            width: rootPage.width
            spacing: styler.themePaddingLarge

            property string dname: ""

            SectionHeaderPL {
                text: qsTr("Welcome")
            }

            LabelPL {
                id: notAvailableText
                x: styler.themeHorizontalPageMargin
                width: parent.width-2*x
                wrapMode: Text.WordWrap
                color: styler.themeHighlightColor
            }

            ButtonPL {
                text: qsTr("Create default directory")
                preferredWidth: styler.themeButtonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    if (manager.createDirectory(storageNotAvailable.dname)) {
                        settings.setValue(settingsMapManagerPrefix + "root", storageNotAvailable.dname)
                        mainFlickable.scrollToTop()
                    }
                }
            }

            LabelPL {
                id: notAvailableDirCreation
                x: styler.themeHorizontalPageMargin
                width: parent.width-2*x
                wrapMode: Text.WordWrap
                font.pixelSize: styler.themeFontSizeSmall
                color: styler.themeHighlightColor
            }

            Connections {
                target: manager
                onStorageAvailableChanged: storageNotAvailable.visible = !(manager.storageAvailable)
            }

            Component.onCompleted: {
                storageNotAvailable.visible = !(manager.storageAvailable)
                dname = manager.defaultStorageDirectory()
                notAvailableDirCreation.text = qsTr("Creates directory<br>%1<br>and configures it for storing maps").arg(dname)
                notAvailableText.text =
                        qsTr("<i>OSM Scout Server</i> is expected to be used with the " +
                             "downloaded maps. To manage the maps, the Server requires a separate " +
                             "folder. The files within that folder should be managed by the Server only. " +
                             "This includes deleting all files within that folder when requested by you during cleanup or " +
                             "map updates.<br><br>" +
                             "Please <b>allocate separate, empty folder</b> for OSM Scout Server. " +
                             "For that, create a new folder in a file manager or using command line and then select this folder " +
                             "in <i>Settings</i> (pulley menu).<br><br>" +
                             "Alternatively, the directory can be created and setup automatically at <br>" +
                             "%1<br>by pressing a button below").arg(dname)

            }
        }

        Column {
            id: noSubscriptions
            width: rootPage.width
            spacing: styler.themePaddingLarge

            SectionHeaderPL {
                text: qsTr("Welcome")
            }

            LabelPL {
                text: qsTr("With the storage folder selected and available, the next step is to get some maps. " +
                           "For that, you can select and download maps using <i>Map Manager</i>  (pulley menu).")
                x: styler.themeHorizontalPageMargin
                width: parent.width-2*x
                wrapMode: Text.WordWrap
                color: styler.themeHighlightColor
            }

            Rectangle { // just extra space to highlight the message
                height: styler.themePaddingLarge*3
                width: parent.width
                color: "transparent"
            }

            Connections {
                target: manager
                onSubscriptionChanged: noSubscriptions.checkVisible()
                onStorageAvailableChanged: noSubscriptions.checkVisible()
                onAvailabilityChanged: noSubscriptions.checkVisible()
            }

            Component.onCompleted: noSubscriptions.checkVisible()

            function checkVisible() {
                noSubscriptions.visible = (manager.storageAvailable &&
                                           JSON.parse(manager.getRequestedCountries()).children.length === 0)
            }
        }

        Column {
            id: noMapsAvailable
            width: rootPage.width
            spacing: styler.themePaddingLarge

            SectionHeaderPL {
                text: qsTr("Welcome")
            }

            LabelPL {
                text: qsTr("There are no maps available yet. After subscribing them, you have to start downloads. " +
                           "Downloads can be started using <i>Map Manager</i>  (pulley menu).")
                x: styler.themeHorizontalPageMargin
                width: parent.width-2*x
                wrapMode: Text.WordWrap
                color: styler.themeHighlightColor
            }

            Rectangle { // just extra space to highlight the message
                height: styler.themePaddingLarge*3
                width: parent.width
                color: "transparent"
            }

            Connections {
                target: manager
                onSubscriptionChanged: noMapsAvailable.checkVisible()
                onDownloadingChanged: noMapsAvailable.checkVisible()
                onReadyChanged: noMapsAvailable.checkVisible()
                onAvailabilityChanged: noMapsAvailable.checkVisible()
            }

            Component.onCompleted: noMapsAvailable.checkVisible()

            function checkVisible() {
                var subs = JSON.parse(manager.getRequestedCountries())
                var avail = JSON.parse(manager.getAvailableCountries())
                if (subs.children.length !== 0 &&
                        avail.countries.length === 0 &&
                        manager.ready)
                    noMapsAvailable.visible = true
                else
                    noMapsAvailable.visible = false
            }
        }

        //// Welcome messages: done
        //////////////////////////////////////////////////////////////////////////////////

        //////////////////////////////////////////////////////////////////////////////////
        /// Warnings

        /// Warn if no language has been specified
        Column {
            id: noGeocoderLangSpecified
            width: rootPage.width
            spacing: styler.themePaddingLarge
            // that will be false when maps storage is not available
            visible: geocoder.warnLargeRamLangNotSpecified

            SectionHeaderPL {
                text: qsTr("Warning")
            }

            LabelPL {
                text: qsTr("You have not specified languages used for parsing addresses by Geocoder-NLP. " +
                           "As a result, all known languages are used and " +
                           "you could experience very large RAM consumption. Such large RAM usage could " +
                           "lead to the OSM Scout Server being killed by the kernel. <br><br>" +
                           "To specify languages used for address parsing, either select languages below or " +
                           "go to <i>Settings</i> (pulley menu) and " +
                           "select languages as a part of <i>Geocoder-NLP</i> settings.")
                x: styler.themeHorizontalPageMargin
                width: parent.width-2*x
                wrapMode: Text.WordWrap
                color: styler.themeHighlightColor
            }

            Rectangle { // just extra space to highlight the message
                height: styler.themePaddingLarge*3
                width: parent.width
                color: "transparent"
            }
        }

        /// Warnings: done
        //////////////////////////////////////////////////////////////////////////////////

        ComboBoxPL {
            id: mapSelection
            label: qsTr("Map")
            model: []
            visible: settings.countrySelectionNeeded && ncountries >= 1

            property int ncountries: 0
            property var countries: []

            Connections {
                target: manager
                onAvailabilityChanged: mapSelection.updateData()
            }

            onCurrentIndexChanged: {
                if (countries && countries[currentIndex])
                    settings.setValue(settingsMapManagerPrefix + "map_selected",
                                      countries[currentIndex].id)
            }

            Component.onCompleted: updateData()

            function updateData() {
                var ret = JSON.parse(manager.getAvailableCountries());
                mapSelection.countries = ret.countries;
                mapSelection.ncountries = mapSelection.countries.length;
                var names = [];
                for (var i=0; i < mapSelection.ncountries; ++i)
                    names.push(mapSelection.countries[i].name);
                mapSelection.model = names;
                mapSelection.currentIndex = ret.current;
            }
        }

        ElementLanguageSelector {
            id: eGeoLanguages
            key: settingsGeomasterPrefix + "languages"
            autoApply: true
            visible: manager.storageAvailable
        }

        SectionHeaderPL {
            text: qsTr("Status")
            visible: manager.storageAvailable
        }

        LabelPL {
            id: queueLength
            x: styler.themeHorizontalPageMargin
            width: parent.width-2*styler.themeHorizontalPageMargin
            color: styler.themeHighlightColor
            font.pixelSize: styler.themeFontSizeSmall
            visible: manager.storageAvailable

            text: ""

            Connections {
                target: infohub;
                onQueueChanged: {
                    queueLength.setText(queue)
                }
            }

            Component.onCompleted: queueLength.setText(infohub.queue)

            function setText(q) {
                if (q > 0) text = qsTr("Jobs in a queue") + ": " + q
                else text = qsTr("Idle")
            }
        }

        ElementDownloads {
            visible: manager.storageAvailable
        }

        SectionHeaderPL {
            text: qsTr("Events")
            visible: manager.storageAvailable
        }

        LabelPL {
            id: log
            x: styler.themeHorizontalPageMargin
            width: parent.width-2*styler.themeHorizontalPageMargin
            color: styler.themeHighlightColor
            font.pixelSize: styler.themeFontSizeSmall
            wrapMode: Text.Wrap
            visible: manager.storageAvailable

            text: ""

            Component.onCompleted: { setText() }
            Connections { target: logger; onLogChanged: log.setText() }

            function setText() {
                text = logger.log
            }
        }
    }


    Connections {
        target: manager

        onErrorMessage: {
            pageStack.completeAnimation()
            pageStack.push( Qt.resolvedUrl("MessagePage.qml"),
                           {"header": qsTr("Error"), "message": info} )
        }
    }

//    ///////////////////////////////////////////////////////////
//    /// welcome wizard
//    Component {
//        id: firstWelcomeWizardPage

//        Dialog {

//            acceptDestination: secondWelcomeWizardPage

//            SilicaFlickable {
//                anchors.fill: parent
//                contentHeight: column.height + styler.themePaddingLarge

//                Column {
//                    id: column
//                    width: parent.width

//                    DialogHeader {
//                        title: qsTr("Welcome")
//                        acceptText: qsTr("Next")
//                        cancelText: qsTr("Skip")
//                    }

//                    Label {
//                        text: qsTr("OSM Scout Server is a part of the solution allowing you to have offline maps on device. " +
//                                   "With this server, you could download the maps to your device and use the " +
//                                   "downloaded data to locally render maps, search for addresses and POIs, and " +
//                                   "calculate the routes. Such operations requires server and an additional client " +
//                                   "accessing the server to run simultaneously on the device.<br><br>" +
//                                   "This wizard will help you to select the backends used by the server and " +
//                                   "the specify languages for parsing your search requests.<br><br>" +
//                                   "Please choose 'Next' to start configuration."
//                                   )
//                        x: styler.themeHorizontalPageMargin
//                        width: parent.width-2*x
//                        wrapMode: Text.WordWrap
//                        color: styler.themeHighlightColor
//                    }
//                }

//                VerticalScrollDecorator {}
//            }
//        }

//        Component {
//            id: secondWelcomeWizardPage

//            ProfilesPage {
//                acceptDestination: thirdWelcomeWizardPage
//            }
//        }

//        Component {
//            id: thirdWelcomeWizardPage

//            LanguageSelector {
//                acceptDestination: fourthWelcomeWizardPage

//                value: eGeoLanguages.value
//                callback: eGeoLanguages.setValue
//                title: eGeoLanguages.mainLabel
//                comment: eGeoLanguages.selectorComment
//                note: eGeoLanguages.selectorNote
//            }
//        }

//        Component {
//            id: fourthWelcomeWizardPage

//            SystemdActivationPage {
//                acceptDestination: rootPage
//                acceptDestinationAction: PageStackAction.Pop
//            }
//        }

//        function openWelcomeWizard()
//        {
//            if (status === PageStatus.Active)
//            {
//                rootPage.statusChanged.disconnect(openWelcomeWizard)
//                pageStack.push(firstWelcomeWizardPage)
//            }
//        }

//        function openSystemdActivation()
//        {
//            if (status === PageStatus.Active)
//            {
//                rootPage.statusChanged.disconnect(openSystemdActivation)
//                pageStack.push(fourthWelcomeWizardPage)
//            }
//        }

//        Component.onCompleted: {
//            if (settings.firstTime)
//                rootPage.statusChanged.connect(openWelcomeWizard)
//            else if (settings.lastRunVersion === 0)
//                rootPage.statusChanged.connect(openSystemdActivation)
//        }
//    }
}
