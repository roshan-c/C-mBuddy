# Phase 2: UI/UX Overhaul for "Cum Buddy"

This phase focuses on transforming the user interface and user experience from the BeReal clone to the "Cum Buddy" application. This includes creating new screens, modifying existing ones, and updating the overall branding.

## Task 2.1: New Log Creation Interface

*   **Objective:** Replace the current camera-centric post creation UI with a form-based interface for inputting log details.
*   **Affected Areas:**
    *   Likely need a new Dart file in `client/lib/pages/` (e.g., `create_log.dart`).
    *   Navigation logic from where the "new log" action is triggered (e.g., a button on `home.dart` or a floating action button).
    *   Widgets in `client/lib/widget/` for form fields.
*   **Actions:**
    *   Design the UI for the "New Log" screen. This should include input fields for:
        *   `notes` (Text field, possibly multi-line).
        *   `intensity_rating` (e.g., a slider, star rating, or segmented control).
        *   `duration_minutes` (Number input).
        *   `location` (Text input, or dropdown if predefined).
        *   `was_partner_involved` (Switch or checkbox).
        *   *(Any other fields added to `LogModel`)*.
    *   Implement the form using Flutter widgets.
    *   Handle form validation (e.g., ensure duration is a positive number if entered).
    *   On submission, create a `LogModel` instance and save it to Firebase (this might call a method in `LogState` or a dedicated service).
    *   Remove or repurpose the existing camera interface flow (`client/lib/camera/`).

## Task 2.2: Update Feed Display

*   **Target File:** `client/lib/pages/feed.dart`
*   **Objective:** Modify the main feed to display "logs" appropriately, instead of BeReal's dual-camera image posts.
*   **Actions:**
    *   Redesign the list item widget used in the feed to display information from `LogModel`.
    *   **Information to Display per Log:**
        *   Timestamp (`createdAt`).
        *   User who posted (if a friend's feed is implemented).
        *   Non-sensitive summary of the log. For example:
            *   Icon for location (if provided).
            *   Visual representation of intensity (if provided).
            *   Duration (if provided).
        *   **Crucially, `notes` should generally NOT be displayed directly in a multi-user feed unless it's explicitly a "shared note" feature (which is not currently in scope). Focus on less sensitive, structured data.**
    *   Remove any UI elements specific to displaying front and back images.
    *   Ensure the feed correctly fetches and displays data using `LogState` and `LogModel`.

## Task 2.3: Update Profile Pages

*   **Target Files:** `client/lib/pages/myprofile.dart`, `client/lib/pages/profile.dart`
*   **Objective:** Adapt user profile pages to show a history of their logs and relevant information.
*   **Actions:**
    *   **`myprofile.dart` (User's own profile):**
        *   Display a list or summary of the user's own logs. This could be a chronological list, a calendar view highlighting days with logs, or summary statistics.
        *   Allow access to view full details of their own logs.
    *   **`profile.dart` (Viewing another user's profile):**
        *   Decide what log information, if any, is visible to other users (friends). This needs careful consideration for privacy.
        *   Perhaps only show aggregated, non-identifying stats (e.g., "User has X logs this month," or total count, but not individual log details unless explicitly shared).
        *   Remove the grid display of BeReal image posts.
    *   Update data fetching to use `LogModel` and display it appropriately.

## Task 2.4: General Theming, Text, and Branding

*   **Objective:** Ensure the entire application consistently reflects the "Cum Buddy" name, purpose, and desired tone.
*   **Actions:**
    *   **Text Replacement:**
        *   Search and replace "BeReal", "ReBeal", "Post", "Memory", "RealMoji", etc., with "Cum Buddy", "Log", or other appropriate terms.
        *   Update button labels, page titles, in-app messages, and notifications.
    *   **Asset Updates:**
        *   Replace the app icon.
        *   Update any other visual assets (e.g., splash screen, placeholders) if they exist and are BeReal-specific.
    *   **Styling:**
        *   Review and adjust colors, fonts, and overall app style (`client/lib/styles/`) if desired to create a unique feel for "Cum Buddy." Maintain a respectful and non-exploitative design.
    *   **Metadata:**
        *   Update `pubspec.yaml`: Change `name` and `description`.
        *   Update `README.md`: Reflect the new app's purpose.
        *   Check Android (`AndroidManifest.xml`) and iOS (`Info.plist`) for app name occurrences.
    *   Review `LICENSE`, `CONTRIBUTING.md`, etc., and update or remove as appropriate for the repurposed project. 