import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PC3
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasma5support as P5Support
import org.kde.taskmanager as TaskManager

PlasmoidItem {
    id: root
    readonly property bool desktopFocused: !tasksModel.activeTask.valid

    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    TaskManager.TasksModel { id: tasksModel; groupMode: TaskManager.TasksModel.GroupDisabled }

    P5Support.DataSource {
        id: exec
        engine: "executable"
        onNewData: (source) => disconnectSource(source)
    }
    function run(cmd) { exec.connectSource(cmd) }

    // [title, [[label, icon, command] | null (separator)]]
    readonly property var menus: [
        ["File", [
            ["New File Manager Window", "system-file-manager", "dolphin"],
            ["New Terminal", "utilities-terminal", "konsole"],
            ["New Text File", "kwrite", "kwrite"]]],
        ["View", [
            ["Overview", "view-grid", "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut Overview"],
            ["Show Desktop", "user-desktop", "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut 'Show Desktop'"],
            null,
            ["Take Screenshot", "spectacle", "spectacle"],
            null,
            ["About Desktop Menu", "help-about", "@about"]]],
        ["Go", [
            ["Home", "user-home", "dolphin ~"],
            ["Desktop", "user-desktop", "dolphin ~/Desktop"],
            ["Documents", "folder-documents", "dolphin ~/Documents"],
            ["Downloads", "folder-downloads", "dolphin ~/Downloads"],
            ["Pictures", "folder-pictures", "dolphin ~/Pictures"],
            null,
            ["Computer", "computer", "dolphin /"],
            ["Trash", "user-trash", "dolphin trash:/"]]],
        ["System", [
            ["System Settings", "preferences-system", "systemsettings"],
            ["System Monitor", "utilities-system-monitor", "plasma-systemmonitor"],
            null,
            ["Lock Screen", "system-lock-screen", "loginctl lock-session"],
            ["Log Out…", "system-log-out", "qdbus6 org.kde.LogoutPrompt /LogoutPrompt promptLogout"],
            ["Restart…", "system-reboot", "qdbus6 org.kde.LogoutPrompt /LogoutPrompt promptReboot"],
            ["Shut Down…", "system-shutdown", "qdbus6 org.kde.LogoutPrompt /LogoutPrompt promptShutDown"]]]
    ]

    fullRepresentation: RowLayout {
        spacing: 8
        visible: root.desktopFocused
        Layout.preferredWidth: root.desktopFocused ? implicitWidth : 0
        Layout.minimumWidth: Layout.preferredWidth
        Layout.maximumWidth: Layout.preferredWidth

        PC3.Label {
            text: "Desktop"
            font.bold: true
            Layout.leftMargin: 6
            Layout.rightMargin: 6
        }

        Repeater {
            model: root.menus
            PC3.ToolButton {
                id: btn
                text: modelData[0]
                down: menu.status === PlasmaExtras.Menu.Open
                onPressed: menu.openRelative()

                PlasmaExtras.Menu {
                    id: menu
                    visualParent: btn
                    placement: PlasmaExtras.Menu.BottomPosedLeftAlignedPopup
                }
                Component.onCompleted: {
                    for (const it of modelData[1]) {
                        const mi = menuItem.createObject(menu, it ? { text: it[0], icon: it[1], cmd: it[2] } : { separator: true })
                        menu.addMenuItem(mi)
                    }
                }
            }
        }

        PC3.ToolButton {
            text: "Search"
            onClicked: root.run("qdbus6 org.kde.krunner /App display")
        }
    }

    Component {
        id: menuItem
        PlasmaExtras.MenuItem {
            property string cmd
            onClicked: cmd === "@about" ? aboutWindow.showNormal() : root.run(cmd)
        }
    }

    readonly property string githubUser: "sidneicjr28"

    Window {
        id: aboutWindow
        title: "About Desktop Menu"
        flags: Qt.Dialog
        readonly property int fixedHeight: aboutLayout.implicitHeight + 2 * Kirigami.Units.gridUnit
        width: 360
        height: fixedHeight
        minimumWidth: 360; maximumWidth: 360
        minimumHeight: fixedHeight; maximumHeight: fixedHeight
        color: Kirigami.Theme.backgroundColor

        ColumnLayout {
            id: aboutLayout
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Kirigami.Units.gridUnit
            spacing: Kirigami.Units.smallSpacing

            Kirigami.Icon {
                source: Plasmoid.metaData.iconName
                Layout.preferredWidth: Kirigami.Units.iconSizes.huge
                Layout.preferredHeight: Kirigami.Units.iconSizes.huge
                Layout.alignment: Qt.AlignHCenter
            }
            Kirigami.Heading {
                text: Plasmoid.metaData.name
                Layout.alignment: Qt.AlignHCenter
            }
            QQC2.Label {
                text: "Version " + Plasmoid.metaData.version
                opacity: 0.7
                Layout.alignment: Qt.AlignHCenter
            }
            QQC2.Label {
                text: Plasmoid.metaData.description
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                Layout.topMargin: Kirigami.Units.smallSpacing
            }
            QQC2.Label {
                text: "Made by <a href=\"https://github.com/%1\">@%1</a>".arg(root.githubUser)
                textFormat: Text.StyledText
                onLinkActivated: (link) => Qt.openUrlExternally(link)
                HoverHandler { cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor }
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Kirigami.Units.smallSpacing
            }
            QQC2.Label {
                text: "License: " + Plasmoid.metaData.license
                opacity: 0.7
                Layout.alignment: Qt.AlignHCenter
            }
            QQC2.Button {
                text: "Close"
                icon.name: "dialog-close"
                onClicked: aboutWindow.close()
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Kirigami.Units.smallSpacing
            }
        }
    }
}
