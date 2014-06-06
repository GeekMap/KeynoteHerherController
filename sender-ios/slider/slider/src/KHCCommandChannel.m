//
//  KHCCommandChannel.m
//  slider
//
//  Created by jarronshih on 2014/6/6.
//
//

#import "KHCCommandChannel.h"

@implementation KHCCommandChannel

- (void)didReceiveTextMessage:(NSString*)message {
    NSLog(@"received message: %@", message);
}

@end