<template>
    <div class="error-container">
        <h1 class="status-code">{{ statusCode }}</h1>
        <p class="message">{{ message }}</p>
        <NuxtLink to="/" class="home-link">
            {{ t('nav.home') }}
        </NuxtLink>
    </div>
</template>

<script setup>
import { useI18n } from 'vue-i18n';

const props = defineProps({ error: Object });
const { t } = useI18n();

const statusCode = props.error?.statusCode || 500;
const message = props.error?.statusMessage || 'An unexpected error occurred.';
</script>

<style scoped>
.error-container {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    background-color: #121212;
    color: white;
}

.status-code {
    font-size: 5.25em;
    margin-top: 1.5rem;
}

.message {
    font-size: 2.25rem;
    margin-top: 1.5rem;
}

.home-link {
    margin-top: 2rem;
    color: #60a5fa;
    font-size: 1.25rem;
}

.home-link:hover {
    color: #93c5fd;
}
</style>