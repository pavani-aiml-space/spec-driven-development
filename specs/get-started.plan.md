# Get Started - Account Creation Test Plan

## Application Overview

This test plan covers the /get-started page of the HomeBuy application, which presents a "Start by Creating Your Free Account" sign-up form (Email, Password, First Name, Last Name, Terms of Use checkbox, and a "Create account" button). All fields are marked as required (including the checkbox) and rely on native HTML5 form validation. Submitting the form successfully transitions the panel to an "Your account is ready!" confirmation screen with a "Continue into HomeBuy" button, which then navigates the user into the authenticated application (/my-offer-empty). This plan focuses narrowly on the /get-started page and the account-creation flow it kicks off: one happy-path scenario plus the two most important validation edge cases (missing required text/email/password fields, and the required Terms of Use checkbox being left unchecked).

## Test Scenarios

### 1. Get Started - Account Creation

**Seed:** ``

#### 1.1. Happy path - create account with valid details

**File:** `tests/get-started/create-account-happy-path.spec.ts`

**Steps:**
  1. Navigate to the /get-started page (fresh/unauthenticated browser context, no prior session).
    - expect: The page loads with title 'Welcome - HomeBuy'.
    - expect: A heading 'Congrats on finding your dream home. Now let's create your offer.' is visible in the main content area.
    - expect: A sidebar panel titled 'Start by Creating Your Free Account' is visible containing Email, Password, First Name, and Last Name fields, a 'I agree to the Terms of Use and Privacy Policy' checkbox, and a 'Create account' button.
  2. Fill the Email field with a valid, unique email address (e.g. a timestamped address such as testuser+<timestamp>@example.com).
    - expect: The typed value is displayed in the Email field.
  3. Fill the Password field with a valid password (e.g. 'SecurePass123!').
    - expect: The typed value is accepted in the Password field (masked).
  4. Fill the First Name field with a valid first name (e.g. 'Test').
    - expect: The typed value is displayed in the First Name field.
  5. Fill the Last Name field with a valid last name (e.g. 'User').
    - expect: The typed value is displayed in the Last Name field.
  6. Check the 'I agree to the Terms of Use and Privacy Policy' checkbox.
    - expect: The checkbox becomes checked.
  7. Click the 'Create account' button.
    - expect: The form panel is replaced with a confirmation panel showing the heading 'Your account is ready!' and the text 'Get ready to place an offer when you find your dream home.'
    - expect: A 'Continue into HomeBuy' button is visible in place of the sign-up form.
    - expect: No validation errors are shown.
  8. Click the 'Continue into HomeBuy' button.
    - expect: The browser navigates away from /get-started to an authenticated application page (URL path changes to '/my-offer-empty' with a request_id query parameter), confirming the onboarding flow completed successfully.

#### 1.2. Validation - submitting an empty form is blocked and highlights required fields

**File:** `tests/get-started/create-account-empty-form-validation.spec.ts`

**Steps:**
  1. Navigate to the /get-started page (fresh/unauthenticated browser context, no prior session).
    - expect: The 'Start by Creating Your Free Account' form is visible with all fields empty and the Terms checkbox unchecked.
  2. Without filling in any fields, click the 'Create account' button.
    - expect: The form is not submitted and the page remains on /get-started.
    - expect: Focus moves to the first invalid required field (the Email input), and the browser's native 'required field' validation indicator/tooltip is triggered (the Email input has an empty value and is marked required/type=email).
    - expect: No confirmation panel ('Your account is ready!') is shown.
  3. Fill only the Email field with a valid email address and click 'Create account' again.
    - expect: The form is still not submitted because Password, First Name, Last Name, and the Terms checkbox remain empty/unchecked and required.
    - expect: Focus/validation moves to the next empty required field (Password).
    - expect: The page remains on /get-started with no confirmation panel shown.

#### 1.3. Validation - required Terms of Use checkbox blocks submission even when all other fields are valid

**File:** `tests/get-started/create-account-terms-checkbox-validation.spec.ts`

**Steps:**
  1. Navigate to the /get-started page (fresh/unauthenticated browser context, no prior session).
    - expect: The 'Start by Creating Your Free Account' form is visible with all fields empty and the Terms checkbox unchecked.
  2. Fill the Email field with a valid, unique email address, the Password field with a valid password, the First Name field with a valid name, and the Last Name field with a valid name. Leave the 'I agree to the Terms of Use and Privacy Policy' checkbox unchecked.
    - expect: All four text fields display the entered values and the Terms checkbox remains unchecked.
  3. Click the 'Create account' button.
    - expect: The form is not submitted; the page remains on /get-started and no account-created confirmation is shown.
    - expect: Focus/validation moves to the Terms of Use checkbox, indicating it is a required field that must be checked before the form can be submitted.
  4. Check the 'I agree to the Terms of Use and Privacy Policy' checkbox, then click 'Create account' again.
    - expect: The form now submits successfully and the confirmation panel with heading 'Your account is ready!' and a 'Continue into HomeBuy' button is displayed, confirming the checkbox was the only blocker.

## Proposed Tags (pending confirmation)

| Scenario | Proposed tag | Rationale |
|---|---|---|
| 1.1 Happy path - create account with valid details | `@smoke` | This *is* the get-started flow's critical path — if it breaks, no one can sign up at all. |
| 1.2 Validation - empty form is blocked | `@regression` | Confirms required-field validation works; important, but the app isn't unusable if this one specific check regresses. |
| 1.3 Validation - Terms checkbox blocks submission | `@regression` | Same reasoning as 1.2 — a supported rule on top of the already-covered critical path, not the critical path itself. |

**Status:** applied to the generated tests already (see [tests/get-started/](../tests/get-started/)) — flagging here for retroactive sign-off since this table didn't exist yet when tagging happened. Please confirm or override.
