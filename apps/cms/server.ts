import express, { Express } from "express";
import { KeystoneContext } from "@keystone-6/core/types";
import { registerSuggestStoreRoute } from "./routes/suggest-store-route";
import { verifyAuth } from "./firebase-auth";

export function extendExpressApp(app: Express, context: KeystoneContext) {
  app.use(express.json());
  app.use(verifyAuth);

  registerSuggestStoreRoute(app, context);
}
