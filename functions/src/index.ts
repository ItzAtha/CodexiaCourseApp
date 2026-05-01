/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {setGlobalOptions} from "firebase-functions";

import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({maxInstances: 10});

admin.initializeApp();

// eslint-disable-next-line max-len
export const cleanupUserData = functions.auth.user().onDelete(async (user) => {
  const uid = user.uid;
  const db = admin.firestore();
  const bucket = admin.storage().bucket();

  console.log(`Starting precise cleanup for user: ${uid}`);

  // Delete user data on Firebase Firestore based on the current logged account
  const linkedProvider = user.providerData;
  if (!linkedProvider || linkedProvider.length === 0) {
    console.log(`No providers linked to user ${uid}, nothing to delete.`);
    return "NO_PROVIDERS_FOUND";
  }

  // Delete user avatar if exists on Firebase Cloud Storage
  const username = user.displayName?.toLowerCase();
  if (username) {
    const avatarPath = `Avatars/${username}_avatar.jpg`;
    const file = bucket.file(avatarPath);

    try {
      const [exists] = await file.exists();
      if (exists) {
        await file.delete();
        console.log(`Successfully deleted avatar at: ${avatarPath}`);
      } else {
        console.log(`No avatar found at: ${avatarPath}`);
      }
    } catch (error) {
      console.error(`Failed to delete avatar for user ${uid}:`, error);
    }
  } else {
    console.log(`User ${uid} had no displayName. Skipping avatar deletion.`);
  }

  try {
    const batch = db.batch();
    let deleteCount = 0;

    linkedProvider.forEach((providerInfo) => {
      const providerId = providerInfo.providerId;
      const exactDocId = `${uid}_${providerId}`;

      // eslint-disable-next-line max-len
      const docRef = db.collection("Users").doc(exactDocId);
      batch.delete(docRef);

      deleteCount++;
      console.log(`Queued exact document for deletion: ${exactDocId}`);
    });

    if (deleteCount > 0) {
      await batch.commit();
      // eslint-disable-next-line max-len
      console.log(`Successfully deleted ${deleteCount} provider-specific documents for user: ${uid}`);
      return "SUCCESS_DELETE_DOCUMENTS";
    }

    return "NO_DOCUMENTS_QUEUED";
  } catch (error) {
    console.error(`Error deleting data for user ${uid}:`, error);

    throw new functions.https.HttpsError(
      "internal",
      `Failed to clean up Firestore data for deleted user: ${uid}`,
    );
  }
});
