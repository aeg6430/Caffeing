<template>
  <div class="flex flex-col items-center text-center px-4 sm:px-8 mt-8">
    <div class="flex flex-col gap-8 mt-6">
      <div v-for="(item, index) in items" :key="index"
        class="grid md:grid-cols-2 justify-center items-center gap-4"
        >
        <img :src="item.image" alt="Coffee Widget Preview" class="w-72 mx-auto shadow-lg md:w-auto">
        <p class="text-lg text-left w-3/4 mx-auto" :class="index % 2 !== 0 ? 'md:order-first' : ''">
          {{ item.text }}
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useI18n } from 'vue-i18n'
import advancedSearch from '/assets/advanced_search.svg';
import highlightSearchResults from '/assets/highlight_search_results.svg';
const { t } = useI18n()
const items = [
  { image: advancedSearch, text: t('home.featureShowCase.advancedSearch') },
  { image: highlightSearchResults, text: t('home.featureShowCase.highlightSearchResults') },
];
</script>