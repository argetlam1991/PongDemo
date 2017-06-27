//
//  GameScene.m
//  PongDemo
//
//  Created by Gu Han on 6/26/17.
//  Copyright © 2017 Gu Han. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()
@property (strong, nonatomic) UITouch *leftPaddleMotivatingTouch;
@property (strong, nonatomic) UITouch *rightPaddleMotivatingTouch;


@end

@implementation GameScene {
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
}
static const CGFloat kTrackPixelsPerSecond = 1000;

- (void)didMoveToView:(SKView *)view {
  
  self.backgroundColor = [SKColor blackColor];
  self.scaleMode = SKSceneScaleModeAspectFit;
  self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
  
  SKNode *ball = [self childNodeWithName:@"ball"];
  ball.physicsBody.angularVelocity = 1.0;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
    [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    
    for (UITouch *t in touches) {
      CGPoint p = [t locationInNode:self];
      NSLog(@"\n%f %f %f %f", p.x, p.y, self.frame.size.width, self.frame.size.height);
      if (p.x < (0 - self.frame.size.width) * 0.3) {
        self.leftPaddleMotivatingTouch = t;
      } else if (p.x > self.frame.size.width * 0.3) {
        self.rightPaddleMotivatingTouch = t;
      } else {
        SKNode *ball = [self childNodeWithName:@"ball"];
        ball.physicsBody.velocity = CGVectorMake(ball.physicsBody.velocity.dx*2.0, ball.physicsBody.velocity.dy*2.0);
      }
    }
  [self trackPaddlesToMotivatingTouches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self trackPaddlesToMotivatingTouches];
  
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if ([touches containsObject:self.leftPaddleMotivatingTouch]) {
    self.leftPaddleMotivatingTouch = nil;
  }
  if ([touches containsObject:self.rightPaddleMotivatingTouch]) {
    self.rightPaddleMotivatingTouch = nil;
  }
  
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if ([touches containsObject:self.leftPaddleMotivatingTouch]) {
    self.leftPaddleMotivatingTouch = nil;
  }
  if ([touches containsObject:self.rightPaddleMotivatingTouch]) {
    self.rightPaddleMotivatingTouch = nil;
  }
  
}

- (void)trackPaddlesToMotivatingTouches {
  id a = @[@{@"node": [self childNodeWithName:@"left_paddle"],
             @"touch": self.leftPaddleMotivatingTouch ?: [NSNull null]},
           @{@"node": [self childNodeWithName:@"right_paddle"],
             @"touch": self.rightPaddleMotivatingTouch ?:[NSNull null]}];
  for (NSDictionary *o in a) {
    SKNode *node = o[@"node"];
    UITouch *touch = o[@"touch"];
    if ([[NSNull null] isEqual:touch]) {
      continue;
    }
    CGFloat yPos = [touch locationInNode:self].y;
    NSTimeInterval duration = ABS(yPos - node.position.y) / kTrackPixelsPerSecond;
    SKAction *moveAction = [SKAction moveToY:yPos duration:duration];
    [node runAction:moveAction withKey:@"moving!"];
  }
}



-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
