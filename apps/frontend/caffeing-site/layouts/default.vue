<template>
  <div class="flex flex-col min-h-screen bg-gray-100 text-gray-800">
    <!-- Header -->
    <header class="bg-gray-800 text-white py-4">
      <div class="container mx-auto flex items-center justify-between px-4 sm:px-8">
        <!-- Clickable Logo -->
        <NuxtLink to="/" class="text-3xl font-bold">Caffeing</NuxtLink>

        <!-- Desktop Navigation -->
        <nav class="hidden md:flex md:space-x-6">
          <ul class="flex flex-row space-x-6">
            <li v-for="link in navLinks" :key="link.to">
              <NuxtLink :to="link.to" class="block py-2 text-white hover:bg-gray-700">
                {{ link.label }}
              </NuxtLink>
            </li>
          </ul>
        </nav>

        <!-- Mobile Menu Button -->
        <button @click="toggleMenu"
          class="md:hidden flex flex-col space-y-1 bg-transparent border-none focus:outline-none">
          <span :class="menuOpen ? 'rotate-45 translate-y-2' : ''"
            class="block w-6 h-0.5 bg-white transition-transform"></span>
          <span :class="menuOpen ? 'opacity-0' : ''" class="block w-6 h-0.5 bg-white transition-opacity"></span>
          <span :class="menuOpen ? '-rotate-45 -translate-y-2' : ''"
            class="block w-6 h-0.5 bg-white transition-transform"></span>
        </button>
      </div>

      <!-- Mobile Navigation -->
      <nav :class="[menuOpen ? 'block' : 'hidden', 'absolute top-16 left-0 w-full bg-gray-800 md:hidden']">
        <ul class="flex flex-col space-y-4 text-center">
          <li v-for="link in navLinks" :key="'mobile-' + link.to">
            <NuxtLink :to="link.to" class="block py-2 text-white hover:bg-gray-700">
              {{ link.label }}
            </NuxtLink>
          </li>
        </ul>
      </nav>
    </header>

    <!-- Main Content -->
    <main class="flex-grow h-full w-full px-4 sm:px-8 lg:px-16">
      <NuxtPage />
    </main>

    <!-- Footer -->
    <footer class="bg-gray-800 text-white py-4 mt-16 text-center">
      <div class="max-w-screen-lg mx-auto px-4 sm:px-8">
        <p>&copy; {{ currentYear }} Caffeing. All rights reserved.</p>
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
  { label: 'Home', to: '/' },
  { label: 'About', to: '/about' },
  { label: 'Contact', to: '/contact' }
];
</script>
