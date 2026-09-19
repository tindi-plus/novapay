// const { setGlobalOptions } = require("firebase-functions");
// const { onCall } = require("firebase-functions/v2/https");
// const { getFirestore } = require("firebase-admin/firestore");
// const admin = require("firebase-admin");
// const { HttpsError } = require("firebase-functions/v2/https");

// if (!admin.apps.length) {
//   admin.initializeApp();
// }

// const db = getFirestore();

// /**
//  * Production-grade idempotent send money function.
//  * Expects: { idempotencyKey, senderId, recipientId, amountInKobo, txId, note? }
//  * All amounts in positive integer Kobo. Uses Firestore transaction for atomicity + idempotency.
//  */
// exports.processSendMoney = onCall(async (request) => {
//   const { idempotencyKey, senderId, recipientId,
// amountInKobo, txId, note = "" } = request.data || {};

//   if (!request.auth) {
//     throw new HttpsError("unauthenticated", "Must be authenticated to send money.");
//   }
//   if (!idempotencyKey || !senderId || !recipientId || !amountInKobo || !txId) {
//     throw new HttpsError("invalid-argument",
// "Missing required fields: idempotencyKey, senderId, recipientId, amountInKobo, txId");
//   }
//   if (typeof amountInKobo !== "number" || amountInKobo <= 0 || !Number.isInteger(amountInKobo)) {
//     throw new HttpsError("invalid-argument", "amountInKobo must be a positive integer (Kobo)");
//   }
//   if (senderId === recipientId) {
//     throw new HttpsError("invalid-argument", "Cannot send money to yourself");
//   }

//   const idempotencyRef = db.collection("processed_idempotency_keys").doc(idempotencyKey);
//   const senderRef = db.collection("users").doc(senderId);
//   const recipientRef = db.collection("users").doc(recipientId);
//   const senderTxRef = senderRef.collection("transactions").doc(txId);
//   const recipientTxRef = recipientRef.collection("transactions").doc(txId);

//   return db.runTransaction(async (transaction) => {
//     // All reads first (idempotency + balances)
//     const idempotencyDoc = await transaction.get(idempotencyRef);
//     if (idempotencyDoc.exists) {
//       const cached = idempotencyDoc.data();
//       if (cached.status === "success") {
//         return {
//           success: true,
//           message: "Transaction already processed",
//           ...cached.responsePayload,
//         };
//       }
//       throw new HttpsError("already-exists", "Idempotency key exists with error state");
//     }

//     const senderDoc = await transaction.get(senderRef);
//     const recipientDoc = await transaction.get(recipientRef);

//     if (!senderDoc.exists) {
//       throw new HttpsError("not-found", "Sender account not found");
//     }
//     if (!recipientDoc.exists) {
//       throw new HttpsError("not-found", "Recipient account not found");
//     }

//     const senderBalance = senderDoc.data().balanceInKobo || 0;
//     if (senderBalance < amountInKobo) {
//       throw new HttpsError("failed-precondition", "Insufficient funds");
//     }

//     const now = admin.firestore.FieldValue.serverTimestamp();

//     // Debit ledger
//     transaction.set(senderTxRef, {
//       amountInKobo,
//       type: "debit",
//       title: "Send Money",
//       status: "completed",
//       counterpartyId: recipientId,
//       note,
//       createdAt: now,
//     });

//     // Credit ledger
//     transaction.set(recipientTxRef, {
//       amountInKobo,
//       type: "credit",
//       title: "Received Money",
//       status: "completed",
//       counterpartyId: senderId,
//       note,
//       createdAt: now,
//     });

//     // Update balances
//     transaction.update(senderRef, {
//       balanceInKobo: admin.firestore.FieldValue.increment(-amountInKobo),
//     });
//     transaction.update(recipientRef, {
//       balanceInKobo: admin.firestore.FieldValue.increment(amountInKobo),
//     });

//     // Idempotency record (caches result for offline replay)
//     const responsePayload = {
//       txId,
//       amountInKobo,
//       senderId,
//       recipientId,
//       timestamp: new Date().toISOString(),
//     };

//     transaction.set(idempotencyRef, {
//       status: "success",
//       timestamp: now,
//       responsePayload,
//       action: "processSendMoney",
//       createdAt: now,
//     });

