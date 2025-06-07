<template>
  <div class="flex flex-col items-center text-center">
    <div class="flex flex-col sm:flex-row items-center sm:space-x-20 sm:space-y-20">
      <!-- DownloadSection on Left -->
      <div class="w-full sm:w-1/2">
        <DownloadSection />
      </div>

      <!-- Image on Right -->
      <div class="flex flex-col lg:flex-row items-center justify-center px-6 sm:px-6 w-full sm:w-1/2 mt-8">
        <img src="/assets/map_screen.svg" alt="App UI" class="w-72 sm:w-96 rounded-lg shadow-lg" />
      </div>
    </div>
  </div>
  <FeatureShowcase />
</template>

<script setup>
import DownloadSection from '@/components/download_section.vue';
import FeatureShowcase from '@/components/feature_showcase.vue';

definePageMeta({
  layout: 'default',
});
const { t } = useI18n();
useSeoMeta({
  title: t('seo.home_title'),
  description: t('seo.home_description'),
  ogTitle: t('seo.home_title'),
  ogDescription: t('seo.home_description'),
  ogImage: 'https://caffeing.com/preview.jpg',
});
</script>
