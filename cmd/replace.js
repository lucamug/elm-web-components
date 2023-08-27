#!/usr/bin/env node

const fs = require('fs');

// TODO - This script is very similar to cmd/build/safari-fix.js, we should merge them

const from = process.argv[2] 
const to = process.argv[3] 
const regexs = JSON.parse(process.argv[4])

// Command example
// cmd/replace.js "example.txt" "example2.txt" '[ [ "\\$\\{TENANT\\}", "ciaoTENANT" ], [ "\\$\\{SERVICE\\}", "ciaoSERVICE" ] ]'
// console.log(from, to, regexs[0][0]);

let fileContent = fs.readFileSync(from, 'utf8');
regexs.map( tuple => {
    fileContent = replace(tuple[0], tuple[1], tuple[2] || "g", fileContent);
})
fs.writeFileSync(to, fileContent);

function replace(string1, string2, string3, fileContent) {
    // console.log([string1, string2, string3]);
    const re = new RegExp(string1, string3);
    return fileContent.replace(re, string2);
}