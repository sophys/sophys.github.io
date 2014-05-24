---
layout: post
title: "从cocos2d-iphone V2.x迁移到V3.x注意事项"
date: 2014-05-24 22:45:06 +0800
comments: true
categories: translation,cocos2d
---
![Mou icon](http://www.cocos2d-iphone.org/images/cocos2d-logo.png)

酝酿了半年之久，Cocos2d-iphone终于迎来了一次大的升级:Cocos2d-iphone V3。Cocos2d的v3提供了一组丰富的激动人心的新功能。下边是官方的新增功能列表。
<!--more-->

>* 官方的Android的支持。 
>*  一个整洁的API。
>* 完整的API文档。 
>* 内置基于Chipmunk的CCPhysics。 
>* 大大改善了触摸操控。

相对于v2版本，v3版本确实做了很大的变动，以前在v2版本写的程序不是那么容易的就能迁移到v3版本中了。下边是来自[learn-cocos2d.com](http://www.learn-cocos2d.com/2014/03/migrating-cocos2diphone-v3-tips-tricks/)的一篇译文，大致罗列了从v2迁移到v3需要注意的一些问题。

这个教程是对那些从cocos2d-iphone V2版本迁移到到V3版本用户的一些提示和技巧的集合。大部分涉及到的问题都贴在[stackoverflow.com](www.stackoverflow.com)。
请原谅我在教程中描述的简短。我的时间有限但是不想再等两周以后再写这个教程，就像两周以前一样（第一次在4年左右，呵呵）。
##一、一般提示
####1.许多类已被重命名
“查看源代码，伙计”如果你找不到你要用的类： 
 1. 查阅cocos2d的[API文档](http://www.cocos2d-iphone.org/docs/api/index.html)
 2. 键入类名或方法名，看Xcode的自动补全建议
 3. 使用类名的一部分（如`repeatforever`），并执行“查找项目”来搜索所有的源代码文件

####2.现有的教程不再适用于V3
  是的，不再适用，它们是为cocos2d-iphone v2所写的。问题是，你必须要用V3版本吗？并且你必须现在就用它吗？如果你现在才开始学习cocos2d，从V2版开始的话会比较简单，因为有好多的教程/书籍都是基于V2版的。等更多的基于V3版的教程出来的时候再学习V3版吧。
####3.如何升级现有的V2版cocos2d程序到V3版
  并不是十分必要。[项目](http://www.learn-cocos2d.com/2011/05/update-cocos2d-iphone-existing-project/)越大迁移到V3版本可行性就越小。

>建议：结束使用V2版本吧，下一个程序就用V3版吧。考虑到v3.0带来了显著的变化并且v3.1将会使用彻底修改的渲染器，如果你正处在一个开发周期中，你可能（我实际是说：应该）会等这些改变发布了再去用他们。


####4.直接发送消息来取代`CCCallFunc`
  我注意到一些使用者用`runAction`取代`CCCallFunc`当他们只是想向对象发送一个消息的时候。也可以在Sprite Kit的使用者那里看到。
[这个例子](http://stackoverflow.com/questions/22047312/can-i-run-ccactionsequence-more-than-one-time/22048733#22048733)解释了我要表达的意思
####5.记得在你的AppDelegate方法里调用`[super ...]`
  `特别是：`如果不在[`applicationDidBecomeActive`](http://stackoverflow.com/questions/21970097/cocos2d-animation-stops-when-returning-from-background/21970180#21970180) 里边调用`[super ...]`cocos2d将无法恢复。
##二、具体提示
####1.如何通过tag找到节点？
  `tag`已经被CCNode的[`mane`](http://www.cocos2d-iphone.org/docs/api/Classes/CCNode.html#//api/name/name)属性取代了。有相应的`removeChildByName：`等可用的方法。
####2.CC***Action找不到了？
  大多数的CCAction类已经重命名了。新的类采用一致的命名方式，都以"CCAction"开头。
例如：[`CCRepeatForever` ](http://stackoverflow.com/questions/21553933/ccrepeatforever-doesnt-exists-in-cocos2d-iphone-3-0/21554019#21554019)现在命名为`CCActionRepeatForever`
呵呵，`CCCallBlockN`，`CCCallBlockND`都没有了。现在是`CCActionCallFuncN`和`CCActionCallFuncND`。其实它们从来没有真正的被需要，并且`CCActionCallFuncN`和`CCActionCallFuncND`使用ARC实际上是很危险的。 
可以使用[`CCCallBlock`](http://stackoverflow.com/questions/22038737/cccallblockns-alternative-in-cocos2d-v3-0/22039128#22039128)，由于`block`的工作方式（可以访问相应范围内的变量）完全可以取代上述4个函数而达到同样的效果。也可以使用[`schedule`](http://stackoverflow.com/questions/22134214/cocos2d-v3-ccactioncallfunc-with-object/22141289#22141289)调度一个`update`。
####3.如何使用Sprite帧动画？
 这个API已经改变了，这里有大量的例子，[这里](http://stackoverflow.com/questions/21645953/how-to-animate-ccsprite-in-cocos2d-3-x/21649464#21649464),[这里](http://stackoverflow.com/questions/21598354/how-to-create-animation-in-cocos2d-3-0/21600010#21600010),[这里](http://stackoverflow.com/questions/21841265/sprite-frame-animation-cocos2d-3-0/21843802#21843802)和[这里](http://stackoverflow.com/questions/22040631/cocos2d-v3-0-sprite-animation-from-spritesheet/22041094#22041094)。
####4. CCNodeColor始终是不透明的？
  [`Opacity`](http://stackoverflow.com/questions/22116450/cclayercolor-for-cocos2d-v3/22117289#22117289)属性已经从字节（0-255）改变为CCFloat（0.0-1.0）。这意味着值大于1会使颜色节点不透明。将你的数值除以255，例如 128/255 = 0.5。
####5.如何启用触摸输入和重力感应？
  `self.accelerometerEnabled`和`self.touchEnabled`已被删除。使用[`self.userInteractionEnabled`](http://stackoverflow.com/questions/21870010/how-do-you-detect-touches-in-a-ccscene-on-cocos2d-v3/21870485#21870485)或使用[Sprite Kit](http://stackoverflow.com/questions/14304652/what-is-the-alternative-method-for-the-self-istouchenabled-in-cocos2d-2-0/14304895#14304895),这将需要更多的工作（哈哈。。。）。还有[`CCResponder`](http://www.cocos2d-iphone.org/docs/api/Classes/CCResponder.html)是所有提供类似`UIResponder/NSResponder`功能的节点的基类。
[这里是cocos2d v3触摸操作的教程](https://www.makegameswith.us/gamernews/366/touch-handling-in-cocos2d-30)(要翻墙)。
####6.如何启用多点触控？
  [看这里](http://stackoverflow.com/questions/21568169/multi-touch-on-two-ccbutton-not-detected-with-cocos2d-iphone-v3)
####7.CCMenu、CCMenuItem去哪了？
 没有啦，被[`CCButton`](http://stackoverflow.com/questions/21423289/how-to-set-toggle-button-in-cocos2d-3-0/21686709#21686709)等取代了。研究cocos2d-ui目录以得到更多的UI方面的类吧。这是一个[`CCButton`](http://stackoverflow.com/questions/22023663/ccmenuitemsprites-alternative-in-cocos2d-v3/22023961#22023961)的例子。
####8.怎么播放声音或音乐？
  `CocosDenshion/SimpleAudioEngine`已经（谢天谢地）被替换为`ObjectAL/OALSimpleAudio`，[这里](http://stackoverflow.com/questions/21846932/simpleaudioengine-in-cocos2d-3-0/21846984#21846984)和[这里](http://stackoverflow.com/questions/21797531/playing-audio-in-cocos2d-v3/21798773#21798773)是例子。
 更多关于[`ObjectAL`](http://kstenerud.github.io/ObjectAL-for-iPhone/)和[`ObjectAL`的文档/参考](http://kstenerud.github.io/ObjectAL-for-iPhone/documentation/index.html)。
####9.最喜欢的场景过渡去哪了？
  一些[过渡方式](http://www.cocos2d-iphone.org/docs/api/Classes/CCTransition.html)在 v3 RCx被剔除了。
####10.cocos2d的UIViewController呢？
  `CCDirector!` [这里](http://stackoverflow.com/questions/21824693/how-to-modal-or-present-a-viewcontroller-in-cocos2d-v3/21891621#21891621)和[这里](http://stackoverflow.com/questions/21979210/present-gkgamecenterviewcontroller-in-a-cocos2d-3-project/22024305#22024305)是怎样在cocos2d呈现另外一个 view controller的例子
```
[[CCDirector sharedDirector] presentModalViewController:myView animated:NO];
```
####11.如何获得屏幕大小？
  CCDirector的`winSize`属性现在命名为[`viewSize`](http://stackoverflow.com/questions/21845981/how-to-get-winsize-in-cocos2d-3-0/21846016#21846016)。
####12. AppController去哪了？
  它被重命名为[`AppDelegate`](http://stackoverflow.com/questions/21846550/appcontroller-alternative-for-cocos2d-3-0/21858653#21858653)了。
####13.如何在cocos2d-iphone v3中集成iAd的？
  这是一个[例子](http://stackoverflow.com/questions/21771126/how-to-add-iad-in-cocos-spritebuilder/21797037#21797037)，还有[这里](http://stackoverflow.com/questions/21868303/hiding-iad-in-cocos2d-v3-0/21871818#21871818)如何隐藏的iAd的横幅视图。
####14.如何在CCSprite使用自定义着色器？
  ```
  #import "CCNode_Private.h"
  ```
 这里是一个[例子](http://stackoverflow.com/questions/22017033/cocos2d-3-blur-shaders/22020715#22020715)，[另一种](http://stackoverflow.com/questions/21587876/shaderprogram-in-cocos2d-3-0-doesnt-work/21612872#21612872)。
>警告：这个API现在是私有的，谨慎使用。因为V3.1将会使用不同的渲染器，因此访问`shader`属性的方法可能会在v3.1中有所改变。

####15.如何设置纵向方向？
 [看这里](http://stackoverflow.com/questions/21845532/cocos2d-3-0-set-portrait-game)
####16.Chipmunk取代了Box2d的mouse joint？
 [看这里](http://stackoverflow.com/questions/22182130/mousejoint-in-cocos2d-v3-for-ios/22188976#22188976)
####17.怎样通过CCButton来使用UIScrollView？
 [看这里](http://stackoverflow.com/questions/22148070/cocos2d-and-uiscrollview-pass-through-touches/22150389#22150389)
####18.CCLayer去哪了？（我添加进来的，[看这里](https://www.makegameswith.us/tutorials/cocos2d-3-transition/changes-cocos2d-3/),要翻墙）
  cocos2d 3.x不再有`CCLayer`了.当你想处理用户的触摸输入,`CCLayer`曾经是你应该使用的类，在cocos2d3.x中任何的`CCNode`可以处理触摸输入，因此没有必要使用`CCLayer`了。`CCNode`就是新`CCLayer`。对于场景就使用`CCScene`，场景中的一切都使用`CCNode`。
##三、缺失或不清楚
####1. 怎么在后台放置一个camera视图？
  和在v2中相同的程序，但是有些使用者将v2的代码应用到v3中[遇到了问题](http://stackoverflow.com/questions/21931263/put-camera-in-background-in-cocos2d-3-0)。也许它不再工作了，又也许只是需要有人来弄清楚如何使它工作。
####2. Javascript绑定在哪里使用？
 [它们已被删除](http://stackoverflow.com/questions/21911118/how-can-i-implement-jsbindings-in-cocos2d-iphone-v3/21912919#21912919)，不会再回来了。

>PS：用cocos2d来开发JS，你可以使用的`cocos2d-X/cocos2d-HTML5`，但也有一些很不错的js跨平台开发解决方案，除非你十分迷恋cocos2d，你应该研究其他的JS游戏引擎并决定哪一个最适合你。

####3. Box2D的模板（集成）去哪里了？
  没有了。box2d的模板/集成可能会也可能不会再有了。这绝对不是一个高优先级的事。因为cocos2d的物理引擎重点是`Chipmunk`的集成。在cocos2d和SpriteBuilder中添加另一个物理引擎将会使工作量加倍。所以我觉得在cocos2d中集成Box2D是不大可能的。但是，您可以在项目中添加Box2D并使用它，但同步精灵与物体的位置/旋转以及物体的内存管理将由你自己来管理。

###参考
1. [Migrating to cocos2d-iphone v3 – Tips & Tricks](http://www.learn-cocos2d.com/2014/03/migrating-cocos2diphone-v3-tips-tricks/)
2. [Cocos2D Developer Library](http://www.cocos2d-iphone.org/docs/api/index.html)
3. [http://stackoverflow.com/](http://stackoverflow.com/)
4. [changes-cocos2d-3](https://www.makegameswith.us/tutorials/cocos2d-3-transition/changes-cocos2d-3/)






