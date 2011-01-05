//
//  GrowlNotifier.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 01/07/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GrowlNotifier : NSObject <GrowlApplicationBridgeDelegate>
{

}
+(void)postGrowlNotificationWithTitle:(NSString *)title description:(NSString *)description image:(NSData *)image;
@end
