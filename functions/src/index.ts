/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { setGlobalOptions } from "firebase-functions";
import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";

// Initialize Firebase Admin
admin.initializeApp();

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

// 데이터 타입 정의
interface ResourceVersion {
  id: string;
  version: number;
  version_major: number;
  version_minor: number;
  version_patch: number;
  createdAt: admin.firestore.Timestamp | Date;
}

interface Resources {
  id: string;
  resourceType: string;
  version: number;
  addedAt: admin.firestore.Timestamp | Date;
  description?: string;
  name: string;

  // Planet
  url?: string;

  // Character
  travelframes?: number[];
  travelSprite?: string;
  idleSprite?: string;
  idleFrames?: number[];
  isPremium?: boolean;
}

// 리소스 버전 정보를 가져오는 함수
export const getResourceVersion = onRequest(
  { maxInstances: 10 },
  async (request, response) => {
    try {
      const db = admin.firestore();
      const query = db.collection("resourceVersions");

      // 모든 리소스 타입의 최신 버전을 가져오기
      const snapshot = await query
        .orderBy("version_major", "desc")
        .orderBy("version_minor", "desc")
        .orderBy("version_patch", "desc")
        .limit(1)
        .get();

      if (snapshot.empty) {
        response.status(404).json({
          success: false,
          error: "No resource versions found",
          data: null,
        });
        return;
      }

      const doc = snapshot.docs[0];
      const data = doc.data() as ResourceVersion;
      response.json({
        success: true,
        data,
      });
    } catch (error) {
      logger.error("Error getting resource version:", error);
      response.status(500).json({
        success: false,
        error: error instanceof Error ? error.message : "Unknown error",
        data: null,
      });
    }
  }
);

// 요청받은 버전과 최신 버전 사이의 모든 리소스를 가져오는 함수
export const getResourcesBetweenVersions = onRequest(
  { maxInstances: 10 },
  async (request, response) => {
    try {
      const currentDeviceVersion = request.query["version"] as string;

      if (!currentDeviceVersion) {
        response.status(400).json({
          success: false,
          error: "Current device version is required",
          data: null,
        });
        return;
      }

      const db = admin.firestore();
      // 현재 디바이스 버전과 최신 버전 사이의 모든 버전들을 가져오기
      const deviceVersionQuery = db
        .collection("resourceVersions")
        .where("version", "==", currentDeviceVersion);

      const deviceVersionSnapshot = await deviceVersionQuery.get();
      const deviceVersion =
        deviceVersionSnapshot.docs[0].data() as ResourceVersion;

      const versionsBetweenQuery = db
        .collection("resourceVersions")
        .where("createdAt", ">", deviceVersion.createdAt)
        .orderBy("createdAt", "desc");
      const versionsBetweenSnapshot = await versionsBetweenQuery.get();

      // 각 버전에 대해 해당하는 리소스들을 가져오기
      const resources: Resources[] = [];

      for (const versionDoc of versionsBetweenSnapshot.docs) {
        const versionData = versionDoc.data() as ResourceVersion;

        // 해당 버전의 리소스들을 가져오기
        const resourcesQuery = db
          .collection("resources")
          .where("version", "==", versionData.version);

        const resourcesSnapshot = await resourcesQuery.get();

        resourcesSnapshot.docs.forEach((resourceDoc) => {
          resources.push(resourceDoc.data() as Resources);
        });
      }

      response.json({
        success: true,
        data: {
          resources: resources,
          version: versionsBetweenSnapshot.docs[0].data() as ResourceVersion,
        },
      });
    } catch (error) {
      logger.error("Error getting resources between versions:", error);
      response.status(500).json({
        success: false,
        error: error instanceof Error ? error.message : "Unknown error",
        data: null,
      });
    }
  }
);
