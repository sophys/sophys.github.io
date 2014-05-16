#!/bin/bash
rake generate
git add .
git commit -am "$1" 
git push origin source
rake deploy
