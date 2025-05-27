import express, { Express } from "express";
import { KeystoneContext } from "@keystone-6/core/types";
import { registerSuggestStoreRoute } from "./routes/suggest-store-route";
import { validateIapJwt } from "./iap-auth-middleware";

export function extendExpressApp(app: Express, context: KeystoneContext) {
  const isDev = process.env.NODE_ENV === "development";
  app.use(express.json());
  if (!isDev) {
    //app.use(validateIapJwt); 
  }
  registerSuggestStoreRoute(app, context);
}
