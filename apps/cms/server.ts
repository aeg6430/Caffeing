import express, { Express } from "express";
import { KeystoneContext } from "@keystone-6/core/types";
import { registerSuggestStoreRoute } from "./routes/suggest-store-route";

export function extendExpressApp(app: Express, context: KeystoneContext) {
  app.use(express.json());
  registerSuggestStoreRoute(app, context);
}
