//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//
//
//  Untitled.m
//  flyer
//
//  Created by 白潇洋 on 14/11/9.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/NSObject.h>
#import "Student.h"
#import "MainScene.h"
#import "Commoner.h"
#import "Flyer.h"
#import "Step.h"

static const CGFloat firstCommonerPosition = 200.f;

static const CGFloat distanceBetweenCommoners = 200.f;


@implementation MainScene
{
    CGPoint mousewhere;
    Student *player;
    Step *last;
    Step *llast;
    
    int count;
    int lastc;
    double xsign;
    double ysign;
    int flynum;
    CCNode *pic;
    CCNode *pic2;

    CCPhysicsNode *physicsNode;
    NSMutableArray *commoners;
    NSMutableArray *commoners2;
    NSMutableArray *flyers;
    
}

- (void)onEnter {
    //flynum = 5;
    self.userInteractionEnabled = TRUE;
    count = 0;
    lastc = 0;
    last.position = ccp(player.position.x, player.position.y);
    last.visible = false;
    llast.position = ccp(player.position.x, player.position.y);
    llast.visible = false;
    mousewhere = ccp(player.position.x, 320 - player.position.y);
//    specialCommoner.position = ccp(55, 55);
    /*
    for (int i = 0; i < 5; i += 1) {
        [flyers addObject:[CCBReader load:@"Flyer"]];
        Flyer *thisflyer = (Flyer*)[flyers objectAtIndex:i];
        double ranx = ((double)random() / (double)RAND_MAX) * 570;
        double rany = ((double)random() / (double)RAND_MAX) * 256;
        thisflyer.position = ccp(ranx, rany);
        [self addChild:thisflyer];
    }
     */
    [super onEnter];
}

#pragma mark -Update
- (void)update:(CCTime)delta {
    
    int Xmovement = 0;
    CGPoint direction;
    double distance = sqrt((mousewhere.x - player.position.x) * (mousewhere.x - player.position.x) + (320 - mousewhere.y - player.position.y) * (320 - mousewhere.y - player.position.y));
    direction= ccp((mousewhere.x - player.position.x) / distance, (320 - mousewhere.y - player.position.y) / distance);
    double angle;
    if (direction.y > 0 && direction.x > 0) {
        angle = 90 - 180 * atan(direction.y / direction.x) / 3.14;
    } else if (direction.y * direction.x > 0) {
        angle = 270 - 180 * atan(direction.y / direction.x) / 3.14;
    } else if (direction.y > 0) {
        angle = 180 * atan(direction.y / direction.x) / 3.14;
    } else {
        angle = 180 + 180 * atan(direction.y / direction.x) / 3.14;
    }
    
    
    if (lastc % 10 == 0) {
        if (last.position.x != llast.position.x && last.position.y != llast.position.y && lastc % 20 == 10) {
            llast.position = ccp(last.position.x, last.position.y);
            llast.rotation = angle;
            llast.visible = true;
        }
        if (last.position.x != player.position.x && last.position.y != player.position.y && lastc % 20 == 0) {
            last.position = ccp(player.position.x, player.position.y);
            last.rotation = angle;
            last.visible = true;
        }
        if (lastc % 20 == 0 && lastc != 0) {
            lastc = 0;
        } else {
            lastc += 1;
        }
    } else {
        lastc += 1;
    }
    
    //moving the player
    /* moving the student*/
    if (distance > 1) {
        Xmovement = 2 * direction.x;
        player.position = ccp(player.position.x + Xmovement, player.position.y + 2 * direction.y);
        
    }
    /* end */
//    specialCommoner.position = ccp(specialCommoner.position.x + 2, specialCommoner.position.y);
    /* Spawning commoners */
    NSMutableArray *offScreenCommoners = nil;
    for (CCNode *commoner in commoners) {
        CGPoint commonerWorldPosition = [physicsNode convertToWorldSpace:commoner.position];
        CGPoint commonerScreenPosition = [self convertToNodeSpace:commonerWorldPosition];
        if (commonerScreenPosition.x < -commoner.contentSize.width) {
            if (!offScreenCommoners) {
                offScreenCommoners = [NSMutableArray array];
            }
            [offScreenCommoners addObject:commoner];
        }
        
        commoner.position = ccp(commoner.position.x - 2.5, commoner.position.y);
    }
    
    NSMutableArray *offScreenCommoners2 = nil;
    for (CCNode *commoner in commoners2) {
        if (commoner.position.x > 560 + player.position.x) {
            if (!offScreenCommoners) {
                offScreenCommoners2 = [NSMutableArray array];
            }
            [offScreenCommoners2 addObject:commoner];
        }
        
        commoner.position = ccp(commoner.position.x + 1.5, commoner.position.y);
    }
    //CGPoint backgroundScrollVel = ccp(0, 0);
    //physicsNode.position = ccpAdd(physicsNode.position, ccpMult(backgroundScrollVel, delta));
    
    for (CCNode *flyer in flyers) {
        flyer.position= ccp(flyer.position.x - 0.5, flyer.position.y);
    }
    
    pic.position = ccp(pic.position.x - Xmovement, pic.position.y);
    if (pic.position.x < -1185) {
        pic.position = ccp(0, pic.position.y);
    }
    
//    pic.position = ccp(pic.position.x - 0.5, pic.position.y);
//    if (pic.position.x < -1185) {
//        pic.position = ccp(0, pic.position.y);
//    NSLog(@"%f", pic.position.x);
    
    for (CCNode *commonerToRemove in offScreenCommoners) {
        [commonerToRemove removeFromParent];
        [commoners removeObject:commonerToRemove]; // for each removed obstacle, add a new one
        [self spawnNewCommoner];
    }
    
    for (CCNode *commonerToRemove in offScreenCommoners2) {
        CCLOG(@"commoner2 deleted");
        [commonerToRemove removeFromParent];
        [commoners2 removeObject:commonerToRemove]; // for each removed obstacle, add a new one
        [self spawnNewCommoner2];
    }
    
    //Andrew's code

    
    for (int i = 0; i < flynum; i += 1) {
        Flyer *thisfly;
        thisfly = ((Flyer*)[flyers objectAtIndex:i]);
        double distance2 = sqrt((player.position.x - thisfly.position.x) * (player.position.x - thisfly.position.x) + (player.position.y - thisfly.position.y) * (player.position.y - thisfly.position.y));
        CGPoint direction2;
        if (distance2 <= 100) {
            direction2 = ccp((player.position.x - thisfly.position.x) / distance2, (player.position.y - thisfly.position.y) / distance2);
        } else {
            direction2 = ccp(0, 0);
        }
        thisfly.position = ccp(thisfly.position.x + 1.5 * direction2.x, thisfly.position.y + 1.5 * direction2.y);
    }
    
    
}
#pragma mark - Touch Handling
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    mousewhere = [touch locationInView:touch.view];
}
- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    mousewhere = [touch locationInView:touch.view];
}

