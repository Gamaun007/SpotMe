import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

export const generateInviteCode = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError("unauthenticated", "Must be signed in.");

  const trainerId = context.auth.uid;
  const code = Math.random().toString(36).substring(2, 8).toUpperCase();
  const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24h

  await db.collection("inviteCodes").doc(code).set({
    code,
    trainerId,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    expiresAt,
    used: false,
    usedBy: null,
  });

  return { code };
});

export const acceptInviteCode = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError("unauthenticated", "Must be signed in.");

  const traineeId = context.auth.uid;
  const { code } = data;

  const codeDoc = await db.collection("inviteCodes").doc(code).get();
  if (!codeDoc.exists) throw new functions.https.HttpsError("not-found", "Invalid invite code.");

  const invite = codeDoc.data()!;
  if (invite.used) throw new functions.https.HttpsError("already-exists", "Invite code already used.");
  if (invite.expiresAt.toDate() < new Date()) throw new functions.https.HttpsError("deadline-exceeded", "Invite code expired.");

  const batch = db.batch();

  batch.update(db.collection("inviteCodes").doc(code), { used: true, usedBy: traineeId });
  batch.set(db.collection("relationships").doc(), {
    trainerId: invite.trainerId,
    traineeId,
    status: "active",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: null,
  });

  await batch.commit();
  return { success: true };
});