//     return {
//       success: true,
//       message: "Send money processed successfully",
//       ...responsePayload,
//     };
//   });
// });


// baanceInKobo: admin.firestore.FieldValue.increment(-amountInKobo),

// transaction.update(recipientRef, {
//   balanceInKobo: admin.firestore.FieldValue.increment(amountInKobo),
// });

// // Idempotency record (caches result for offline replay)
// const responsePayload = {
//   txId,
//   amountInKobo,
//   senderId,
//   recipientId,
//   timestamp: new Date().toISOString(),
// };

// transaction.set(idempotencyRef, {
//   status: "success",
//   timestamp: now,
//   responsePayload,
//   action: "processSendMoney",
//   createdAt: now,
// });

// return {
//   success: true,
//   message: "Send money processed successfully",
//   ...responsePayload,
// };


// /**
//  * Import function triggers from their respective submodules:
//  *
//  * const {onCall} = require("firebase-functions/v2/https");
//  * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
//  *
//  * See a full list of supported triggers at https://firebase.google.com/docs/functions
//  */

// // const { setGlobalOptions } = require("firebase-functions");
// const { onRequest } = require("firebase-functions/https");
// const logger = require("firebase-functions/logger");

// /**
//  * Production-grade idempotent contribute to savings goal function.
//  * Expects: { idempotencyKey, userId, goalId, amountInKobo, txId, note? }
//  * All amounts in positive integer Kobo. Uses Firestore transaction for atomicity + idempotency.
//  */
// exports.contributeToSave = onCall(async (request) => {
//   const { idempotencyKey, userId, goalId, amountInKobo, txId, note = "" } = request.data || {};

//   if (!request.auth) {
//     throw new HttpsError("unauthenticated", "Must be authenticated to contribute to savings.");
//   }
//   if (!idempotencyKey || !userId || !goalId || !amountInKobo || !txId) {
//     throw new HttpsError("invalid-argument",
// "Missing required fields: idempotencyKey, userId, goalId, amountInKobo, txId");
//   }
//   if (typeof amountInKobo !== "number" || amountInKobo <= 0 || !Number.isInteger(amountInKobo)) {
//     throw new HttpsError("invalid-argument", "amountInKobo must be a positive integer (Kobo)");
//   }

//   const idempotencyRef = db.collection("processed_idempotency_keys").doc(idempotencyKey);
//   const userRef = db.collection("users").doc(userId);
//   const goalRef = userRef.collection("savingsGoals").doc(goalId);
//   const txRef = userRef.collection("transactions").doc(txId);

//   return db.runTransaction(async (transaction) => {
//     // All reads first (idempotency + balance + goal)
//     const idempotencyDoc = await transaction.get(idempotencyRef);
//     if (idempotencyDoc.exists) {
//       const cached = idempotencyDoc.data();
//       if (cached.status === "success") {
//         return {
//           success: true,
//           message: "Transaction already processed",
//           ...cached.responsePayload,
//         };
//       }
//       throw new HttpsError("already-exists", "Idempotency key exists with error state");
//     }

//     const userDoc = await transaction.get(userRef);
//     const goalDoc = await transaction.get(goalRef);

//     if (!userDoc.exists) {
//       throw new HttpsError("not-found", "User account not found");
//     }
//     if (!goalDoc.exists) {
//       throw new HttpsError("not-found", "Savings goal not found");
//     }

//     const userBalance = userDoc.data().balanceInKobo || 0;
//     if (userBalance < amountInKobo) {
//       throw new HttpsError("failed-precondition", "Insufficient funds");
//     }

//     const now = admin.firestore.FieldValue.serverTimestamp();

//     // Savings transaction ledger
//     transaction.set(txRef, {
//       amountInKobo,
//       type: "savings_contribution",
//       title: "Savings Contribution",
//       status: "completed",
//       goalId,
//       note,
//       createdAt: now,
//     });

//     // Update user balance and goal
//     transaction.update(userRef, {
//       balanceInKobo: admin.firestore.FieldValue.increment(-amountInKobo),
//     });
//     transaction.update(goalRef, {
//       currentAmountInKobo: admin.firestore.FieldValue.increment(amountInKobo),
//     });

