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

        const file = await import(`@/assets/app_privacy.${mappedLang}.md?raw`);
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
</script>

<template>
    <div class="markdown-body markdown-wrapper">
        <div v-if="isLoading">Loading...</div>
        <div v-else v-html="markdown" />
    </div>
</template>

<style>
@import 'github-markdown-css/github-markdown.css';
</style>

<style scoped>
.markdown-wrapper {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
    background-color: #030712;
    border-radius: 8px;
}

.markdown-body {
    color: #ffffff;
}

.markdown-body a {
    color: #3b82f6;
}

.markdown-body pre {
    background-color: #1f2937;
}

.markdown-body code {
    background-color: #374151;
    color: #fbbf24;
}
</style>
