<template>
    <div class="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-xl mx-auto bg-white p-8 shadow-xl rounded-2xl">
            <SuggestForm />
        </div>
    </div>
</template>

<script setup>
import SuggestForm from '@/components/suggest_form.vue'

definePageMeta({
    layout: 'default'
})
</script>
