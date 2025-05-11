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

export const StoreKeyword: ListConfig<any> = list({
  access: allowAll,
  db: {
    map: "store_keyword",
  },
  fields: {
    store: relationship({
      ref: "Store.store_keywords",
      ui: {
        displayMode: "select",
        labelField: "name",
      },
    }),
    keyword: relationship({
      ref: "Keyword.store_keywords",
      ui: {
        displayMode: "select",
        labelField: "keyword_name",
      },
    }),
    store_id: text({
      ui: {
        createView: { fieldMode: "hidden" },
        itemView: { fieldMode: "read" },
      },
    }),
    keyword_id: text({
      ui: {
        createView: { fieldMode: "hidden" },
        itemView: { fieldMode: "read" },
      },
    }),
  },
  hooks: {
    resolveInput: {
      create: async ({ inputData, resolvedData, context }) => {
        let store_id = resolvedData.store_id;
        let keyword_id = resolvedData.keyword_id;

        const storeRelId = (inputData as any).store?.connect?.id;
        if (storeRelId) {
          const store = await context.query.Store.findOne({
            where: { id: storeRelId },
            query: "store_id",
          });
          store_id = store?.store_id;
        }

        const keywordRelId = (inputData as any).keyword?.connect?.id;
        if (keywordRelId) {
          const keyword = await context.query.Keyword.findOne({
            where: { id: keywordRelId },
            query: "keyword_id",
          });
          keyword_id = keyword?.keyword_id;
        }

        return {
          ...resolvedData,
          store_id,
          keyword_id,
        };
      },

      update: async ({ inputData, resolvedData, context }) => {
        let store_id = resolvedData.store_id;
        let keyword_id = resolvedData.keyword_id;

        const storeRelId = (inputData as any).store?.connect?.id;
        if (storeRelId) {
          const store = await context.query.Store.findOne({
            where: { id: storeRelId },
            query: "store_id",
          });
          store_id = store?.store_id;
        }

        const keywordRelId = (inputData as any).keyword?.connect?.id;
        if (keywordRelId) {
          const keyword = await context.query.Keyword.findOne({
            where: { id: keywordRelId },
            query: "keyword_id",
          });
          keyword_id = keyword?.keyword_id;
        }

        return {
          ...resolvedData,
          store_id,
          keyword_id,
        };
      },
    },
  },
});
