import i18n from '@nuxtjs/i18n';
export default defineNuxtConfig({
  modules: ['@nuxtjs/i18n'],
  i18n: {
    langDir: '../locales',
    lazy: true,
    defaultLocale: 'zh-tw',
    locales: [
      {
        code: 'en',
        iso: 'en-US',
        file: 'en.json',
      },
      {
        code: 'ja',
        iso: 'ja',
        file: 'ja.json',
      },
      {
        code: 'ko',
        iso: 'ko',
        file: 'ko.json',
      },
      {
        code: 'zh-tw',
        iso: 'zh-TW',
        file: 'zh-tw.json',
      },
      {
        code: 'zh-cn',
        iso: 'zh-CN',
        file: 'zh-tw.json', 
      }
    ],
    strategy: 'prefix_except_default',
    detectBrowserLanguage: {
      useCookie: true,
      cookieKey: 'i18n_redirected',
      redirectOn: 'root',
    },
  },
  devtools: { enabled: true },
  css: ['~/assets/css/tailwind.css'],
  components: true,
  runtimeConfig: {
    public: {
      suggestionApi: process.env.NUXT_PUBLIC_SUGGESTION_API || '',
      turnstileSiteKey: process.env.VUE_APP_CLOUDFLARE_TURNSTILE_SITE_KEY || '',
    },
  },
  app: {
    head: {
      title: 'Caffeing',
      meta: [
        {
          name: 'description',
          content: 'Discover the best coffee shops near you with Caffeing.',
        },
        { name: 'keywords', content: 'coffee shops, coffee finder' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1.0' },
        { name: 'robots', content: 'index, follow' },
        {
          property: 'og:title',
          content: 'Find the Best Coffee Shops - Caffeing',
        },
        {
          property: 'og:description',
          content: 'Looking for the perfect coffee spot? Download Caffeing!',
        },
        { property: 'og:image', content: 'https://caffeing.com/preview.jpg' },
        { property: 'og:url', content: 'https://caffeing.com' },
      ],
      script: [
        {
          src: 'https://challenges.cloudflare.com/turnstile/v0/api.js',
          async: true,
          defer: true,
        },
      ],
    },
    layoutTransition: { name: 'layout', mode: 'out-in' },
  },
  postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },
});
