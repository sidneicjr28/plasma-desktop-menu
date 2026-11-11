import QtQuick
import QtQuick.Layouts
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
            ["New Text File", "kwrite", "kwrite"],
            null,
            ["Search…", "search", "qdbus6 org.kde.krunner /App display"]]],
        ["View", [
            ["Overview", "view-grid", "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut Overview"],
            ["Show Desktop", "user-desktop", "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut 'Show Desktop'"],
            null,
            ["Take Screenshot", "spectacle", "spectacle"]]],
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
    }

    Component {
        id: menuItem
        PlasmaExtras.MenuItem {
            property string cmd
            onClicked: root.run(cmd)
        }
    }
}
