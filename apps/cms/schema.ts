import { type Lists } from ".keystone/types";
import { User } from "./schema/user";
import { AppUser } from "./schema/app_user";
import { FavoriteStore } from "./schema/favorite_store";
import { Keyword } from "./schema/keyword";
import { StoreKeyword } from "./schema/store_keyword";
import { Store } from "./schema/store";
import { SuggestedStore } from './schema/suggested-store';

export const lists = {
  User,
  AppUser,
  FavoriteStore,
  Keyword,
  StoreKeyword,
  Store,
  SuggestedStore
} satisfies Lists;
