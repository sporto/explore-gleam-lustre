import gleam/dynamic.{type Dynamic}
import gleam/io
import gleam/javascript/promise.{type Promise}
import gleam/result
import lustre
import lustre/effect
import lustre/element
import lustre/element/html
import lustre/event

@external(javascript, "./thing.ts", "generateThing")
fn generate_thing() -> Promise(Result(Thing, String))

pub type Thing {
  Thing(a: String, b: String)
}

pub type Msg {
  NoOp
  GenerateThing
  GenerateThingResult(Result(Thing, String))
}

pub type Model {
  Model
}

pub fn main() {
  let app = lustre.application(init, update, view)

  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

fn init(_flags) -> #(Model, effect.Effect(Msg)) {
  #(Model, effect.none())
}

pub fn update(model: Model, msg: Msg) -> #(Model, effect.Effect(Msg)) {
  case msg {
    NoOp -> #(model, effect.none())
    GenerateThing -> {
      #(model, generate_thing_effect())
    }
    GenerateThingResult(thing_result) -> {
      thing_result |> result.map(log_thing)
      // io.debug(thing == Ok(Thing("a", "b")))
      #(model, effect.none())
    }
  }
}

fn log_thing(thing: Thing) {
  io.debug(thing.b)
}

fn generate_thing_effect() -> effect.Effect(Msg) {
  let fx = fn(dispatch) {
    generate_thing()
    |> promise.await(fn(response) {
      let message = GenerateThingResult(response)
      promise.resolve(dispatch(message))
    })
    Nil
  }

  effect.from(fx)
}

pub fn view(model: Model) -> element.Element(Msg) {
  let btn_generate =
    html.button([event.on_click(GenerateThing)], [
      element.text("Generate Thing"),
    ])

  html.div([], [btn_generate])
}
