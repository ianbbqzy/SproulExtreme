//
//  Commoner.m
//  SproulXtreme
//
//  Created by Ian Lee on 2014-11-09.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Commoner.h"
@implementation Commoner


- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"Commoner";
    self.physicsBody.sensor = TRUE;}

//- (void)setupRandomPosition { // value between 0.f and 1.f
//    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
//    CGFloat range = maximumYPositionTopPipe - minimumYPositionTopPipe;
//    _topPipe.position = ccp(_topPipe.position.x, minimumYPositionTopPipe + (random * range));
//    _bottomPipe.position = ccp(_bottomPipe.position.x, _topPipe.position.y + pipeDistance); }

@end