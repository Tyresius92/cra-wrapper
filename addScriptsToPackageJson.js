console.log('\nEntering addScriptsToPackageJson.js\n\n');

const reactAppName = process.argv[2];

const filePath = `${reactAppName}/package.json`;
console.log(`Opening ${filePath}\n`);

fs = require('fs');
const file = fs.readFileSync(filePath);
const packageJson = JSON.parse(file);

console.log('Original scripts section: ', packageJson.scripts, '\n\n');

// prettier-ignore
const newScriptsSection = {
  ...packageJson.scripts,
  test: "react-scripts test --colors",
  prettify: "prettier --config package.json --ignore-path .prettierignore --write \"src/**/*.js\"",
  checkPrettier: "prettier --ignore-path .prettierignore --check \"src/**/*.js\"",
  lint: "node_modules/.bin/eslint --color --ext js,jsx ./src",
  lintify: "node_modules/.bin/eslint --color --fix --ext js,jsx ./src",
  fix: "npm run prettify && npm run lintify && npm run sniff",
  smellsGood: "echo Great success!! Your code smells goooood!",
  sniff: "npm run checkPrettier && npm run lint && npm run smellsGood"
};

console.log('New scripts section: ', newScriptsSection, '\n\n');

packageJson.scripts = newScriptsSection;

console.log('Overwriting package.json with new version', packageJson, '\n\n');

fs.writeFileSync(filePath, JSON.stringify(packageJson, null, 2));

console.log('\nExiting addScriptsToPackageJson.js');
