<template>
    <div>
        <h1 class="text-2xl font-bold mb-6">{{ t('suggestForm.title') }}</h1>

        <div v-if="submitted">
            <h2 class="text-xl font-semibold text-green-600">
                {{ t('suggestForm.buttons.thank-you') }}
            </h2>
            <p class="mt-4">{{ t('suggestForm.thank-you-message') }}</p>
            <button @click="resetForm"
                class="mt-6 px-4 py-2 bg-amber-500 text-white font-semibold rounded-md shadow hover:bg-amber-600 transition">
                {{ t('suggestForm.buttons.submit-another') }}
            </button>
        </div>

        <form v-else @submit.prevent="handleSubmit" class="space-y-5">
            <div v-for="field in fields" :key="field.name">
                <label :for="field.name" class="block text-sm font-medium">
                    {{ t(`suggestForm.fields.${field.name}.label`) }}
                </label>

                <component :is="field.type === 'textarea' ? 'textarea' : 'input'" :value="form[field.name]"
                    @input="updateFormValue(field.name, $event.target.value)" :type="field.inputType || 'text'"
                    :placeholder="t(`suggestForm.fields.${field.name}.placeholder`)" :rows="field.rows"
                    :required="field.required"
                    class="mt-1 block w-full rounded-md border-gray-300 bg-gray-800 text-white p-3 shadow-sm focus:ring-amber-500 focus:border-amber-500" />
            </div>

            <div id="turnstile-container" class="cf-turnstile" data-theme="light" />

            <div>
                <button type="submit"
                    class="w-full py-2 px-4 bg-amber-500 text-white font-semibold rounded-md shadow hover:bg-amber-600 transition">
                    {{ t('suggestForm.buttons.submit') }}
                </button>
            </div>
        </form>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import { useI18n } from 'vue-i18n';

const { t } = useI18n();
const config = useRuntimeConfig();
const submitted = ref(false);
const turnstileError = ref(false);

const form = ref({
    name: '',
    businessHours: '',
    address: '',
    googleMapsLink: '',
    website: '',
    description: '',
});

const fields = [
    { name: 'name', required: true },
    { name: 'businessHours', type: 'textarea', rows: 4 },
    { name: 'address' },
    { name: 'googleMapsLink', inputType: 'url' },
    { name: 'website', inputType: 'url' },
    { name: 'description', type: 'textarea', rows: 3 },
];

const updateFormValue = (fieldName, value) => {
    form.value[fieldName] = value;
};

const handleSubmit = async () => {
    try {
        const container = document.getElementById('turnstile-container');
        if (!window.turnstile || !container.hasChildNodes()) {
            window.turnstile.render(container, {
                sitekey: config.public.turnstileSiteKey,
                theme: 'light',
            });
        }

        await new Promise((resolve) => setTimeout(resolve, 500));

        const token = window.turnstile?.getResponse();
        if (!token) {
            turnstileError.value = true;
            return;
        }

        turnstileError.value = false;
        await fetch(config.public.suggestionApi, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                data: form.value,
                token: token,
            }),
        });

        submitted.value = true;
        window.turnstile?.reset();
    } catch (e) {
        console.error('Error with Turnstile:', e);
    }
};

const resetForm = () => {
    for (const key in form.value) {
        form.value[key] = '';
    }
    submitted.value = false;
    turnstileError.value = false;
};
</script>
