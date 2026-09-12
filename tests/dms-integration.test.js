const fs = require("node:fs");
const path = require("node:path");
const assert = require("node:assert/strict");
const { test } = require("node:test");
const source = fs.readFileSync(path.join(__dirname, "../Panel.qml"), "utf8");
const model = {};
new Function("exports", fs.readFileSync(path.join(__dirname, "../BitwardenModel.js"), "utf8")
    .replace(/^\.pragma library\s*$/m, "") + "\nexports.screenIsLocked = screenIsLocked;")(model);
const body = source.match(/function onScreenLockState\(raw\) \{([\s\S]*?)\n  \}/)[1];
const apply = new Function("root", "Model", "IdleService", "lockOnScreenLock", "status", "lockVault", "raw", body);

test("DMS immediately locks an unlocked vault even before the IPC lock poll catches up", () => {
    const root = {};
    let calls = 0;
    apply(root, model, {isShellLocked: true}, true, "unlocked", () => calls++, "false");
    assert.equal(calls, 1);
    assert.equal(root.screenIsLocked, true);
    assert.ok(root.screenLockCheckedAt > 0);
});
test("lock poll can independently revoke an unlocked vault", () => {
    let calls = 0;
    apply({}, model, {isShellLocked: false}, true, "unlocked", () => calls++, "true\n");
    assert.equal(calls, 1);
});
test("lock-state tracking remains active when automatic vault locking is disabled", () => {
    const root = {};
    apply(root, model, {isShellLocked: true}, false, "unlocked", () => assert.fail("unexpected lock"), "false");
    assert.equal(root.screenIsLocked, true);
});
test("missing lock IPC does not spuriously lock an unlocked desktop", () => {
    const root = {};
    apply(root, model, {isShellLocked: false}, true, "unlocked", () => assert.fail("unexpected lock"), "Target not found.");
    assert.equal(root.screenIsLocked, false);
});
