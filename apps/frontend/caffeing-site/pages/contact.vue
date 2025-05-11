<template>
  <div class="py-24">
    <div class="flex flex-col items-center">
      <p class="text-lg mt-4 max-w-2xl w-full">
        {{ $t('about.title') }}
      </p>
      <div class="mt-8 max-w-2xl text-left w-full">
        <p class="flex items-center">
          <i class="fab fa-instagram mr-2 text-blue-500"></i>

          <a href="https://www.instagram.com/caffe.ing" class="text-blue-500" target="_blank" rel="noopener noreferrer">
            https://www.instagram.com/caffe.ing
          </a>
        </p>
      </div>
      <div class="mt-8 max-w-2xl text-left w-full">
        <p class="flex items-center">
          <i class="fas fa-envelope mr-2 text-blue-500"></i>

          <a href="mailto:caffeingapp@gmail.com" class="text-blue-500">caffeingapp@gmail.com</a>
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
