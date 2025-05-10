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
import { randomUUID } from "crypto";

export const Store: ListConfig<any> = list({
  access: allowAll,
  db: {
    map: "store",
  },
  fields: {
    store_id: text({
      isIndexed: "unique",
      ui: {
        createView: { fieldMode: "hidden" },
        itemView: { fieldMode: "read" },
      },
    }),
    name: text(),
    address: text(),
    latitude: float(),
    longitude: float(),
    contact_number: text(),
    business_hours: text(),
    store_keywords: relationship({
      ref: "StoreKeyword.store",
      many: true,
      ui: {
        createView: { fieldMode: "hidden" },
        itemView: { fieldMode: "read" },
      },
    }),
  },
  hooks: {
    resolveInput: {
      create: async ({ resolvedData }) => {
        if (!resolvedData.store_id) {
          resolvedData.store_id = randomUUID();
        }
        return resolvedData;
      },
    },
  },
});
