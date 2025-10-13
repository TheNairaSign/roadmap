
# Roadmap Templates

This file contains the data for the roadmap templates. You can add these to your Firestore database manually or by running the provided script.

## Manual Setup

1.  Go to your Firebase console and open the Firestore Database section.
2.  Create a new collection named `templates`.
3.  Add a new document for each template below. The document ID can be auto-generated.

### Full-Stack Developer Template

**Document Data:**
```json
{
  "title": "Full-Stack Developer Roadmap 2025",
  "description": "A complete guide to becoming a Full-Stack Developer in 2025.",
  "progress": 0,
  "createdAt": "(server timestamp)",
  "updatedAt": "(server timestamp)",
  "source": "template"
}
```

**Milestones Subcollection:**

After creating the template document, create a subcollection named `milestones` within it. Add the following documents to the `milestones` subcollection:

*   **Milestone 1:**
    ```json
    {
      "title": "Learn HTML, CSS, and JavaScript",
      "order": 0,
      "status": "not_started",
      "createdAt": "(server timestamp)"
    }
    ```
*   **Milestone 2:**
    ```json
    {
      "title": "Learn a Frontend Framework (React, Vue, or Angular)",
      "order": 1,
      "status": "not_started",
      "createdAt": "(server timestamp)"
    }
    ```
*   **Milestone 3:**
    ```json
    {
      "title": "Learn a Backend Language (Node.js, Python, or Go)",
      "order": 2,
      "status": "not_started",
      "createdAt": "(server timestamp)"
    }
    ```

### Fitness Plan Template

**Document Data:**
```json
{
  "title": "3-Month Fitness Plan",
  "description": "A plan to improve your fitness over 3 months.",
  "progress": 0,
  "createdAt": "(server timestamp)",
  "updatedAt": "(server timestamp)",
  "source": "template"
}
```

**Milestones Subcollection:**

*   **Milestone 1:**
    ```json
    {
      "title": "Month 1: Build a consistent workout routine",
      "order": 0,
      "status": "not_started",
      "createdAt": "(server timestamp)"
    }
    ```
*   **Milestone 2:**
    ```json
    {
      "title": "Month 2: Increase intensity and focus on nutrition",
      "order": 1,
      "status": "not_started",
      "createdAt": "(server timestamp)"
    }
    ```
*   **Milestone 3:**
    ```json
    {
      "title": "Month 3: Advanced workouts and progress tracking",
      "order": 2,
      "status": "not_started",
      "createdAt": "(server timestamp)"
    }
    ```
