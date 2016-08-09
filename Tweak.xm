#import <firmware.h>

@interface UIKeyboardInputMode : UITextInputMode
@property(retain) NSString *identifier;
@end

@interface UIKeyboardInputModeController : NSObject
@property(retain) UIKeyboardInputMode* currentInputMode;
-(NSArray *)activeInputModes;
+(UIKeyboardInputModeController *)sharedInputModeController;
@end

@interface UIKeyboardImpl : NSObject
-(NSString *)inputModeLastChosen;
@end

//==================================================================================

NSString *iOS7Result(UIKeyboardImpl *object, int a, int b) {
	NSArray* activeInputModes = [[UIKeyboardInputModeController sharedInputModeController] activeInputModes];
	return ([[object inputModeLastChosen] isEqualToString:[activeInputModes[0] identifier]]) ? [activeInputModes[a] identifier] : [activeInputModes[b] identifier];
}

UIKeyboardInputMode *iOS8Result(UIKeyboardInputModeController *object, int a, int b) {
	UIKeyboardInputMode *currentInputMode = object.currentInputMode;
	NSArray *activeInputModes = [object activeInputModes];
	return ([currentInputMode.identifier isEqualToString:[activeInputModes[0] identifier]]) ? activeInputModes[a] : activeInputModes[b];
}

//==================================================================================

%hook UIKeyboardImpl
%group GiOS6
-(NSString *)lastUsedInputMode {
	NSArray *activeInputModes = [[UIKeyboardInputModeController sharedInputModeController] activeInputModes];
	return [activeInputModes[0] identifier];
}
%end

%group GiOS7
-(NSString *)lastUsedInputMode {
	return iOS7Result(self, 0, 1);
}

-(NSString *)nextInputModeToUse { 
	return iOS7Result(self, 1, 0);
}
%end
%end

%group GiOS8 
%hook UIKeyboardInputModeController
-(UIKeyboardInputMode *)lastUsedInputMode {
	return iOS8Result(self, 0, 1);
}

-(UIKeyboardInputMode *)nextInputModeToUse {
	return iOS8Result(self, 1, 0);
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
