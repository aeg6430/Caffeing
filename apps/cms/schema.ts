import { User } from "./schema/user";
import { AppUser } from "./schema/app_user";
import { FavoriteStore } from "./schema/favorite_store";
import { Keyword } from "./schema/keyword";
import { StoreKeyword } from "./schema/store_keyword";
import { Store } from "./schema/store";
import { type Lists } from ".keystone/types";
export const lists = {
  User,
  AppUser,
  FavoriteStore,
  Keyword,
  StoreKeyword,
  Store,
} satisfies Lists;
