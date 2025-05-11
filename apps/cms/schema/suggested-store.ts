import { list } from "@keystone-6/core";
import type { ListConfig } from "@keystone-6/core/types";
import { allowAll } from "@keystone-6/core/access";
import { text } from "@keystone-6/core/fields";

export const SuggestedStore: ListConfig<any> = list({
  access: allowAll,
  db: {
    map: "suggested_store",
  },
  fields: {
    name: text({ validation: { isRequired: true } }),
    location: text(),
    description: text(),
    website: text(),
    businessHour: text(),
  },
});
