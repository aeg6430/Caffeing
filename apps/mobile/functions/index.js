const functions = require("firebase-functions");
require("dotenv").config();


exports.getGithubConfig = functions.https.onCall((data, context) => {
  const token = process.env.GITHUB_TOKEN;
  const repo = process.env.GITHUB_REPO;

  console.log("Token:", token);
  console.log("Repo:", repo);

  return {
    token: token || "",
    repo: repo || "",
  };
});
