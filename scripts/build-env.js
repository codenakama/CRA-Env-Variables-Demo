const fs = require("fs");

const NODE_ENV = process.env.NODE_ENV || "development";

function getEnvVars() {
  return Object.keys(process.env)
    .filter(key => /^REACT_APP_/i.test(key))
    .reduce(
      (env, key) => {
        env[key] = process.env[key];
        return env;
      },
      { NODE_ENV }
    );
}

function buildAppConfigFile() {
  const envVars = getEnvVars();

  const fileData = `window.APP_CONFIG = ${JSON.stringify(envVars)}`;

  fs.writeFile("app/public/config/app-config.js", fileData, function(err) {
    if (err) {
      console.log("There has been an error creating App config.");
      console.log(err.message);
      return;
    }
    console.log("App config created successfully.");
  });
}

console.log(buildAppConfigFile());
