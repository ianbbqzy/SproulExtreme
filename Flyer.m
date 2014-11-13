//
//  Flyer.m
//  SproulXtreme
//
//  Created by Ian Lee on 2014-11-09.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Flyer.h"

@implementation Flyer

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"Flyer";
    self.physicsBody.sensor = TRUE;}


@end
