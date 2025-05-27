import { Request, Response, NextFunction } from "express";
import jwt, { JwtHeader, SigningKeyCallback } from "jsonwebtoken";
import jwksClient from "jwks-rsa";

const IAP_JWT_HEADER = "x-goog-iap-jwt-assertion";
const IAP_CLIENT_ID = process.env.IAP_CLIENT_ID || "";

const client = jwksClient({
  jwksUri: "https://www.gstatic.com/iap/verify/public_key-jwk",
});

function getKey(header: JwtHeader, callback: SigningKeyCallback) {
  client.getSigningKey(header.kid!, (err, key) => {
    const signingKey = key?.getPublicKey();
    callback(err, signingKey);
  });
}

export function validateIapJwt(req: Request, res: Response, next: NextFunction) {
  const jwtAssertion = req.header(IAP_JWT_HEADER);
  if (!jwtAssertion) return res.status(401).send("No IAP JWT found");

  jwt.verify(
    jwtAssertion,
    getKey,
    {
      audience: IAP_CLIENT_ID,
      issuer: "https://cloud.google.com/iap",
      algorithms: ["ES256"],
    },
    (err, decoded: any) => {
      if (err) {
        console.error("IAP JWT validation failed:", err);
        return res.status(403).send("Forbidden - Invalid JWT");
      }

      (req as any).user = {
        email: decoded.email,
        sub: decoded.sub,
      };

      next();
    }
  );
}
