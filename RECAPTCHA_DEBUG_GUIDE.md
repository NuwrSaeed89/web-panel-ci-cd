# reCAPTCHA Debug Guide

## Issue Fixed
The error "Failed to initialize reCAPTCHA Enterprise config. Triggering the reCAPTCHA v2 verification. ❌ Verification failed: The phone verification request contains an invalid application verifier" has been addressed.

## Changes Made

### 1. Enhanced reCAPTCHA Initialization (`web/index.html`)
- Added proper onload callback for reCAPTCHA API
- Implemented retry mechanism for failed initialization
- Added fallback timeout (10 seconds)
- Improved error handling and logging

### 2. Updated OTP Controller (`lib/features/authentication/controllers/otp_login_controller.dart`)
- Added retry logic for reCAPTCHA errors (up to 2 retries)
- Enhanced error handling for reCAPTCHA-specific errors
- Added automatic reCAPTCHA reset on errors
- Improved logging for debugging

## Testing Steps

### 1. Clear Browser Cache
1. Open browser developer tools (F12)
2. Right-click on refresh button
3. Select "Empty Cache and Hard Reload"

### 2. Check Console Logs
Look for these messages in the browser console:
- `reCAPTCHA API loaded`
- `reCAPTCHA rendered successfully with widget ID: [ID]`
- `reCAPTCHA ready for testing`

### 3. Test OTP Flow
1. Open the app in browser
2. Enter a test phone number (e.g., `0501234567`)
3. Select country code (SA)
4. Click "Send OTP"
5. Check console for success/error messages

## Debugging Commands

### Check reCAPTCHA Status
Open browser console and run:
```javascript
// Check if reCAPTCHA is ready
window.isRecaptchaReady()

// Check if verifier exists
window.recaptchaVerifier

// Manually reset reCAPTCHA
window.resetRecaptcha()

// Manually initialize reCAPTCHA
window.initializeRecaptcha()
```

### Common Issues and Solutions

1. **reCAPTCHA not loading**
   - Check internet connection
   - Clear browser cache
   - Try incognito mode

2. **Invalid application verifier**
   - Wait for reCAPTCHA to fully load
   - Try refreshing the page
   - Check console for error messages

3. **reCAPTCHA expired**
   - The system will automatically retry
   - Manual reset: `window.resetRecaptcha()`

## Expected Behavior

### Success Flow
1. Page loads → reCAPTCHA initializes
2. User enters phone number → validation passes
3. User clicks "Send OTP" → reCAPTCHA solves automatically
4. OTP sent successfully → user receives code

### Error Handling
1. reCAPTCHA fails → automatic retry (up to 2 times)
2. Still fails → user sees error message
3. User can refresh page and try again

## Test Phone Numbers
- Saudi Arabia: `0501234567`, `0502345678`, `0503456789`
- Syria: `944123456`, `944567890`
- UAE: `503780091`, `504567890`

## Notes
- reCAPTCHA is invisible and solves automatically
- The system includes automatic retry logic
- All errors are logged to console for debugging
- Fallback mechanisms ensure the app doesn't break if reCAPTCHA fails
