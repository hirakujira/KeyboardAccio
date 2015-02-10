#import <firmware.h>

#define iOS7Result(a,b) NSArray* activeInputModes = [[UIKeyboardInputModeController sharedInputModeController] activeInputModes]; \
	return ([[self inputModeLastChosen] isEqualToString:[activeInputModes[0] identifier]]) ? [activeInputModes[a] identifier] : [activeInputModes[b] identifier]

#define iOS8Result(a,b) UIKeyboardInputMode* currentInputMode = self.currentInputMode; \
	NSArray* activeInputModes = [self activeInputModes]; \
	return ([currentInputMode.identifier isEqualToString:[[activeInputModes objectAtIndex:0] identifier]]) ? [activeInputModes objectAtIndex:a] : [activeInputModes objectAtIndex:b];

@interface UIKeyboardInputMode : UITextInputMode
@property(retain) NSString* identifier;
@end

@interface UIKeyboardInputModeController : NSObject
@property(retain) UIKeyboardInputMode* currentInputMode;
-(NSArray *)activeInputModes;
+(UIKeyboardInputModeController *)sharedInputModeController;
@end

@interface UIKeyboardImpl : NSObject
-(NSString *)inputModeLastChosen;
@end

%hook UIKeyboardImpl
%group GiOS6
-(NSString *)lastUsedInputMode {
	NSArray* activeInputModes = [[UIKeyboardInputModeController sharedInputModeController] activeInputModes];
	return [activeInputModes[0] identifier];
}
%end

%group GiOS7
-(NSString *)lastUsedInputMode {
	iOS7Result(0,1);
}

-(NSString *)nextInputModeToUse { 
	iOS7Result(1,0);
}
%end
%end

%group GiOS8 
%hook UIKeyboardInputModeController
-(UIKeyboardInputMode *)lastUsedInputMode {
	iOS8Result(0,1);
}

-(UIKeyboardInputMode *)nextInputModeToUse {
	iOS8Result(1,0);
}
%end

%end
//==================================================================================
%ctor {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0)
    	%init(GiOS6);
    else if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0 && kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_8_0)
	    %init(GiOS7);
	else if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0)
		%init(GiOS8);

    [pool release];
}
