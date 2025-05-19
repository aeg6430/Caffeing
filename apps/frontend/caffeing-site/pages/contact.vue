<template>
  <div class="py-24">
    <div class="flex flex-col items-center">
      <p class="text-lg mt-4 max-w-2xl w-full">
        {{ $t('contact.title') }}
      </p>

      <div class="mt-8 max-w-2xl text-left w-full">
        <p class="flex items-center">
          <i class="fab fa-threads mr-2 text-blue-500"></i>
          <a :href="threadsUrl" class="text-blue-500" target="_blank" rel="noopener noreferrer">
            {{ threadsUrl }}
          </a>
        </p>
      </div>

      <div class="mt-8 max-w-2xl text-left w-full">
        <p class="flex items-center">
          <i class="fab fa-instagram mr-2 text-blue-500"></i>
          <a :href="instagramUrl" class="text-blue-500" target="_blank" rel="noopener noreferrer">
            {{ instagramUrl }}
          </a>
        </p>
      </div>

      <div class="mt-8 max-w-2xl text-left w-full">
        <p class="flex items-center">
          <i class="fas fa-envelope mr-2 text-blue-500"></i>
          <a :href="`mailto:${email}`" class="text-blue-500">
            {{ email }}
          </a>
        </p>
      </div>
    </div>
  </div>
</template>
<script setup>
const config = useRuntimeConfig();

const threadsUrl = config.public.contactThreads;
const instagramUrl = config.public.contactInstagram;
const email = config.public.contactEmail;
</script>
