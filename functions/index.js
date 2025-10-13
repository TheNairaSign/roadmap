
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Sends a notification when a roadmap reaches 50% or 100% progress.
onst onRoadmapProgressUpdate = functions.firestore
  .document("users/{userId}/roadmaps/{roadmapId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    if (before.progress === after.progress) {
      return null;
    }

    let message = null;
    if (before.progress < 0.5 && after.progress >= 0.5) {
      message = `You've reached 50% progress on your "${after.title}" roadmap!`;
    } else if (before.progress < 1.0 && after.progress >= 1.0) {
      message = `Congratulations! You've completed your "${after.title}" roadmap!`;
    }

    if (message) {
      const payload = {
        notification: {
          title: "Roadmap Progress Update",
          body: message,
        },
      };

      const userId = context.params.userId;
      const userDoc = await admin.firestore().collection("users").doc(userId).get();
      const fcmToken = userDoc.data().fcmToken; // Assuming you store the FCM token in the user's document

      if (fcmToken) {
        return admin.messaging().sendToDevice(fcmToken, payload);
      }
    }

    return null;
  });

// Sends a reminder for milestones with deadlines (e.g., 24 hours before).
// This function would need to be triggered on a schedule (e.g., daily) using a cron job service.
const onMilestoneDeadline = functions.pubsub.schedule("every 24 hours").onRun(async (context) => {
  const now = admin.firestore.Timestamp.now();
  const tomorrow = admin.firestore.Timestamp.fromMillis(now.toMillis() + 24 * 60 * 60 * 1000);

  const querySnapshot = await admin.firestore().collectionGroup("milestones")
    .where("deadline", ">=", now)
    .where("deadline", "<= ", tomorrow)
    .where("status", "!=", "done")
    .get();

  querySnapshot.forEach(async (doc) => {
    const milestone = doc.data();
    const roadmapRef = doc.ref.parent.parent;
    const userRef = roadmapRef.parent.parent;

    const userDoc = await userRef.get();
    const fcmToken = userDoc.data().fcmToken;

    if (fcmToken) {
      const payload = {
        notification: {
          title: "Milestone Deadline Reminder",
          body: `Your milestone "${milestone.title}" is due soon!`, 
        },
      };
      await admin.messaging().sendToDevice(fcmToken, payload);
    }
  });

  return null;
});

module.exports = {
    onRoadmapProgressUpdate,
    onMilestoneDeadline
}
