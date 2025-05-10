// Welcome to your schema
//   Schema driven development is Keystone's modus operandi
//
// This file is where we define the lists, fields and hooks for our data.
// If you want to learn more about how lists are configured, please read
// - https://keystonejs.com/docs/config/lists

import { list } from "@keystone-6/core";
import { allowAll } from "@keystone-6/core/access";
import { randomUUID } from "crypto";

// see https://keystonejs.com/docs/fields/overview for the full list of fields
//   this is a few common fields for an example
import {
  text,
  relationship,
  password,
  timestamp,
  select,
  float,
} from "@keystone-6/core/fields";

// the document field is a more complicated field, so it has it's own package
import { document } from "@keystone-6/fields-document";
// if you want to make your own fields, see https://keystonejs.com/docs/guides/custom-fields

// when using Typescript, you can refine your types to a stricter subset by importing
// the generated types from '.keystone/types'
import { type Lists } from ".keystone/types";
import { DateTime } from "@keystone-6/core/dist/declarations/src/types/schema/graphql-ts-schema";

export const lists = {
  User: list({
    // WARNING
    //   for this starter project, anyone can create, query, update and delete anything
    //   if you want to prevent random people on the internet from accessing your data,
    //   you can find out more at https://keystonejs.com/docs/guides/auth-and-access-control
    access: allowAll,
    db: {
      map: "keystone_user",
    },
    // this is the fields for our User list
    fields: {
      // by adding isRequired, we enforce that every User should have a name
      //   if no name is provided, an error will be displayed
      name: text({ validation: { isRequired: true } }),

      email: text({
        validation: { isRequired: true },
        // by adding isIndexed: 'unique', we're saying that no user can have the same
        // email as another user - this may or may not be a good idea for your project
        isIndexed: "unique",
      }),
      password: password({ validation: { isRequired: true } }),
      createdAt: timestamp({
        // this sets the timestamp to Date.now() when the user is first created
        defaultValue: { kind: "now" },
      }),
    },
  }),
  // AppUsers list (from AppUser table)
  AppUser: list({
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
  }),
  // FavoriteStores list (from FavoriteStore table)
  FavoriteStore: list({
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
  }),
  // Keywords list (from keywords table)
  Keyword: list({
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
            resolvedData.keyword_id = randomUUID(); // Node.js built-in UUID
          }
          return resolvedData;
        },
      },
    },
  }),
  StoreKeyword: list({
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
  }),
  // Store list (from stores table)
  Store: list({
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
  }),
} satisfies Lists;
