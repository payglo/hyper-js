open Types

let loadPayglo = (str, option: option<Js.Json.t>) => {
  Js.Promise.make((~resolve, ~reject) => {
    let sessionID = generateSessionID()
    let timeStamp = Js.Date.now()
    let scriptURL = switch Types.getEnv(option) {
    | "SANDBOX" => "https://checkout.payglo.io/PaygloLoader.js"
    | "PROD" => "https://checkout.payglo.io/PaygloLoader.js"
    | _ =>
      str->Js.String2.startsWith("pk_prd_")
        ? "https://checkout.payglo.io/PaygloLoader.js"
        : "https://checkout.payglo.io/PaygloLoader.js"
    }
    let analyticsObj =
      [
        ("sessionID", sessionID->Js.Json.string),
        ("timeStamp", timeStamp->Belt.Float.toString->Js.Json.string),
      ]
      ->Js.Dict.fromArray
      ->Js.Json.object_
      if Window.querySelectorAll(`script[src="${scriptURL}"]`)->Js.Array2.length === 0 {
        let script = Window.createElement("script")
        script->Window.elementSrc(scriptURL)
        script->Window.elementOnload(() => {
          switch OrcaJs.paygloInstance->Js.Nullable.toOption {
          | Some(instance) => resolve(. instance(str, option, analyticsObj))
          | None => ()
          }
        })
        script->Window.elementOnerror(err => {
          reject(. err)
        })
        Window.body->Window.appendChild(script)
      } else {
        Js.Console.warn(
        `INTEGRATION WARNING: There is already an existing script tag for ${scriptURL}. Multiple additions of PaygloLoader.js is not permitted, please add it on the top level only once.`,
      )
        switch OrcaJs.paygloInstance->Js.Nullable.toOption {
          | Some(instance) => resolve(. instance(str, option, analyticsObj))
          | None => ()
          }
      }
  })
}

let loadStripe = (str, option) => {
  Js.Console.warn("loadStripe is deprecated. Please use loadPayglo instead.")
  loadPayglo(str, option)
}