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

export const FavoriteStore: ListConfig<any> = list({
  access: {
    operation: {
      query: () => false,
      create: () => false,
      update: () => false,
      delete: () => false,
    },
  },
  db: {
    map: "favorite_store",
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
    store_id: text({
      ui: {
        itemView: { fieldMode: "read" },
      },
    }),
  },
});
