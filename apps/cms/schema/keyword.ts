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

export const Keyword: ListConfig<any> = list({
  access: allowAll,
  db: {
    map: "keyword",
  },
  fields: {
    keyword_id: text({
      isIndexed: "unique",
      ui: {
        createView: { fieldMode: "hidden" },
        itemView: { fieldMode: "read" },
      },
    }),
    keyword_name: text(),
    keyword_type: text(),
    store_keywords: relationship({
      ref: "StoreKeyword.keyword",
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
        if (!resolvedData.keyword_id) {
          resolvedData.keyword_id = randomUUID(); 
        }
        return resolvedData;
      },
    },
  },
});
