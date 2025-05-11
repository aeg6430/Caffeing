<template>
  <div class="bg-white py-12 sm:py-16 lg:py-24">
    <div class="flex flex-col items-center text-center px-4 sm:px-8">
      <h1 class="text-4xl sm:text-5xl lg:text-6xl font-semibold text-gray-800">{{ $t('about') }}</h1>
      <p class="mt-4 text-base sm:text-lg lg:text-xl text-gray-600 max-w-2xl">
        At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti.
      </p>
    </div>
  </div>
</template>
<script setup>
definePageMeta({
  layout: 'default'
})
</script>
