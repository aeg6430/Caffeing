export default defineNuxtConfig({
  ssr: true,
  nitro: {
    preset: 'cloudflare-pages'
  },
  modules: [
    '@nuxtjs/i18n',
    '@nuxtjs/seo',
  ],
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
      },
    ],
    strategy: 'prefix_except_default',
    detectBrowserLanguage: {
      useCookie: true,
      cookieKey: 'i18n_redirected',
      redirectOn: 'root',
      fallbackLocale: 'en',
      alwaysRedirect: true, 
    },
  },
  site: { 
    url: 'https://caffeing.com', 
    name: 'Caffeing', 
    description: 'Easily find the cafes you are looking for.',
    defaultLocale: 'zh-tw',
  },
  devtools: { enabled: true },
  css: [
    '@fortawesome/fontawesome-free/css/all.css',
    '~/assets/css/tailwind.css',
  ],
  components: true,
  runtimeConfig: {
    public: {
      suggestionApi: process.env.NUXT_PUBLIC_SUGGESTION_API || '',
      turnstileSiteKey: process.env.VUE_APP_CLOUDFLARE_TURNSTILE_SITE_KEY || '',
      contactThreads: process.env.NUXT_PUBLIC_CONTACT_THREADS || '',
      contactInstagram: process.env.NUXT_PUBLIC_CONTACT_INSTAGRAM || '',
      contactEmail: process.env.NUXT_PUBLIC_CONTACT_EMAIL || '',
      appStoreUrl: process.env.NUXT_PUBLIC_APPSTORE_URL || '',
      playStoreUrl: process.env.NUXT_PUBLIC_PLAYSTORE_URL || '',
    },
  },
  app: {
    head: {
      title: 'Caffeing',
      meta: [
        { name: 'viewport', content: 'width=device-width, initial-scale=1.0' },
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