- (void)didLoadFromCCB{
    self.userInteractionEnabled = TRUE;
    commoners = [NSMutableArray array];
    for (int i = 0; i<6; i++)
    {
        [self spawnNewCommoner];
    }
    commoners2 = [NSMutableArray array];
    for (int i = 0; i<6; i++)
    {
        [self spawnNewCommoner2];
    }
    

    flynum = 5;
    flyers = [NSMutableArray array];
    for (int i = 0; i < 5; i += 1) {
        CCNode *thisflyer = [CCBReader load:@"Flyer"];
        double ranx = ((double)random() / (double)RAND_MAX) * 570;
        double rany = ((double)random() / (double)RAND_MAX) * 256;
        thisflyer.position = ccp(ranx, rany);
        [physicsNode addChild:thisflyer];
        [flyers addObject:thisflyer];
    }

   
//    specialCommoner.physicsBody.collisionType = @"specialCommoner";
//    commoner.zOrder = DrawingOrderGround; } // set this class as delegate
    physicsNode.collisionDelegate = self; // set collision txpe
    player.physicsBody.collisionType = @"player";
//    player.zOrder = DrawingOrdeHero;
}

//-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair player:(CCNode *)player commoner:(CCNode *)commoner {
//    NSLog(@"Contact!"); return TRUE; }


- (void)spawnNewCommoner {
    CCNode *previousCommoner = [commoners lastObject];
    CGFloat previousCommonerXPosition = previousCommoner.position.x;
    if (!previousCommoner) { // this is the first obstacle
        previousCommonerXPosition = firstCommonerPosition;
    }
    CCNode *commoner = [CCBReader load:@"Commoner"];
    double y= (arc4random() % (260)+30);
    commoner.position = ccp(previousCommonerXPosition + distanceBetweenCommoners, y);
    [physicsNode addChild:commoner];
    [commoners addObject:commoner];
    
//    /* determine speed of commoner*/
//    int minDuration = 2.0;
//    int maxDuration = 4.0;
//    int rangeDuration = maxDuration - minDuration;
//    int randomDuration = (arc4random() % rangeDuration) + minDuration;
//
//    //Creat actions
//    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-commoner.contentSize.width/2, commoner.position.y)];
//    CCAction *actionRemove = [CCActionRemove action];
//    [commoner runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}


- (void)spawnNewCommoner2 {
    CCNode *previousCommoner = [commoners2 lastObject];
    CGFloat previousCommonerXPosition = previousCommoner.position.x;
    int firstCommonerPosition2 = player.position.x-100;
    if (!previousCommoner) { // this is the first obstacle
        previousCommonerXPosition = firstCommonerPosition2;
    }
    CCNode *commoner = [CCBReader load:@"Commoner"];
    double y= (arc4random() % (260)-30);
    commoner.position = ccp(previousCommonerXPosition - distanceBetweenCommoners, y);
    [physicsNode addChild:commoner];
    [commoners2 addObject:commoner];
    
    //    /* determine speed of commoner*/
    //    int minDuration = 2.0;
    //    int maxDuration = 4.0;
    //    int rangeDuration = maxDuration - minDuration;
    //    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    //
    //    //Creat actions
    //    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-commoner.contentSize.width/2, commoner.position.y)];
    //    CCAction *actionRemove = [CCActionRemove action];
    //    [commoner runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

@end