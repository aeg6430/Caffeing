import { list } from "@keystone-6/core";
import type { ListConfig } from "@keystone-6/core/types";
import { allowAll } from "@keystone-6/core/access";
import {
  text,
  relationship,
  password,
  timestamp,
  select,
  float,
} from "@keystone-6/core/fields";

export const AppUser: ListConfig<any> = list({
  db: {
    map: "app_user",
  },
  access: {
    operation: {
      query: () => false,
      create: () => false,
      update: () => false,
      delete: () => false,
    },
  },
  ui: {
    isHidden: true,
  },
  fields: {
    user_id: text({
      ui: {
        itemView: { fieldMode: "read" },
      },
    }),
    provider: text({
      ui: {
        itemView: { fieldMode: "read" },
      },
    }),
    provider_id: text({
      ui: {
        itemView: { fieldMode: "read" },
      },
    }),
    email: text({
      ui: {
        itemView: { fieldMode: "read" },
      },
    }),
    name: text({
      ui: {
        itemView: { fieldMode: "read" },
      },
    }),
    role: text({
      ui: {
        itemView: { fieldMode: "read" },
      },
    }),
    created_time: timestamp({
      defaultValue: { kind: "now" },
      ui: {
        itemView: { fieldMode: "read" },
      },
    }),
    modified_time: timestamp({
      defaultValue: { kind: "now" },
      ui: {
        itemView: { fieldMode: "read" },
      },
    }),
  },
});
