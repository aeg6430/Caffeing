<template>
  <div class="bg-white py-12 sm:py-16 lg:py-24">
    <div class="flex flex-col items-center text-center px-4 sm:px-8">
      <h1 class="text-4xl sm:text-5xl lg:text-6xl font-semibold text-gray-800">{{ $t('home') }}</h1>
      <p class="mt-4 text-base sm:text-lg lg:text-xl text-gray-600">Lorem ipsum.</p>
      <!-- Download Buttons -->
      <div class="flex justify-center space-x-4 mt-4 flex-wrap sm:flex-nowrap">
        <!-- iOS Download -->
        <a href="https://apps.apple.com/app/caffeing" target="_blank">
          <img src="/assets/third_party_icons/apple_store.svg" alt="Download on iOS" class="h-8">
        </a>
        <!-- Android Download -->
        <a href="https://play.google.com/store/apps/details?id=caffeing" target="_blank">
          <img src="/assets/third_party_icons/google_play.png" alt="Download on Android" class="h-8">
        </a>
      </div>
      <FeatureShowcase />
    </div>
  </div>
</template>
<script setup>
import FeatureShowcase from '@/components/feature_showcase.vue';
definePageMeta({
  layout: 'default'
})
</script>