//     // Idempotency record (caches result for offline replay)
//     const responsePayload = {
//       txId,
//       amountInKobo,
//       userId,
//       goalId,
//       timestamp: new Date().toISOString(),
//     };

//     transaction.set(idempotencyRef, {
//       status: "success",
//       timestamp: now,
//       responsePayload,
//       action: "contributeToSave",
//       createdAt: now,
//     });

//     return {
//       success: true,
//       message: "Contribution to savings goal successful",
//       ...responsePayload,
//     };
//   });
// });

// // For cost control, you can set the maximum number of containers that can be
// // running at the same time. This helps mitigate the impact of unexpected
// // traffic spikes by instead downgrading performance. This limit is a
// // per-function limit. You can override the limit for each function using the
// // `maxInstances` option in the function's options, e.g.
// // `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// // NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// // functions should each use functions.runWith({ maxInstances: 10 }) instead.
// // In the v1 API, each function can only serve one request per container, so
// // this will be the maximum concurrent request count.
// setGlobalOptions({ maxInstances: 10 });

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started

// // exports.helloWorld = onRequest((request, response) => {
// //   logger.info("Hello logs!", {structuredData: true});
// //   response.send("Hello from Firebase!");
// // });

const { setGlobalOptions } = require("firebase-functions/v2");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const admin = require("firebase-admin");

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = getFirestore();

// Limit instance concurrency for cost control
setGlobalOptions({ maxInstances: 10 });

/**
 * Production-grade idempotent send money function.
 * Expects: { idempotencyKey, senderId, recipientId, amountInKobo, txId?, note? }
 */
exports.processSendMoney = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated",
      "Must be authenticated to send money.");
  }

  const { idempotencyKey, senderId, recipientId,
    amountInKobo, note = "" } = request.data || {};
  const authUid = request.auth.uid;

  // Enforce caller authorization
  if (senderId !== authUid) {
    throw new HttpsError("permission-denied", "Sender identity mismatch.");
  }

  if (!idempotencyKey || !senderId || !recipientId || !amountInKobo) {
    throw new HttpsError(
      "invalid-argument",
      "Missing required fields: idempotencyKey, senderId, recipientId, amountInKobo",
    );
  }

  if (typeof amountInKobo !== "number" || amountInKobo <= 0 || !Number.isInteger(amountInKobo)) {
    throw new HttpsError("invalid-argument", "amountInKobo must be a positive integer (Kobo)");
  }

  if (senderId === recipientId) {
    throw new HttpsError("invalid-argument", "Cannot send money to yourself");
  }

  const txId = request.data.txId || `tx_${idempotencyKey}`;
  const idempotencyRef = db.collection("processed_idempotency_keys").doc(idempotencyKey);
  const senderRef = db.collection("users").doc(senderId);
  const recipientRef = db.collection("users").doc(recipientId);
  const senderTxRef = senderRef.collection("transactions").doc(txId);
  const recipientTxRef = recipientRef.collection("transactions").doc(txId);

  return db.runTransaction(async (transaction) => {
    // 1. Read operations first
    const idempotencyDoc = await transaction.get(idempotencyRef);
    if (idempotencyDoc.exists) {
      const cached = idempotencyDoc.data();
      if (cached.status === "success") {
        return {
          success: true,
          message: "Transaction already processed",
          ...cached.responsePayload,
        };
      }
      throw new HttpsError("already-exists", "Idempotency key exists with error state");
    }

    const senderDoc = await transaction.get(senderRef);
    const recipientDoc = await transaction.get(recipientRef);

    if (!senderDoc.exists) {
      throw new HttpsError("not-found", "Sender account not found");
    }
    if (!recipientDoc.exists) {
      throw new HttpsError("not-found", "Recipient account not found");
    }

    const senderBalance = senderDoc.data().walletBalanceInKobo || 0;
    if (senderBalance < amountInKobo) {
      throw new HttpsError("failed-precondition", "Insufficient funds");
    }

    const now = FieldValue.serverTimestamp();

    // 2. Write operations
    transaction.set(senderTxRef, {
      amountInKobo,
      type: "debit",
      title: "Send Money",
      status: "completed",
      counterpartyId: recipientId,
      note,
      createdAt: now,
    });

    transaction.set(recipientTxRef, {
      amountInKobo,
      type: "credit",
      title: "Received Money",
      status: "completed",
      counterpartyId: senderId,
      note,
      createdAt: now,
    });

    transaction.update(senderRef, {
      walletBalanceInKobo: FieldValue.increment(-amountInKobo),
    });

    transaction.update(recipientRef, {
      walletBalanceInKobo: FieldValue.increment(amountInKobo),
    });

    const responsePayload = {
      txId,
      amountInKobo,
      senderId,
      recipientId,
      timestamp: new Date().toISOString(),
    };

    transaction.set(idempotencyRef, {
      status: "success",
      timestamp: now,
      responsePayload,
      action: "processSendMoney",
      createdAt: now,
    });

    return {
      success: true,
      message: "Send money processed successfully",
      ...responsePayload,
    };
  });
});

