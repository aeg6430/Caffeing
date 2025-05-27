import { Request, Response, NextFunction } from "express";
import { OAuth2Client, TokenPayload } from "google-auth-library";

const IAP_JWT_HEADER = "x-goog-iap-jwt-assertion";
const IAP_CLIENT_ID = process.env.IAP_CLIENT_ID || "";

const oauthClient = new OAuth2Client();

export async function validateIapJwt(req: Request, res: Response, next: NextFunction) {
  const jwtAssertion = req.header(IAP_JWT_HEADER);
  if (!jwtAssertion) {
    return res.status(401).send("No IAP JWT found");
  }

  try {
    const ticket = await oauthClient.verifyIdToken({
      idToken: jwtAssertion,
      audience: IAP_CLIENT_ID,
    });

    const payload: TokenPayload | undefined = ticket.getPayload();
    if (!payload) throw new Error("Invalid payload");

    (req as any).user = {
      email: payload.email,
      name: payload.name,
      sub: payload.sub,
    };

    next();
  } catch (err) {
    console.error("IAP JWT validation failed:", err);
    res.status(403).send("Forbidden - Invalid JWT");
  }
}
