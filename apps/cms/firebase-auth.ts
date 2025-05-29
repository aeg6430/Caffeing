import { Request, Response, NextFunction } from 'express';
import { OAuth2Client } from 'google-auth-library';

const oAuthClient = new OAuth2Client();
export async function verifyAuth(req: Request, res: Response, next: NextFunction) {
  try {
    const isDev = process.env.NODE_ENV === 'development';

    if (isDev) {
      console.warn('WARNING: Bypassing auth in development mode.');
      return next();
    }

    const iapJwt = req.headers['x-goog-iap-jwt-assertion'] as string;
    if (!iapJwt) {
      return res.status(401).json({ message: 'Missing IAP assertion' });
    }

    const audience = process.env.IAP_AUDIENCE;
    if (!audience) {
      throw new Error('Missing IAP_AUDIENCE env var');
    }

    const ticket = await oAuthClient.verifyIdToken({
      idToken: iapJwt,
      audience,
    });
    const payload = ticket.getPayload();
    if (!payload) {
      return res.status(403).json({ message: 'Invalid IAP token' });
    }

    (req as any).user = payload;
    next();
  } catch (err) {
    console.error('Auth error:', err);
    res.status(401).json({ message: 'Unauthorized' });
  }
}

