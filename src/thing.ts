import { Thing } from "../build/dev/javascript/app/app.mts";
//
// class Thing {}

export async function generateThing(): Promise<Thing> {
  return Promise.resolve(new Thing("a", "b"));
}
