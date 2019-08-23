#import "MasterpassPlugin.h"
#import <masterpass/masterpass-Swift.h>

@implementation MasterpassPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMasterpassPlugin registerWithRegistrar:registrar];
}
@end
