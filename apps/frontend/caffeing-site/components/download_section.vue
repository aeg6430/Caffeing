<template>
    <div class="flex flex-col items-center text-center px-6 sm:px-6 mt-8">
        <div class="flex flex-col space-y-8 mt-6">
            <div class="flex items-center space-x-4">
                <!-- App Icon on the Left -->
                <img src="/assets/app_icon.png" alt="App Icon" class="w-24 h-24 sm:w-32 sm:h-32 mr-4" />

                <!-- Title and Description -->
                <div class="flex flex-col items-start text-left">
                    <h1 class="text-3xl sm:text-4xl lg:text-5xl font-semibold">
                        {{ $t('home.title') }}
                    </h1>
                    <p class="mt-4 text-base sm:text-lg lg:text-xl text-left">
                        {{ $t('home.description') }}
                    </p>
                </div>
            </div>

            <!-- Download Buttons Wrapper -->
            <div class="flex space-x-6 mt-6 sm:space-x-8">
                <!-- iOS Download -->
                <a :href="appStoreUrl" target="_blank" class="flex items-center">
                    <img src="/assets/third_party_icons/apple_store.svg" alt="Download on iOS" class="h-8" />
                </a>

                <!-- Android Download -->
                <a :href="playStoreUrl" target="_blank" class="flex items-center">
                    <img src="/assets/third_party_icons/google_play.png" alt="Download on Android" class="h-8" />
                </a>
            </div>
        </div>
    </div>
</template>
<script setup>
defineProps({
    title: {
        type: String,
        required: false,
    },
    description: {
        type: String,
        required: true,
    },
});

const config = useRuntimeConfig();
const appStoreUrl = config.public.appStoreUrl;
const playStoreUrl = config.public.playStoreUrl;
</script>