/**
 * Production-grade idempotent contribute to savings goal function.
 * Expects: { idempotencyKey, userId, goalId, amountInKobo, txId?, note? }
 */
exports.contributeToSave = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Must be authenticated to contribute to savings.");
  }

  const { idempotencyKey, userId, goalId, amountInKobo, note = "" } = request.data || {};
  const authUid = request.auth.uid;

  // Enforce caller authorization
  if (userId !== authUid) {
    throw new HttpsError("permission-denied", "User identity mismatch.");
  }

  if (!idempotencyKey || !userId || !goalId || !amountInKobo) {
    throw new HttpsError(
      "invalid-argument",
      "Missing required fields: idempotencyKey, userId, goalId, amountInKobo",
    );
  }

  if (typeof amountInKobo !== "number" || amountInKobo <= 0 || !Number.isInteger(amountInKobo)) {
    throw new HttpsError("invalid-argument", "amountInKobo must be a positive integer (Kobo)");
  }

  const txId = request.data.txId || `tx_${idempotencyKey}`;
  const idempotencyRef = db.collection("processed_idempotency_keys").doc(idempotencyKey);
  const userRef = db.collection("users").doc(userId);
  const goalRef = userRef.collection("savingsGoals").doc(goalId);
  const txRef = userRef.collection("transactions").doc(txId);

  return db.runTransaction(async (transaction) => {
    // 1. Read operations first
    const idempotencyDoc = await transaction.get(idempotencyRef);
    if (idempotencyDoc.exists) {
      const cached = idempotencyDoc.data();
      if (cached.status === "success") {
        return {
          success: true,
          message: "Transaction already processed",
          ...cached.responsePayload,
        };
      }
      throw new HttpsError("already-exists", "Idempotency key exists with error state");
    }

    const userDoc = await transaction.get(userRef);
    const goalDoc = await transaction.get(goalRef);

    if (!userDoc.exists) {
      throw new HttpsError("not-found", "User account not found");
    }
    if (!goalDoc.exists) {
      throw new HttpsError("not-found", "Savings goal not found");
    }

    const userBalance = userDoc.data().walletBalanceInKobo || 0;
    if (userBalance < amountInKobo) {
      throw new HttpsError("failed-precondition", "Insufficient funds");
    }

    const now = FieldValue.serverTimestamp();

    // 2. Write operations
    transaction.set(txRef, {
      amountInKobo,
      type: "savings_contribution",
      title: "Savings Contribution",
      status: "completed",
      goalId,
      note,
      createdAt: now,
    });

    transaction.update(userRef, {
      walletBalanceInKobo: FieldValue.increment(-amountInKobo),
    });

    transaction.update(goalRef, {
      currentAmountInKobo: FieldValue.increment(amountInKobo),
    });

    const responsePayload = {
      txId,
      amountInKobo,
      userId,
      goalId,
      timestamp: new Date().toISOString(),
    };

    transaction.set(idempotencyRef, {
      status: "success",
      timestamp: now,
      responsePayload,
      action: "contributeToSave",
      createdAt: now,
    });

    return {
      success: true,
      message: "Contribution to savings goal successful",
      ...responsePayload,
    };
  });
});
