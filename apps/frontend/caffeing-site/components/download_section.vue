<template>
    <div class="mt-10 md:mt-14 md:px-6">
        <div class="flex flex-col gap-4">
            <div class="flex items-center gap-4 md:gap-8 md:flex-col xl:flex-row">
                <!-- App Icon on the Left -->
                <img src="/assets/app_icon.png" alt="App Icon" class="w-24 h-24 sm:w-32 sm:h-32" />

                <!-- Title and Description -->
                <div class="flex flex-col text-left">
                    <h1 class="font-semibold text-3xl sm:text-4xl md:text-center xl:text-5xl xl:text-left">
                        {{ $t('home.title') }}
                    </h1>
                    <p class="mt-4 text-base sm:text-lg lg:text-xl">
                        {{ $t('home.description') }}
                    </p>
                </div>
            </div>

            <!-- Download Buttons Wrapper -->
            <div class="flex justify-center gap-4 mt-6 xl:justify-start">
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
