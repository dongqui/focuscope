/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { setGlobalOptions } from "firebase-functions";
import { onRequest } from "firebase-functions/https";
import axios from "axios";
import jwt from "jsonwebtoken";
import admin from "firebase-admin";

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
setGlobalOptions({ maxInstances: 10 });

export const appleSignIn = onRequest(async (request, response) => {
  const code = request.body.code;
  if (!code) {
    response.status(400).send("Missing code");
  }

  // Create client_secret (JWT)
  const token = jwt.sign({}, process.env.APPLE_PRIVATE_KEY || "", {
    algorithm: "ES256",
    expiresIn: "1h",
    issuer: process.env.APPLE_TEAM_ID,
    audience: "https://appleid.apple.com",
    subject: process.env.APPLE_CLIENT_ID,
    keyid: process.env.APPLE_KEY_ID,
  });

  const params = new URLSearchParams({
    grant_type: "authorization_code",
    code,
    client_id: process.env.APPLE_CLIENT_ID || "",
    client_secret: token,
  });

  try {
    const res = await axios.post(
      "https://appleid.apple.com/auth/token",
      params.toString(),
      {
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
      }
    );

    const idToken = res.data.id_token;
    const appleUser = jwt.decode(idToken);

    const token = typeof appleUser?.sub === "string" ? appleUser.sub : "";
    const firebaseToken = await admin.auth().createCustomToken(token);
    response.send({ firebaseToken });
  } catch (err: any) {
    console.error(err.response?.data || err.message);
    response.status(500).send("Apple login failed");
  }
});
