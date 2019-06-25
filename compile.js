const path = require('path');
const fs = require('fs');
const solc = require('solc');

const evaluationPath = path.resolve(__dirname, 'contracts', 'evaluation.sol');
const source = fs.readFileSync(evaluationPath, 'utf8');

console.log(solc.compile(source, 1));

module.exports = solc.compile(source, 1).contracts[':evaluation'];