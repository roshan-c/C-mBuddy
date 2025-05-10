# Phase 1: Core Model & Logic Modification (Decoupling from BeReal's Constraints)

This phase focuses on adapting the core data structures and application logic to fit the "Cum Buddy" concept, moving away from BeReal's specific features and limitations. We will continue using Firebase as the backend.

## Task 1.1: Redefine the "Post" Model for Logs

*   **Target File:** `client/lib/model/post.module.dart`
*   **Actions:**
    *   Rename `PostModel` class to `LogModel` (or a similar descriptive name, e.g., `MasturbationLogModel`).
    *   **Field Modifications:**
        *   **Remove:** `imageFrontPath` (String)
        *   **Remove:** `imageBackPath` (String)
        *   **Keep & Potentially Repurpose:** `bio` (String) -> Rename to `notes` (String, optional, for user's private thoughts).
        *   **Keep:** `createdAt` (String/DateTime) - Represents the timestamp of the log.
        *   **Keep:** `user` (UserModel) - Represents the user who created the log.
        *   **Keep:** `key` (String) - Unique identifier for the log.
    *   **New Fields to Add:**
        *   `intensity_rating`: `int?` (e.g., 1-5, optional).
        *   `duration_minutes`: `int?` (optional).
        *   `location`: `String?` (optional, e.g., "Home", "Bed" - could be user-defined or selected from a predefined list).
        *   `was_partner_involved`: `bool` (defaults to `false`).
        *   *(Consider: `custom_tags`: `List<String>?` (optional, for user-defined categorization)).*
    *   **Method Updates:**
        *   Update the `toJson()` method to serialize all new and modified fields to a format suitable for Firebase.
        *   Update the `fromJson(Map<dynamic, dynamic> map)` constructor/factory to correctly deserialize data from Firebase into the `LogModel`.

## Task 1.2: Update Firebase Interaction for New `LogModel`

*   **Target Files:**
    *   Primarily `client/lib/state/post.state.dart` (to be renamed `log.state.dart`).
    *   Any UI files or services directly writing to Firebase (e.g., where posts are currently created after camera capture).
*   **Actions:**
    *   Ensure that `LogModel` objects are correctly serialized to and deserialized from Firebase Realtime Database.
    *   Decide on Firebase Database Path:
        *   Option A (Simpler): Continue using the existing `/posts` node in Firebase, but store `LogModel` data there.
        *   Option B (Cleaner): Migrate to a new `/logs` node. This would require updating database queries.
        *   *(Recommendation: Start with Option A for simplicity, can refactor to Option B later if needed).*
    *   Review and update Firebase Database Rules (`database.rules.json` if it exists, or through Firebase console):
        *   Ensure rules allow reads/writes for the new `LogModel` structure under the chosen path.
        *   Maintain user ownership rules (users can only write/edit their own logs).

## Task 1.3: Remove Posting Limitations & Restrictions

*   **Target Files & Logic:**
    *   `client/lib/state/post.state.dart` (specifically the `getPostList` method or similar filtering logic that currently enforces the 24-hour visibility).
    *   `client/lib/pages/home.dart` or other UI pages that might have logic controlling the availability of the post creation button (e.g., based on time or whether a post has already been made that day).
    *   Any notification handling code (e.g., in `client/lib/notification/`) that was previously used to trigger the BeReal daily posting window.
*   **Actions:**
    *   **Eliminate 24-hour visibility:** Modify or remove the filtering in `post.state.dart` (soon to be `log.state.dart`) that hides posts older than 24 hours. Logs should be persistent.
    *   **Enable continuous posting:** Remove any checks or UI disabling logic that prevents users from creating multiple logs per day or at any time they choose. The "New Log" button/action should always be available.
    *   **Deactivate BeReal posting window:** Disable or remove any logic related to daily specific-time posting prompts or notifications.

## Task 1.4: Adapt Log State Management

*   **Target File:** `client/lib/state/post.state.dart`
*   **Actions:**
    *   **Rename File and Class:** Rename `post.state.dart` to `log.state.dart`. Rename the `PostState` class to `LogState` (or similar). Update all import statements referencing this file/class.
    *   **Update Model Usage:** Replace all instances of `PostModel` with `LogModel`.
    *   **Adapt Data Fetching:** Ensure `getDataFromDatabase()` and `onPostAdded()` (or their equivalents) correctly process `LogModel` data from Firebase.
    *   **Refine `getPostList` (or `getLogList`):**
        *   Remove the 24-hour filter.
        *   Ensure it correctly filters logs for the current user's feed (e.g., own logs, friends' logs based on future sharing preferences). For now, it might just show all logs the user has access to.
    *   Update any other methods in the state class that interact with or depend on the structure of `PostModel`. 