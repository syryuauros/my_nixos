#!/usr/bin/env sh

#!/bin/bash

export DISPLAY=:100

# Start openbox (or your WM of choice)
openbox &
sleep 1
# Start Obsidian
obsidian
