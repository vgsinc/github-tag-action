# github-tag-action
Non-fork fork of https://github.com/anothrNick/github-tag-action

For now I've not kept the fork intact since this action may go off in a different direction than
the original fork. However, if not for the original action referenced here I may have never gotten this
far. Thanks to everyone who has worked on the original action.

My intention here is not to keep this divered forever if this makes sense to add back to the original.
I'd like to start using this as if to see which direction it goes in first, and then see if it
makes sense to attempt a merge of the two actions.

# github-tag-action

A Github Action to automatically bump and tag master, on merge, with the latest SemVer formatted version.

> Medium Post: [Creating A Github Action to Tag Commits](https://itnext.io/creating-a-github-action-to-tag-commits-2722f1560dec)

[<img src="https://miro.medium.com/max/1200/1*_4Ex1uUhL93a3bHyC-TgPg.png" width="400">](https://itnext.io/creating-a-github-action-to-tag-commits-2722f1560dec)

### Usage

```Dockerfile
name: Bump version
on:
  push:
    branches:
      - master
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: Bump version and push tag
      uses: anothrNick/github-tag-action@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

#### Options

**Environment Variables**

* **GITHUB_TOKEN** ***(required)*** - Required for permission to tag the repo.
* **BUMP** *(optional)* - Which type of bump to use (default: `build`).
* **WITH_V** *(optional)* - Tag version with `v` character.
* **SKIP_NO_CHANGES** *(optional)* - Indicates if a tag should be skipped when there are no new changes (default: `false`).
* **REPO** - The full repo that the tag will be made in. (example: org/repo_name)

#### Outputs

* **new_tag** - The value of the newly created tag.

> ***Note:*** This action creates a [lightweight tag](https://developer.github.com/v3/git/refs/#create-a-reference).

### Bumping

This fork has modified the bumping strategy. Instead of taggin based on messages in a commit, taggin will be done based on
execution of the workflow along with a specific bump level.

### Workflow

* Add this action to your repo
* Commit some changes
* Run this action based on a trigger - perhaps a schedule for a nightly build for instance.


### Credits

[fsaintjacques/semver-tool](https://github.com/fsaintjacques/semver-tool)

### Projects using github-tag-action

A list of projects using github-tag-action for reference.

* another/github-tag-action (uses itself to create tags)

* [anothrNick/json-tree-service](https://github.com/anothrNick/json-tree-service)

  > Access JSON structure with HTTP path parameters as keys/indices to the JSON.
