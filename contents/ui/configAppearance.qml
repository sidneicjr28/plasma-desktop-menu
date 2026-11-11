import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.kquickcontrols as KQuickControls

KCM.SimpleKCM {
    property alias cfg_itemSpacing: itemSpacing.value
    property alias cfg_topMargin: topMargin.value
    property alias cfg_bottomMargin: bottomMargin.value
    property string cfg_fontFamily
    property alias cfg_fontSize: fontSize.value
    property alias cfg_useCustomTextColor: useCustomTextColor.checked
    property color cfg_textColor
    property alias cfg_showLabel: showLabel.checked
    property alias cfg_labelText: labelText.text
    property alias cfg_labelBold: labelBold.checked
    property alias cfg_labelItalic: labelItalic.checked
    property alias cfg_labelFontSize: labelFontSize.value
    property alias cfg_useCustomLabelColor: useCustomLabelColor.checked
    property color cfg_labelColor

    // 0 means "use the theme's size"
    component SizeSpinBox: QQC2.SpinBox {
        from: 0; to: 72
        textFromValue: (v) => v === 0 ? "Default" : v + " pt"
        valueFromText: (t) => t === "Default" ? 0 : parseInt(t) || 0
    }

    component PixelSpinBox: QQC2.SpinBox {
        from: 0; to: 64
        textFromValue: (v) => v + " px"
        valueFromText: (t) => parseInt(t) || 0
    }

    function resetDefaults() {
        cfg_itemSpacing = 8
        cfg_topMargin = 0
        cfg_bottomMargin = 0
        cfg_fontFamily = ""
        cfg_fontSize = 0
        cfg_useCustomTextColor = false
        cfg_textColor = "#ffffff"
        cfg_showLabel = true
        cfg_labelText = "Desktop"
        cfg_labelBold = true
        cfg_labelItalic = false
        cfg_labelFontSize = 0
        cfg_useCustomLabelColor = false
        cfg_labelColor = "#ffffff"
        // user interaction may have broken these bindings
        fontCombo.currentIndex = 0
        textColorButton.color = cfg_textColor
        labelColorButton.color = cfg_labelColor
    }

    Kirigami.FormLayout {
        PixelSpinBox {
            id: itemSpacing
            Kirigami.FormData.label: "Gap between items:"
        }
        // Top pushes the items down, bottom pushes them up
        PixelSpinBox {
            id: topMargin
            Kirigami.FormData.label: "Top margin:"
        }
        PixelSpinBox {
            id: bottomMargin
            Kirigami.FormData.label: "Bottom margin:"
        }

        Item { Kirigami.FormData.isSection: true; Kirigami.FormData.label: "Menu Font" }

        QQC2.ComboBox {
            id: fontCombo
            Kirigami.FormData.label: "Font:"
            model: ["Default"].concat(Qt.fontFamilies())
            currentIndex: cfg_fontFamily ? Math.max(0, model.indexOf(cfg_fontFamily)) : 0
            onActivated: (i) => cfg_fontFamily = i === 0 ? "" : model[i]
        }
        SizeSpinBox {
            id: fontSize
            Kirigami.FormData.label: "Size:"
        }
        RowLayout {
            Kirigami.FormData.label: "Color:"
            QQC2.CheckBox { id: useCustomTextColor; text: "Custom" }
            KQuickControls.ColorButton {
                id: textColorButton
                enabled: useCustomTextColor.checked
                color: cfg_textColor
                onAccepted: (c) => cfg_textColor = c
            }
        }

        Item { Kirigami.FormData.isSection: true; Kirigami.FormData.label: "Label" }

        QQC2.CheckBox {
            id: showLabel
            Kirigami.FormData.label: "Show label:"
        }
        QQC2.TextField {
            id: labelText
            Kirigami.FormData.label: "Text:"
            enabled: showLabel.checked
            placeholderText: "Desktop"
        }
        RowLayout {
            Kirigami.FormData.label: "Style:"
            enabled: showLabel.checked
            QQC2.CheckBox { id: labelBold; text: "Bold" }
            QQC2.CheckBox { id: labelItalic; text: "Italic" }
        }
        SizeSpinBox {
            id: labelFontSize
            Kirigami.FormData.label: "Size:"
            enabled: showLabel.checked
        }
        RowLayout {
            Kirigami.FormData.label: "Color:"
            enabled: showLabel.checked
            QQC2.CheckBox { id: useCustomLabelColor; text: "Custom" }
            KQuickControls.ColorButton {
                id: labelColorButton
                enabled: useCustomLabelColor.checked
                color: cfg_labelColor
                onAccepted: (c) => cfg_labelColor = c
            }
        }

        QQC2.Button {
            Kirigami.FormData.isSection: true
            text: "Restore Defaults"
            icon.name: "edit-undo"
            onClicked: resetDefaults()
        }
    }
}
