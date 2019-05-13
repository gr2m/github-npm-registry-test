workflow "Release" {
  on = "push"
  resolves = ["npx semantic-release"]
}

action "filter: master branch" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "npm ci" {
  needs = "filter: master branch"
  uses = "docker://node:alpine"
  runs = "npm"
  args = "ci"
}

action "npm test" {
  needs = "npm ci"
  uses = "docker://node:alpine"
  runs = "npm"
  args = "test"
}

action "npx semantic-release" {
  needs = "npm test"
  uses = "docker://timbru31/node-alpine-git"
  runs = "npx"
  args = "semantic-release"
  env = {
    NPM_CONFIG_REGISTRY = "https://npm.pkg.github.com/"
  }
  secrets = ["NPM_TOKEN", "GH_TOKEN"]
}
