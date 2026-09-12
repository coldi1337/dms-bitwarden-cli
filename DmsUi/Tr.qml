pragma Singleton

import QtQuick
import qs.Common

QtObject {
    function text(term) {
        return I18n.trFor("bitwarden", term || "", "bitwarden");
    }

    function format(term, ...values) {
        return text(term).replace(/%([1-9][0-9]*)/g, (match, index) => {
            const value = values[Number(index) - 1];
            return value === undefined ? match : String(value);
        });
    }
}
