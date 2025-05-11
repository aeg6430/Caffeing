<template>
  <div class="py-24">
    <div class="flex flex-col items-center">
      <h1 class="text-6xl font-semibold">{{ $t('contact') }}</h1>
      <p class="text-lg mt-4 max-w-2xl text-center">
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </p>
      <div class="mt-8 text-center">
        <p>
          Email:
          <a href="mailto:support@caffeing.com" class="text-blue-500">support@caffeing.com</a>
        </p>
      </div>
    </div>
  </div>
</template>
<script setup>
definePageMeta({
  layout: 'default',
});
</script>
