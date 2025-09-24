# OTP Testing Guide

## Overview
This guide explains how to test the OTP (One-Time Password) functionality in the Brother Admin Panel.

## Test Phone Numbers
The following phone numbers are pre-configured for testing:

### Saudi Arabia (SA)
- `0501234567` - Manager (أحمد محمد)
- `0502345678` - Manager (فاطمة علي)  
- `0503456789` - Manager (محمد أحمد)
- `501234567` - Admin (سارة أحمد)
- `502345678` - Admin (خالد محمد)

### Syria (SY)
- `944123456` - Manager (أحمد السوري)
- `944567890` - Admin (فاطمة السورية)

### UAE (AE)
- `503780091` - Manager (خالد الإماراتي)
- `504567890` - Admin (نور الإماراتية)

## How to Test

### 1. Web Testing
1. Open the application in a web browser
2. Navigate to the login page
3. Select the appropriate country code (SA, SY, or AE)
4. Enter one of the test phone numbers above
5. Click "Send OTP"
6. Check the browser console for the verification code (in development mode)

### 2. Mobile Testing
1. Run the app on a mobile device
2. Follow the same steps as web testing
3. The OTP will be sent via SMS to the actual phone number

## Expected Behavior

### Successful Flow
1. Phone number validation passes
2. Authorization check succeeds (phone number is in the authorized list)
3. OTP is sent successfully
4. User receives verification code
5. User enters code and gets logged in

### Error Cases
1. **Invalid phone number**: Shows validation error
2. **Unauthorized phone number**: Shows "غير مصرح" error
3. **Invalid OTP**: Shows "رمز التحقق غير صحيح" error
4. **Network error**: Shows appropriate error message

## Debugging

### Console Logs
Check the browser console for detailed logs:
- `🔍 Checking authorization for: [phone]`
- `📱 Sending OTP to: [formatted_phone]`
- `✅ Code sent successfully`
- `❌ Verification failed: [error]`

### Common Issues
1. **reCAPTCHA errors**: Refresh the page and try again
2. **Phone format issues**: Ensure the phone number matches the expected format
3. **Authorization failures**: Check if the phone number is in the authorized list

## Firebase Configuration
The app uses Firebase Authentication with reCAPTCHA v2 for web platforms. The configuration is in `web/index.html`.

## Notes
- The OTP functionality works on both web and mobile platforms
- reCAPTCHA is required for web platforms
- Phone numbers must be in the authorized list to receive OTP
- Test phone numbers are automatically loaded when Firebase is unavailable
