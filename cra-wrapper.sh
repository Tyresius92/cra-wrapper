echo "Running create-react-app with argument '$1'";
npx create-react-app $1;

echo "Changing into directory '$1'";
pushd $1;

echo "Installing Prettier and eslint in project '$1'";
npm install --save-dev prettier eslint;

popd;

echo "Copying eslint config file to '$1'";
cp ~/github/cra-wrapper/.eslintrc.json ./$1/.eslintrc.json;

echo "Copying Prettier config file to '$1'";
cp ~/github/cra-wrapper/.prettierrc.json ./$1/.prettierrc.json;

echo "Adding custom scripts to package.json";
node ~/github/cra-wrapper/addScriptsToPackageJson.js $1;

echo "Removing unwanted files from 'src' directory";

pushd ./$1/src;

shopt -s extglob
rm -v !("index.js"|"setupTests.js");

echo "Relocating and re-initializing App.js";
mkdir ./components;
touch ./components/App.js 
echo "import React from 'react';

const App = () => <div>Hello World!</div>;

export default App;" >> ./components/App.js

echo "Creating test file for App.js"
mkdir ./components/__tests__/
touch ./components/__tests__/App.test.js
echo "import React from 'react';
import {render} from '@testing-library/react';
import App from '../App';

describe('App', () => {
	it('renders hello world', () => {
		const {getByText} = render(<App />);
		const componentText = getByText('Hello World!');
		expect(componentText).toBeInTheDocument();
	})
});" >> ./components/__tests__/App.test.js

echo "Modifying index.js to account for previous changes"
# remove index.css
sed -i "s_import './index.css';__g" ./index.js
# Change App.js import
sed -i "s_import App from './App'_import App from './components/App'_g" ./index.js
# remove service worker import
sed -i "s_import \* as serviceWorker from './serviceWorker';__g" ./index.js
# remove all comments
sed -i "s_// .*__g" ./index.js
# remove service worker call
sed -i "s_serviceWorker.unregister();__g" ./index.js

# verify that all changes work as expected
npm run test -- --watchAll=false;
npm run prettify && npm run lintify;

npm run sniff;

popd;