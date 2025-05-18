<script setup>
import { useI18n } from 'vue-i18n'
import { ref, watchEffect } from 'vue'
import MarkdownIt from 'markdown-it'

const { locale } = useI18n()
const markdown = ref('')
const mdParser = new MarkdownIt()

watchEffect(async () => {
    try {
        let file
        if (locale.value.toLowerCase() === 'zh-tw' || locale.value.toLowerCase() === 'zh-cn') {
            file = await import('@/assets/privacy.zh-tw.md?raw')
        } else {
            file = await import('@/assets/privacy.en.md?raw')
        }

        markdown.value = mdParser.render(file.default)
    } catch (error) {
        console.error('Markdown Import Error:', error)
        markdown.value = '<p>Error loading privacy policy.</p>'
    }
})
</script>

<template>
    <div class="markdown-body markdown-wrapper" v-html="markdown"></div>
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
