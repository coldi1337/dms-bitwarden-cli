import QtQuick
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins
PluginSettings {
    pluginId: "bitwarden"
    DankButton {
        text: "Open Bitwarden settings"
        iconName: "settings"
        enabled: PluginService.pluginDaemonInstances["bitwarden"] !== undefined
        onClicked: {
            const vault = PluginService.pluginDaemonInstances["bitwarden"];
            if (vault) { vault.open(); vault.openSettings(); }
        }
    }
}
