# Ember Autopilot

![thumbnail](thumbnail.png)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This is my personal framework for AI experiments in Factorio.

# Installation

You can install this mod through the built-in modloader of Factorio under the name "Ember Autopilot". Alternatively, you can manually install it using git or by downloading the source code in .zip format.

***Mod folder (Windows):*** `%appdata%\Factorio\mods`

***Mod folder (Mac OS X):*** `~/Library/Application\ Support/factorio/mods`

***Mod folder (Linux):*** `~/.factorio/mods`

## Installation with Git

```
cd <path to factorio mods>
git clone https://github.com/Diordany/factorio-ember-autopilot.git ember-autopilot_0.3.0
```

## Installation from ZIP

Just save the .zip file to the mod directory of Factorio as `ember-autopilot_0.3.0.zip` (or leave the name as is if downloading from the releases page).

# Features

Ember Autopilot works by binding agent programs to players to perform specific tasks. The agent programs that are currently available are explained here.

## Path Agent

This agent uses Factorio's built-in pathing algorithm to navigate to the given position. Start the agent with the command:

```
/ember-path <x> <y>
```

I couldn't get Factorio to generate a path that avoids collisions. I'm not sure if I missed something, but I'm planning on implementing a pathfinding algorithm myself anyway.

[cmd-path](https://github.com/Diordany/factorio-ember-autopilot/assets/54911023/bf298922-2cdb-4a44-a012-029242a7da81)

## Walking Agent

You can make the player walk towards a target position with the command:

```
/ember-walkpos <x> <y>
```

This agent does not use a pathfinding algorithm. It stops whenever its path is blocked.

[cmd-walkpos](https://github.com/Diordany/factorio-ember-autopilot/assets/54911023/dbbb233f-3038-4a63-bcfc-60cab858f53f)

## Wander Agent

This agent wanders around aimlessly while trying to avoid obstacles. Start the agent with the command:

```
/ember-wander
```

[cmd-wander](https://github.com/Diordany/factorio-ember-autopilot/assets/54911023/077d72ad-4ad5-42df-9d37-89cff2bfd264)

## Stopping the Agent

If for whatever reason you want to stop the agent, just run the following command:

```
/ember-stop
```