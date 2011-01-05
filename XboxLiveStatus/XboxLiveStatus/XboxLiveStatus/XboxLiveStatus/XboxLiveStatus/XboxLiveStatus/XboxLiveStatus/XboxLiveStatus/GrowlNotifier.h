//
//  GrowlNotifier.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 02/07/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "Growl.framework/Headers/GrowlApplicationBridge.h"


@interface GrowlNotifier : NSObject <GrowlApplicationBridgeDelegate>
{

}
-(void)growlNotification:(NSString *)title withMessage:(NSString *)message andImage:(NSImage *)image;
@end
