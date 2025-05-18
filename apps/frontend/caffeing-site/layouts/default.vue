<template>
  <div class="flex flex-col min-h-screen bg-brandBg">
    <!-- Header -->
    <header class="bg-[#030712]/60 text-white py-4">
      <div class="container mx-auto flex items-center justify-between px-4 sm:px-8">
        <!-- Clickable Logo -->
        <NuxtLink to="/" class="text-3xl font-bold">Caffeing</NuxtLink>

        <!-- Desktop Navigation -->
        <nav class="hidden md:flex md:space-x-6">
          <ul class="flex flex-row space-x-6">
            <li v-for="link in navLinks" :key="link.to">
              <NuxtLink :to="link.to" class="block py-2 text-white hover:bg-gray-700">
                {{ $t(link.labelKey) }}
              </NuxtLink>
            </li>
          </ul>
        </nav>

        <!-- Mobile Menu Button -->
        <button @click="toggleMenu"
          class="md:hidden flex flex-col space-y-1 bg-transparent border-none focus:outline-none">
          <span v-if="!menuOpen" class="text-white text-3xl">
            <i class="fas fa-bars"></i>
          </span>

          <span v-if="menuOpen" class="text-white text-3xl">
            <i class="fas fa-times"></i>
          </span>
        </button>
      </div>

      <!-- Mobile Navigation -->
      <nav :class="[
        menuOpen ? 'block' : 'hidden',
        'absolute top-16 left-0 w-full bg-[#080b11] md:hidden',
        'z-50',
      ]">
        <ul class="flex flex-col space-y-4 text-center">
          <li v-for="link in navLinks" :key="'mobile-' + link.to">
            <NuxtLink :to="link.to" class="block py-2 text-white hover:bg-gray-700">
              {{ $t(link.labelKey) }}
            </NuxtLink>
          </li>
        </ul>
      </nav>
    </header>

    <!-- Main Content -->
    <main class="flex-grow h-full w-full px-4 sm:px-8 lg:px-16 text-white">
      <NuxtPage />
    </main>

    <!-- Footer -->
    <footer class="bg-[#030712]/60 text-white py-4 mt-16 text-center">
      <div class="max-w-screen-lg mx-auto px-4 sm:px-8 flex flex-col sm:flex-row items-center justify-between gap-2">
        <p>&copy; {{ currentYear }} Caffeing. All rights reserved.</p>
        <nav>
          <ul class="flex space-x-4 text-sm">
            <li>
              <NuxtLink to="/privacy" class="hover:underline">
                {{ $t('nav.privacy') }}
              </NuxtLink>
            </li>
          </ul>
        </nav>
      </div>
    </footer>

  </div>
</template>

<script setup>
import { ref } from 'vue';

// Toggle mobile menu visibility
const menuOpen = ref(false);
const toggleMenu = () => {
  menuOpen.value = !menuOpen.value;
};

const currentYear = new Date().getFullYear();

// Navigation links
const navLinks = [
  { labelKey: 'nav.home', to: '/' },
  { labelKey: 'nav.contact', to: '/contact' },
  { labelKey: 'nav.suggest', to: '/suggest' },
];
</script>
