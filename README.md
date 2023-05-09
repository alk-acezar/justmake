# Just / Make

This repository host readymade `justfiles` / `makefiles` for projects.

The goal is to hide implementation details of project management behind unified recipe names.
In any project `just test` should *just* run the tests without the need for the developer to know anything about the tools used for that purpose.
Same goes for linting and formating and even, to some extent, for installing the project in development mode.

## Installation

Recommanded method: Linking

### Linking

Adventages / Disadventages:

- automatically receive updates and new features
- no discrepencies between projects

How to avoid breaking updates ? Either:

    - create a local branch and rebase when you want
    - tag and check out the desired commit

How to customize? Either:

    - create a branch in the cloned repository
    - add a new `.env` option in the upstream repository

How to install:

```sh
git clone git@github.com:alk-acezar/justmake
cd myproject
ln -s ../justmake/python.justfile justfile
```

### Copying

Adventages / Disadventages:

- customisation per repository
- won't break on update
- but won't benefit from fixes and new features

How to install:

```sh
git clone git@github.com:alk-acezar/justmake
cd myproject
cp ../justmake/python.justfile justfile
```
