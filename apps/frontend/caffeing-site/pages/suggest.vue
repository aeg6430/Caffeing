<template>
    <div class="min-h-screen py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-xl mx-auto bg-[#030712]/60 p-8 shadow-xl rounded-2xl backdrop-blur-sm">
            <SuggestForm />
        </div>
    </div>
</template>

<script setup>
import SuggestForm from '@/components/suggest_form.vue';

definePageMeta({
    layout: 'default',
});

const { t } = useI18n();
useSeoMeta({
    title: t('seo.form_title'),
    description: t('seo.form_description'),
    ogTitle: t('seo.form_title'),
    ogDescription: t('seo.form_description'),
    ogImage: 'https://caffeing.com/preview.jpg',
});
</script>
