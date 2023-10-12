// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Types from "./Types.bs.js";
import * as Js_dict from "rescript/lib/es6/js_dict.js";

function loadHyper(str, option) {
    return new Promise((function (resolve, reject) {
        var sessionID = Types.generateSessionID(undefined);
        var timeStamp = Date.now();
        var match = Types.getEnv(option);
        var scriptURL;
        switch (match) {
            case "PROD":
                scriptURL = "https://checkout.payglo.io/LiveHyperLoader.js";
                break;
            case "SANDBOX":
                scriptURL = "https://checkout.payglo.io/HyperLoader.js";
                break;
            default:
                scriptURL = str.startsWith("pk_prd_") ? "https://checkout.payglo.io/LiveHyperLoader.js" : "https://checkout.payglo.io/HyperLoader.js";
        }
        var analyticsObj = Js_dict.fromArray([
            [
                "sessionID",
                sessionID
            ],
            [
                "timeStamp",
                String(timeStamp)
            ]
        ]);
        if (document.querySelectorAll("script[src=\"" + scriptURL + "\"]").length === 0) {
            var script = document.createElement("script");
            script.src = scriptURL;
            script.onload = (function (param) {
                var instance = window.Hyper;
                if (!(instance == null)) {
                    return resolve(Curry._3(instance, str, option, analyticsObj));
                }

            });
            script.onerror = (function (err) {
                reject(err);
            });
            document.body.appendChild(script);
            return;
        }
        console.warn("INTEGRATION WARNING: There is already an existing script tag for " + scriptURL + ". Multiple additions of HyperLoader.js is not permitted, please add it on the top level only once.");
        var instance = window.Hyper;
        if (!(instance == null)) {
            return resolve(Curry._3(instance, str, option, analyticsObj));
        }

    }));
}

function loadStripe(str, option) {
    console.warn("loadStripe is deprecated. Please use loadHyper instead.");
    return loadHyper(str, option);
}

export {
    loadHyper,
    loadStripe,
}
/* Types Not a pure module */