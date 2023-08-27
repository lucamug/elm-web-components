#!/usr/bin/env node

// This file in coming from https://discourse.elm-lang.org/t/what-i-ve-learned-about-minifying-elm-code/7632
const fs = require("fs");
const esbuild = require("esbuild");

const pureFuncs = [ "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9"];

const elmCode = fs.readFileSync("dist/TEMP/elm.js", "utf8");

// Remove IIFE.
const newElmCode =
  "var scope = window;" +
  elmCode.slice(elmCode.indexOf("{") + 1, elmCode.lastIndexOf("}"));

const result = esbuild.transformSync(newElmCode, {
  minify: true,
  pure: pureFuncs,
  target: "es5",
  // This enables top level minification, and re-adds an IIFE.
  format: "iife",
});

fs.writeFileSync("dist/TEMP/elm.min.js", result.code);