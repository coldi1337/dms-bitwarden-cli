const fs = require("node:fs");

// Existing source-contract checks use English labels as anchors. Unwrap only
// literal translation calls so those checks still inspect the same controls.
// Translation behavior and German geometry have separate runtime tests.
module.exports = function readEnglishQml(file) {
    return fs.readFileSync(file, "utf8")
        .replace(/\bTr\.text\(("(?:\\.|[^"\\])*")\)/g, "$1");
};
