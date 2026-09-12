import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root
    readonly property var vault: PluginService.pluginDaemonInstances[pluginId] || null
    function prepareVaultAnchor() {
        if (!vault) return;
        const pos = mapToItem(null, 0, 0);
        const screen = parentScreen || Quickshell.screens[0];
        const edge = axis?.edge === "left" ? 2 : axis?.edge === "right" ? 3 : axis?.edge === "bottom" ? 1 : 0;
        const trigger = SettingsData.getPopupTriggerPosition(pos, screen, barThickness, width, barSpacing, edge, barConfig);
        vault.setAnchor(root, trigger.x, trigger.y, trigger.width, section, screen, edge, barThickness, barSpacing, barConfig);
    }
    pillClickAction: () => { if (vault) { prepareVaultAnchor(); vault.toggle(); } }
    pillRightClickAction: () => { if (vault) { if (vault.status === "unlocked") vault.lockVault(); else { prepareVaultAnchor(); vault.open(); } } }
    horizontalBarPill: Component {
        Item {
            implicitWidth: root.iconSize
            implicitHeight: root.widgetThickness
            DankIcon {
                anchors.centerIn: parent
                name: root.vault?.status === "unlocked" ? "shield" : "lock"
                size: root.iconSize
                color: root.vault?.colorizeIcon ? Theme.primary : Theme.widgetIconColor
            }
        }
    }
    verticalBarPill: Component {
        Item {
            implicitWidth: root.widgetThickness
            implicitHeight: root.iconSize
            DankIcon {
                anchors.centerIn: parent
                name: root.vault?.status === "unlocked" ? "shield" : "lock"
                size: root.iconSize
                color: root.vault?.colorizeIcon ? Theme.primary : Theme.widgetIconColor
            }
        }
    }
}
