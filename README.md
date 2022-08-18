# photo![Xcode build](https://github.com/guillodacosta/photoclassic/workflows/Xcode%20build/badge.svg?branch=main)

# PhotoClassic

- Application that uses the https://jsonplaceholder.typicode.com API and is built with UIKit and clean swift. 
- For run this project you do not need to install additional libraries, just clone on main and run (minimum target iOS 14.0)

## Architecture

Photoclassic is based on Clean Swift architecture (hexagonal architecture) https://clean-swift.com/handbook/ 
The UITests are made with the Robot pattern which is a (Builder + POM Page Object Model) architectures

For creating a new feature you can work below Scenes and consider each Scene with its own UseCase
New UI atomics component should be created inside UIComponents and it can inheritance from others UIView as well


## Branching

Before creating a new feature please try to use branching defined on Gitflow. Is you do not know gitflow you can read more about it in ![gitflow link](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)


## Platforms

Currently runs on iPhone and iPad. 
