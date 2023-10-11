type window
type parent

type event = {data: Js.Json.t}
@val @scope("window")
external addEventListener: (string, _ => unit) => unit = "addEventListener"
@val @scope("window")
external removeEventListener: (string, 'ev => unit) => unit = "removeEventListener"

@val external window: window = "window"
@val @scope("window") external iframeParent: parent = "parent"

@val @scope("document")
external querySelector: string => Js.Nullable.t<Dom.element> = "querySelector"

@val @scope("document") external createElement: string => Dom.element = "createElement"

external eventToJson: event => Js.Json.t = "%identity"

@val @scope(("window", "location"))
external replace: string => unit = "replace"

type domElement
@send external postMessage: (domElement, string, string) => unit = "postMessage"

@get
external contentWindow: Dom.element => domElement = "contentWindow"

@set external innerHTML: (Dom.element, string) => unit = "innerHTML"
@set external elementSrc: (Dom.element, string) => unit = "src"
@val @scope("document")
external querySelectorAll: string => array<Dom.element> = "querySelectorAll"

type body

@val @scope("document")
external body: body = "body"

@send external appendChild: (body, Dom.element) => unit = "appendChild"

@set external elementOnload: (Dom.element, unit => unit) => unit = "onload"
@set external elementOnerror: (Dom.element, exn => unit) => unit = "onerror"

let iframePostMessage = (iframeRef: Js.nullable<Dom.element>, message: Js.Dict.t<Js.Json.t>) => {
  switch iframeRef->Js.Nullable.toOption {
  | Some(ref) => ref->contentWindow->postMessage(message->Js.Json.object_->Js.Json.stringify, "*")
  | None => Js.Console.error("This element does not exist or is not mounted yet.")
  }
}