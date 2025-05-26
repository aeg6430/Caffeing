import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import axios from "axios";

const IAP_JWT_HEADER = "x-goog-iap-jwt-assertion";
const IAP_ISSUER = "https://cloud.google.com/iap";
const IAP_CLIENT_ID = process.env.IAP_CLIENT_ID || ""; 

async function getGooglePublicKeys(): Promise<Record<string, string>> {
  const response = await axios.get("https://www.gstatic.com/iap/verify/public_key");
  return response.data;
}

export async function validateIapJwt(req: Request, res: Response, next: NextFunction) {
  const jwtAssertion = req.header(IAP_JWT_HEADER);
  if (!jwtAssertion) return res.status(401).send("No IAP JWT found");

  try {
    const keys = await getGooglePublicKeys();
    const decodedHeader = jwt.decode(jwtAssertion, { complete: true }) as any;
    const keyId = decodedHeader.header.kid;
    const publicKey = keys[keyId];

    if (!publicKey) throw new Error("Public key not found for JWT");

    const payload = jwt.verify(jwtAssertion, publicKey, {
      algorithms: ["ES256"],
      audience: IAP_CLIENT_ID,
      issuer: IAP_ISSUER,
    });

    (req as any).user = payload;
    next();
  } catch (err) {
    console.error("IAP JWT validation failed", err);
    return res.status(403).send("Forbidden - Invalid JWT");
  }
}
