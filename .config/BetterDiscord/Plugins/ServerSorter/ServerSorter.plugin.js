/**
 * @name ServerSorter
 * @version 0.4.3-final
 * @authorLink https://twitter.com/IAmZerebos
 * @donate https://paypal.me/ZackRauen
 * @patreon https://patreon.com/Zerebos
 * @website https://github.com/rauenzi/BetterDiscordAddons/tree/master/Plugins/ServerSorter
 * @source https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/ServerSorter/ServerSorter.plugin.js
 * @updateUrl https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/ServerSorter/ServerSorter.plugin.js
 */
/*@cc_on
@if (@_jscript)
	
	// Offer to self-install for clueless users that try to run this directly.
	var shell = WScript.CreateObject("WScript.Shell");
	var fs = new ActiveXObject("Scripting.FileSystemObject");
	var pathPlugins = shell.ExpandEnvironmentStrings("%APPDATA%\BetterDiscord\plugins");
	var pathSelf = WScript.ScriptFullName;
	// Put the user at ease by addressing them in the first person
	shell.Popup("It looks like you've mistakenly tried to run me directly. \n(Don't do that!)", 0, "I'm a plugin for BetterDiscord", 0x30);
	if (fs.GetParentFolderName(pathSelf) === fs.GetAbsolutePathName(pathPlugins)) {
		shell.Popup("I'm in the correct folder already.", 0, "I'm already installed", 0x40);
	} else if (!fs.FolderExists(pathPlugins)) {
		shell.Popup("I can't find the BetterDiscord plugins folder.\nAre you sure it's even installed?", 0, "Can't install myself", 0x10);
	} else if (shell.Popup("Should I copy myself to BetterDiscord's plugins folder for you?", 0, "Do you need some help?", 0x34) === 6) {
		fs.CopyFile(pathSelf, fs.BuildPath(pathPlugins, fs.GetFileName(pathSelf)), true);
		// Show the user where to put plugins in the future
		shell.Exec("explorer " + pathPlugins);
		shell.Popup("I'm installed!", 0, "Successfully installed", 0x40);
	}
	WScript.Quit();

@else@*/

module.exports = (() => {
    const config = {info:{name:"ServerSorter",authors:[{name:"Zerebos",discord_id:"249746236008169473",github_username:"rauenzi",twitter_username:"ZackRauen"}],version:"0.4.3-final",description:"Adds server sorting abilities to Discord.",github:"https://github.com/rauenzi/BetterDiscordAddons/tree/master/Plugins/ServerSorter",github_raw:"https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/ServerSorter/ServerSorter.plugin.js"},changelog:[{title:"What's Going On",items:["ServerSorter is going away.","The functionality will be absorbed into ServerSearch at some point."]}],main:"index.js"};

    return !global.ZeresPluginLibrary ? class {
        constructor() {this._config = config;}
        getName() {return config.info.name;}
        getAuthor() {return config.info.authors.map(a => a.name).join(", ");}
        getDescription() {return config.info.description;}
        getVersion() {return config.info.version;}
        load() {
            BdApi.showConfirmationModal("Library Missing", `The library plugin needed for ${config.info.name} is missing. Please click Download Now to install it.`, {
                confirmText: "Download Now",
                cancelText: "Cancel",
                onConfirm: () => {
                    require("request").get("https://rauenzi.github.io/BDPluginLibrary/release/0PluginLibrary.plugin.js", async (error, response, body) => {
                        if (error) return require("electron").shell.openExternal("https://betterdiscord.net/ghdl?url=https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js");
                        await new Promise(r => require("fs").writeFile(require("path").join(BdApi.Plugins.folder, "0PluginLibrary.plugin.js"), body, r));
                    });
                }
            });
        }
        start() {}
        stop() {}
    } : (([Plugin, Api]) => {
        const plugin = (Plugin, Api) => {
    const {Modals} = Api;

    return class ServerSorter extends Plugin {
        load() {
            Modals.showConfirmationModal(
                "ServerSorter Is Dead",
                "ServerSorter is going away.\n\nIt's become unrealistic to sort servers/guilds in the list with the new server folders.\n\nIf you do would miss the functionality of ServerSorter, do not worry, the functionality will be absorbed into [ServerSearch](https://github.com/rauenzi/BetterDiscordAddons/tree/master/Plugins/ServerSearch) at some point, so keep your eyes peeled for that.",
                {
                    danger: true,
                    confirmText: "Delete Now",
                    cancelText: "Delte Later",
                    onConfirm: function() {
                        const fs = require("fs");
                        const path = require("path");
                        const file = path.resolve(BdApi.Plugins.folder, "ServerSorter.plugin.js");
                        if (fs.existsSync(file)) {
                            fs.unlinkSync(file);
                            BdApi.showToast("Plugin deleted successfully", {type: "success"});
                        }
                        else {
                            Modals.showAlertModal("File Not Found", "Couldn't find the plugin file, please delete it manually!");
                        }
                    }
                }
            );
        }
    };
};
        return plugin(Plugin, Api);
    })(global.ZeresPluginLibrary.buildPlugin(config));
})();
/*@end@*/