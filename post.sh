#!/bin/bash

#cd octopress
#git pull origin source  # update the local source branch
#cd ./_deploy
#git pull origin master
#rake new_post["New Post"]

rake generate
git add .
git commit -am "$1" 
git push origin source
rake deploy
