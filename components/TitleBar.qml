// Copyright (c) 2020, The Monero Project, 2020 The Electroneum Project
// Copyright (c) 2014-2018, The Monero Project
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import QtQuick 2.9
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.2

import FontAwesome 1.0
import "." as ElectroneumComponents
import "effects/" as ElectroneumEffects

Rectangle {
    id: root
    property int mouseX: 0
    property bool basicButtonVisible: false
    property bool customDecorations: persistentSettings.customDecorations
    property bool showMinimizeButton: true
    property bool showMaximizeButton: true
    property bool showCloseButton: true

    height: {
        if(!persistentSettings.customDecorations || isMobile) return 0;
        return 50;
    }

    z: 1
    color: "transparent"

    signal closeClicked
    signal maximizeClicked
    signal minimizeClicked
    signal languageClicked
    signal goToBasicVersion(bool yes)

    state: "default"
    states: [
        State {
            name: "default";
            PropertyChanges { target: btnSidebarCollapse; visible: true}
            PropertyChanges { target: btnLanguageToggle; visible: true}
        }, State {
            // show only theme switcher and window controls
            name: "essentials";
            PropertyChanges { target: btnSidebarCollapse; visible: false}
            PropertyChanges { target: btnLanguageToggle; visible: false}
        }
    ]

    ElectroneumEffects.GradientBackground {
        anchors.fill: parent
        duration: 300
        fallBackColor: ElectroneumComponents.Style.middlePanelBackgroundColor
        initialStartColor: ElectroneumComponents.Style.titleBarBackgroundGradientStart
        initialStopColor: ElectroneumComponents.Style.titleBarBackgroundGradientStop
        blackColorStart: ElectroneumComponents.Style._b_titleBarBackgroundGradientStart
        blackColorStop: ElectroneumComponents.Style._b_titleBarBackgroundGradientStop
        whiteColorStart: ElectroneumComponents.Style._w_titleBarBackgroundGradientStart
        whiteColorStop: ElectroneumComponents.Style._w_titleBarBackgroundGradientStop
        start: Qt.point(width, 0)
        end: Qt.point(0, 0)
    }

    RowLayout {
        z: parent.z + 2
        spacing: 0
        anchors.fill: parent

        // collapse sidebar
        Rectangle {
            id: btnSidebarCollapse
            visible: root.basicButtonVisible
            color: "transparent"
            Layout.preferredWidth: parent.height
            Layout.preferredHeight: parent.height

            ElectroneumEffects.ImageMask {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                height: 14
                width: 14
                image: ElectroneumComponents.Style.titleBarExpandSource
                color: ElectroneumComponents.Style.defaultFontColor
                fontAwesomeFallbackIcon: FontAwesome.cube
                fontAwesomeFallbackSize: 14
                fontAwesomeFallbackOpacity: ElectroneumComponents.Style.blackTheme ? 1.0 : 0.9
                opacity: 0.75
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: parent.color = ElectroneumComponents.Style.titleBarButtonHoverColor
                onExited: parent.color = "transparent"
                onClicked: root.goToBasicVersion(leftPanel.visible)
            }
        }

        // language selection
        Rectangle {
            id: btnLanguageToggle
            color: "transparent"
            Layout.preferredWidth: parent.height
            Layout.preferredHeight: parent.height

            Text {
                text: FontAwesome.globe
                font.family: FontAwesome.fontFamily
                font.pixelSize: 16
                color: ElectroneumComponents.Style.defaultFontColor
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: 0.75
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: parent.color = ElectroneumComponents.Style.titleBarButtonHoverColor
                onExited: parent.color = "transparent"
                onClicked: root.languageClicked()
            }
        }

        // switch theme
        Rectangle {
            color: "transparent"
            Layout.preferredWidth: parent.height
            Layout.preferredHeight: parent.height

            Text {
                text: ElectroneumComponents.Style.blackTheme ? FontAwesome.lightbulbO : FontAwesome.moonO
                font.family: FontAwesome.fontFamily
                font.pixelSize: 16
                color: ElectroneumComponents.Style.defaultFontColor
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: 0.75
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: parent.color = ElectroneumComponents.Style.titleBarButtonHoverColor
                onExited: parent.color = "transparent"
                onClicked: {
                    ElectroneumComponents.Style.blackTheme = !ElectroneumComponents.Style.blackTheme;
                    persistentSettings.blackTheme = ElectroneumComponents.Style.blackTheme;
                }
            }
        }

        Item {
            // make dummy space when hiding buttons when titlebar
            // state is 'essentials' in order for the
            // electroneum logo to still be centered
            Layout.preferredWidth: parent.height * 2  // amount of buttons we hide
            Layout.preferredHeight: parent.height
            visible: root.state == "essentials"
        }

        // electroneum logo
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height

            Image {
                id: imgLogo
                width: 125
                height: 28

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                source: ElectroneumComponents.Style.titleBarLogoSource
                visible: {
                    if(!isOpenGL) return true;
                    if(!ElectroneumComponents.Style.blackTheme) return true;
                    return false;
                }
            }

            Colorize {
                visible: isOpenGL && ElectroneumComponents.Style.blackTheme
                anchors.fill: imgLogo
                source: imgLogo
                saturation: 0.0
            }
        }

        // minimize
        Rectangle {
            color: "transparent"
            visible: root.showMinimizeButton
            Layout.preferredWidth: parent.height
            Layout.preferredHeight: parent.height

            ElectroneumEffects.ImageMask {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 18
                anchors.horizontalCenter: parent.horizontalCenter
                height: 3
                width: 15
                image: ElectroneumComponents.Style.titleBarMinimizeSource
                color: ElectroneumComponents.Style.defaultFontColor
                fontAwesomeFallbackIcon: FontAwesome.minus
                fontAwesomeFallbackSize: 18
                fontAwesomeFallbackOpacity: ElectroneumComponents.Style.blackTheme ? 0.8 : 0.6
                opacity: 0.75
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: parent.color = ElectroneumComponents.Style.titleBarButtonHoverColor
                onExited: parent.color = "transparent"
                onClicked: root.minimizeClicked();
            }
        }

        // maximize
        Rectangle {
            id: test
            visible: root.showMaximizeButton
            color: "transparent"
            Layout.preferredWidth: parent.height
            Layout.preferredHeight: parent.height

            Image {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: ElectroneumComponents.Style.titleBarFullscreenSource
                sourceSize.width: 16
                sourceSize.height: 16
                smooth: true
                mipmap: true
                opacity: 0.75
                rotation: appWindow.visibility === Window.FullScreen ? 180 : 0
            }

            MouseArea {
                id: buttonArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: parent.color = ElectroneumComponents.Style.titleBarButtonHoverColor
                onExited: parent.color = "transparent"
                onClicked: root.maximizeClicked();
            }
        }

        // close
        Rectangle {
            visible: root.showCloseButton
            color: "transparent"
            Layout.preferredWidth: parent.height
            Layout.preferredHeight: parent.height

            ElectroneumEffects.ImageMask {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                height: 16
                width: 16
                image: ElectroneumComponents.Style.titleBarCloseSource
                color: ElectroneumComponents.Style.defaultFontColor
                fontAwesomeFallbackIcon: FontAwesome.timesRectangle
                fontAwesomeFallbackSize: 18
                fontAwesomeFallbackOpacity: ElectroneumComponents.Style.blackTheme ? 0.8 : 0.6
                opacity: 0.75
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: parent.color = ElectroneumComponents.Style.titleBarButtonHoverColor
                onExited: parent.color = "transparent"
                onClicked: root.closeClicked();
            }
        }
    }

    Rectangle {
        z: parent.z + 3
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: ElectroneumComponents.Style.blackTheme ? 1 : 1
        color: ElectroneumComponents.Style.titleBarBackgroundBorderColor

        ElectroneumEffects.ColorTransition {
            targetObj: parent
            blackColor: ElectroneumComponents.Style._b_titleBarBackgroundBorderColor
            whiteColor: ElectroneumComponents.Style._w_titleBarBackgroundBorderColor
        }
    }

    MouseArea {
        enabled: persistentSettings.customDecorations
        property var previousPosition
        anchors.fill: parent
        propagateComposedEvents: true
        onPressed: previousPosition = globalCursor.getPosition()
        onPositionChanged: {
            if (pressedButtons == Qt.LeftButton) {
                var pos = globalCursor.getPosition()
                var dx = pos.x - previousPosition.x
                var dy = pos.y - previousPosition.y

                appWindow.x += dx
                appWindow.y += dy
                previousPosition = pos
            }
        }
    }
}
