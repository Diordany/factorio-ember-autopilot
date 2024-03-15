# Ember Autopilot

![thumbnail](thumbnail.png)

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](http://unlicense.org/)

This is my personal framework for AI experiments in Factorio.

# Installation

You can install this mod through the built-in modloader of Factorio under the name "Ember Autopilot". Alternatively, you can manually install it using git or by downloading the source code in .zip format.

***Mod folder (Windows):*** `%appdata%\Factorio\mods`

***Mod folder (Mac OS X):*** `~/Library/Application\ Support/factorio/mods`

***Mod folder (Linux):*** `~/.factorio/mods`

## Installation with Git

```
cd <path to factorio mods>
git clone https://github.com/Diordany/factorio-ember-autopilot.git ember-autopilot_0.0.1
```

## Installation from ZIP

Just save the .zip file to the mod directory of Factorio as `ember-autopilot_0.0.1.zip` (or leave the name as is if downloading from the releases page).

# Features

Ember pilot works by binding agent programs to players to perform specific tasks. The agent programs that are currently available are explained here.

## Walking Agent

You can make the player walk towards a target position with the command:

```
/ember-walkpos <x> <y>
```

This agent does not use a pathfinding algorithm however, so it is possible that the agent gets stuck colliding with other objects. In that case, just run the **stop** command.

[cmd-walkpos](https://github.com/Diordany/factorio-ember-autopilot/assets/54911023/dbbb233f-3038-4a63-bcfc-60cab858f53f)

## Stopping the Agent

If for whatever reason you want to stop the agent, just run the following command:

```
/ember-stop
```