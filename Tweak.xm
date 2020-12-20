#import <firmware.h>
#import <UIKit/UIKit.h>

@interface UIKeyboardInputMode : UITextInputMode
@property(retain) NSString *identifier;
@end

@interface UIKeyboardInputModeController : NSObject
@property(retain) UIKeyboardInputMode* currentInputMode;
- (NSArray *)activeInputModes;
+ (UIKeyboardInputModeController *)sharedInputModeController;
@end

@interface UIKeyboardImpl : NSObject
- (NSString *)inputModeLastChosen;
@end

//==================================================================================

NSString *iOS7Result(UIKeyboardImpl *object, int a, int b) 
{
	NSArray* activeInputModes = [[UIKeyboardInputModeController sharedInputModeController] activeInputModes];
	UIKeyboardInputMode *firstInputMode = [activeInputModes objectAtIndex:0];
	if ([activeInputModes count] == 1) 
	{
		return [firstInputMode identifier];
	}
	int index = [[object inputModeLastChosen] isEqualToString:[firstInputMode identifier]] ? a : b;
	return [[activeInputModes objectAtIndex:index] identifier];
}

UIKeyboardInputMode *iOS8Result(UIKeyboardInputModeController *object, int a, int b) 
{
	UIKeyboardInputMode *currentInputMode = object.currentInputMode;
	NSArray *activeInputModes = [object activeInputModes];
	UIKeyboardInputMode *firstInputMode = [activeInputModes objectAtIndex:0];
	if ([activeInputModes count] == 1) 
	{
		return firstInputMode;
	}
	int index = [currentInputMode.identifier isEqualToString:[firstInputMode identifier]] ? a : b;
	return [activeInputModes objectAtIndex:index];
}

//==================================================================================

%hook UIKeyboardImpl
%group GiOS6
- (NSString *)lastUsedInputMode 
{
	NSArray *activeInputModes = [[UIKeyboardInputModeController sharedInputModeController] activeInputModes];
	return [[activeInputModes objectAtIndex:0] identifier];
}
- (BOOL)globeKeyDisplaysAsEmojiKey {
	return NO;
}
%end

%group GiOS7
- (NSString *)lastUsedInputMode 
{
	return iOS7Result(self, 0, 1);
}

- (NSString *)nextInputModeToUse 
{ 
	return iOS7Result(self, 1, 0);
}
%end
%end

%group GiOS8 
%hook UIKeyboardInputModeController
- (UIKeyboardInputMode *)lastUsedInputMode 
{
	return iOS8Result(self, 0, 1);
}

- (UIKeyboardInputMode *)nextInputModeToUse 
{
	return iOS8Result(self, 1, 0);
}
%end
%end

%group GiOS13
%hook UIKeyboardLayoutStar
- (BOOL)showsDedicatedEmojiKeyAlongsideGlobeButton {
	return NO;
}
- (NSString *)internationalKeyDisplayStringOnEmojiKeyboard {
	return nil;
}
%end
%end

//==================================================================================

%ctor 
{
	if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0)
	{
		%init(GiOS6);
	}
	else if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0 && kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_8_0)
	{
		%init(GiOS7);
	}
	else
	{
		%init(GiOS8);
		if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_13_0)
		{
			%init(GiOS13);
		}
	}
	%init;
}
