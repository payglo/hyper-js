open Types

let loadHyper = (str, option: option<Js.Json.t>) => {
  Js.Promise.make((~resolve, ~reject) => {
    let sessionID = generateSessionID()
    let timeStamp = Js.Date.now()
    let scriptURL = switch Types.getEnv(option) {
    | "SANDBOX" => "http://localhost:3000/HyperLoader.js"
    | "PROD" => "../LiveHyperLoader.js"
    | _ =>
      str->Js.String2.startsWith("pk_prd_")
        ? "../LiveHyperLoader.js"
        : "http://localhost:3000/HyperLoader.js"
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
          switch OrcaJs.hyperInstance->Js.Nullable.toOption {
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
        `INTEGRATION WARNING: There is already an existing script tag for ${scriptURL}. Multiple additions of HyperLoader.js is not permitted, please add it on the top level only once.`,
      )
        switch OrcaJs.hyperInstance->Js.Nullable.toOption {
          | Some(instance) => resolve(. instance(str, option, analyticsObj))
          | None => ()
          }
      }
  })
}

let loadStripe = (str, option) => {
  Js.Console.warn("loadStripe is deprecated. Please use loadHyper instead.")
  loadHyper(str, option)
}