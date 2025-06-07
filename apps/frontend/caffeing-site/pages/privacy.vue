<script setup>
import { useI18n } from 'vue-i18n';
import { ref, watchEffect } from 'vue';
import MarkdownIt from 'markdown-it';

const { locale } = useI18n();
const markdown = ref('');
const isLoading = ref(true);
const mdParser = new MarkdownIt();
let lastLoadedLang = '';
const langToFileMap = {
    'zh-tw': 'zh-tw',
    'zh-cn': 'zh-tw',
    en: 'en',
    ja: 'ja',
    ko: 'ko',
};

const loadMarkdown = async (lang) => {
    const normalizedLang = lang.toLowerCase();
    const mappedLang = langToFileMap[normalizedLang] || 'en';

    try {
        isLoading.value = true;

        const file = await import(`@/assets/privacy.${mappedLang}.md?raw`);
        markdown.value = mdParser.render(file.default);
        lastLoadedLang = lang;
    } catch (error) {
        console.error('Markdown Import Error:', error);
        markdown.value = '<p>Error loading privacy policy.</p>';
    } finally {
        isLoading.value = false;
    }
};

watchEffect(() => {
    if (locale.value && locale.value !== lastLoadedLang) {
        loadMarkdown(locale.value);
    }
});

const { t } = useI18n();
useSeoMeta({
    title: t('seo.privacy_title'),
    description: t('seo.privacy_description'),
    ogTitle: t('seo.privacy_title'),
    ogDescription: t('seo.privacy_description'),
    ogImage: 'https://caffeing.com/preview.jpg',
});
</script>


<template>
    <div class="markdown-wrapper prose dark:prose-invert max-w-3xl mx-auto p-6">
        <div v-if="isLoading">Loading...</div>
        <div v-else v-html="markdown" />
    </div>
</template>
<style scoped>
.markdown-wrapper {
    max-width: 800px;
    margin: 20px auto;
    padding: 20px;
    background-color: #030712;
    border-radius: 8px;
}

.prose {
    --tw-prose-body: #f3f4f6;
    --tw-prose-headings: #ffffff;
    --tw-prose-bold: #ffffff;
    --tw-prose-links: #60a5fa;
    --tw-prose-code: #fbbf24;
    --tw-prose-pre-bg: #1f2937;
}
</style>
