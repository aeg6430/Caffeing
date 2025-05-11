<template>
    <div>
        <h1 class="text-2xl font-bold mb-6">Suggest a Coffee Shop</h1>

        <div v-if="submitted">
            <h2 class="text-xl font-semibold text-green-600">Thank You!</h2>
            <p class="mt-4">Your coffee shop suggestion has been received.</p>
            <button @click="resetForm"
                class="mt-6 px-4 py-2 bg-amber-500 text-white font-semibold rounded-md shadow hover:bg-amber-600 transition">
                Submit Another
            </button>
        </div>

        <form v-else @submit.prevent="handleSubmit" class="space-y-5">
            <div v-for="field in fields" :key="field.name">
                <label :for="field.name" class="block text-sm font-medium">
                    {{ field.label }}
                </label>

                <component :is="field.type === 'textarea' ? 'textarea' : 'input'" v-model="form[field.name]"
                    :type="field.inputType || 'text'" :placeholder="field.placeholder" :rows="field.rows"
                    :required="field.required"
                    class="mt-1 block w-full rounded-md border-gray-300 bg-gray-800 text-white p-3 shadow-sm focus:ring-amber-500 focus:border-amber-500" />
            </div>

            <div id="turnstile-container" class="cf-turnstile" data-theme="light" />

            <div>
                <button type="submit"
                    class="w-full py-2 px-4 bg-amber-500 text-white font-semibold rounded-md shadow hover:bg-amber-600 transition">
                    Submit Suggestion
                </button>
            </div>
        </form>
    </div>
</template>

<script setup>
import { ref } from 'vue';

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
    {
        name: 'name',
        label: 'Shop Name',
        placeholder: 'Coffeing',
        required: true,
    },
    {
        name: 'businessHours',
        label: 'Business Hours',
        placeholder: 'Mon-Fri: 9 AM - 5 PM, Sat: 10 AM - 3 PM',
        type: 'textarea',
        rows: 4,
    },
    {
        name: 'address',
        label: 'Address',
        placeholder: 'Street, City, Country',
    },
    {
        name: 'googleMapsLink',
        label: 'Google Maps Link (optional)',
        placeholder: 'https://goo.gl/maps/coffeing',
        inputType: 'url',
    },
    {
        name: 'website',
        label: 'Website or Instagram (optional)',
        placeholder: 'https://www.instagram.com/coffeing',
        inputType: 'url',
    },
    {
        name: 'description',
        label: 'Description (optional)',
        placeholder: 'Cat cafe with individual sockets and cozy seating',
        type: 'textarea',
        rows: 3,
    },
];

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

        await $fetch(config.public.suggestionApi, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: {
                data: JSON.stringify(form.value),
                token: token,
            },
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
