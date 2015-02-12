
# office-hours.js
A reusable office-hours component.

## Using office-hours in an application.

- Add the appropriate line to bower.json
- Update the path section of the application's requirejs config. For rails, this is probably config/requirejs.yml.
```
  "office-hours": "office-hours/dist"
```

## Getting started for development.
```
git checkout dev
git pull origin dev
npm run reset
npm test
git checkout -b my_branch
```

## Setting up for a basic red-green-refactor workflow.

```
npm install
npm run watch
npm run watch:test   # in another terminal window or pane
```

## Examples of common tasks.

npm script commands are defined in the scripts section of package.json.
To see a full list of available npm commands, execute:

```
npm run
```

### Install Node and Bower components.

```
npm install
```

### Build the distribution when files change.

```
npm run watch
```

### Running Tests.

One time.

```
npm test
```

Watch continuously and execute tests when code or specs change.

```
npm run watch:test
```

Remove and reinstall node modules and bower components.

```
npm run reset
```

### Demo App

Start a demo app on localhost

```
npm run start
```

### Building a Distribution

To build a distribution and tag it, execute one of the following commands.

```
npm version patch -m "Bumped to %s"
npm version minor -m "Bumped to %s"
npm version major -m "Bumped to %s"
```

Build a distribution.

```
npm run build
```

## Notes
  - The dist/ directory must be part of the repo - don't gitignore it!

