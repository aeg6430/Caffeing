<template>
  <div class="flex flex-col items-center text-center px-4 sm:px-8 mt-8">
    <div class="flex flex-col space-y-8 mt-6">
      <div v-for="(item, index) in items" :key="index"
        class="flex flex-col sm:flex-row items-center sm:space-x-20 sm:space-y-20"
        :class="index % 2 === 0 ? 'sm:flex-row' : 'sm:flex-row-reverse'">
        <img :src="item.image" alt="Coffee Widget Preview" class="w-72 sm:w-96 rounded-lg shadow-lg">
        <p class="text-lg mt-6 sm:mt-0 flex-1 min-w-0 sm:ml-20 sm:px-10 text-left">
          {{ item.text }}
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useI18n } from 'vue-i18n'
import ui2 from '/assets/ui2.svg';
import highlightSearchResults from '/assets/highlight_search_results.svg';
const { t } = useI18n()
const items = [
  { image: ui2, text: t('home.featureShowCase.advancedSearch') },
  { image: highlightSearchResults, text: t('home.featureShowCase.highlightSearchResults') },
];
</script>