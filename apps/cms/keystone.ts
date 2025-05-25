import "dotenv/config";
import { config } from "@keystone-6/core";
import { lists } from "./schema";
import { withAuth, session } from "./auth";
import { extendExpressApp } from "./server";

const allowedOrigins = process.env.CORS_ORIGIN?.split(",") || [];
export default withAuth(
  config({
    db: {
      provider: "postgresql",
      url: process.env.DATABASE_URL || "",
    },
    lists,
    session,
    server: {
      cors: {
        origin: allowedOrigins, 
        credentials: true, 
      },
      port: Number(process.env.PORT) || 3000,
      maxFileSize: 200 * 1024 * 1024,
      extendExpressApp,
    },
  })
);
