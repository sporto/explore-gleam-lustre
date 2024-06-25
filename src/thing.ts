import { Result, Ok } from "build/dev/javascript/prelude.mjs";
import { Thing } from "build/dev/javascript/app/app.mjs";

export async function generateThing(): Promise<Result<Thing, string>> {
  let thing = new Thing("A", "B");
  return Promise.resolve(new Ok(thing));
}
