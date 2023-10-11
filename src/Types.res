type eventData = {
  iframeMounted: bool,
  focusTriggered: bool,
  blurTriggered: bool,
  clickTriggered: bool,
  elementType: string,
  classChange: bool,
  newClassType: string,
}
type event = {key: string, data: eventData}
type eventParam = Event(event) | EventData(eventData) | Empty
type eventHandler = eventParam => unit

module This = {
  type t
  @get
  external iframeElem: t => option<Js.nullable<Dom.element>> = "iframeElem"
}

type paymentElement = {
  on: (string, eventParam => unit) => unit,
  collapse: unit => unit,
  blur: unit => unit,
  update: Js.Json.t => unit,
  destroy: unit => unit,
  unmount: unit => unit,
  mount: string => unit,
  focus: unit => unit,
  clear: unit => unit,
}

type element = {
  getElement: Js.Dict.key => option<paymentElement>,
  update: Js.Json.t => unit,
  fetchUpdates: unit => Js.Promise.t<Js.Json.t>,
  create: (Js.Dict.key, Js.Json.t) => paymentElement,
}

type confirmParams = {return_url: string}

type confirmPaymentParams = {
  elements: Js.Json.t,
  confirmParams: Js.Nullable.t<confirmParams>,
}
type hyperInstance = {
  confirmPayment: Js.Json.t => Js.Promise.t<Js.Json.t>,
  elements: Js.Json.t => element,
  confirmCardPayment: Js_OO.Callback.arity4<
    (This.t, string, option<Js.Json.t>, option<Js.Json.t>) => Js.Promise.t<Js.Json.t>,
  >,
  retrievePaymentIntent: string => Js.Promise.t<Js.Json.t>,
  widgets: Js.Json.t => element,
  paymentRequest: Js.Json.t => Js.Json.t,
}
type hyperInstanceMake = (string, option<Js.Json.t>, Js.Json.t) => hyperInstance

let confirmPaymentFn = (_elements: Js.Json.t) => {
  Js.Promise.resolve(Js.Dict.empty()->Js.Json.object_)
}
let confirmCardPaymentFn =
  @this
  (
    _this: This.t,
    _clientSecretId: string,
    _data: option<Js.Json.t>,
    _options: option<Js.Json.t>,
  ) => {
    Js.Promise.resolve(Js.Dict.empty()->Js.Json.object_)
  }

let retrievePaymentIntentFn = _paymentIntentId => {
  Js.Promise.resolve(Js.Dict.empty()->Js.Json.object_)
}
let update = _options => {
  ()
}

let getElement = _componentName => {
  None
}

let fetchUpdates = () => {
  //add API call
  Js.Promise.make((~resolve, ~reject as _) => {
    Js.Global.setTimeout(() => resolve(. Js.Dict.empty()->Js.Json.object_), 1000)->ignore
  })
}
let defaultPaymentElement = {
  on: (_str, _func) => (),
  collapse: () => (),
  blur: () => (),
  update: _x => (),
  destroy: () => (),
  unmount: () => (),
  mount: _string => (),
  focus: () => (),
  clear: () => (),
}

let create = (_componentType, _options) => {
  defaultPaymentElement
}

let emptyElement = {
  getElement,
  update,
  fetchUpdates,
  create,
}
let emptyHyperInstance = {
  confirmPayment: confirmPaymentFn,
  confirmCardPayment: confirmCardPaymentFn,
  retrievePaymentIntent: retrievePaymentIntentFn,
  elements: _ev => emptyElement,
  widgets: _ev => emptyElement,
  paymentRequest: _ev => Js.Json.null

}

type eventType = Escape | Change | Click | Ready | Focus | Blur | None

let eventTypeMapper = event => {
  switch event {
  | "escape" => Escape
  | "change" => Change
  | "click" => Click
  | "ready" => Ready
  | "focus" => Focus
  | "blur" => Blur
  | _ => None
  }
}

let generateSessionID = () => {
  let chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  Belt.Array.make(32, 0)->Js.Array2.reduce((acc, _) => {
    let charIndex = Js.Math.random_int(0, chars->Js.String2.length)
    let newChar = chars->Js.String2.charAt(charIndex)
    acc ++ newChar
  }, "")
}

let getEnv = option => {
  let dict = switch option {
  | Some(json) => json->Js.Json.decodeObject->Belt.Option.getWithDefault(Js.Dict.empty())
  | None => Js.Dict.empty()
  }
  switch dict->Js.Dict.get("env") {
  | Some(val) =>
    switch val->Js.Json.decodeString {
    | Some(str) => str
    | None => ""
    }
  | None => ""
  }
}

module OrcaJs = {
  @val @scope("window")
  external hyperInstance: Js.Nullable.t<hyperInstanceMake> = "Hyper"
}