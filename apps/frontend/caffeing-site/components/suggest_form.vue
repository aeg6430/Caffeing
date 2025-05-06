<template>
    <div>
        <h1 class="text-2xl font-bold mb-6 text-gray-800">Suggest a Coffee Shop</h1>
        <form @submit.prevent="handleSubmit" class="space-y-5">
            <div>
                <label class="block text-sm font-medium text-gray-700">Shop Name</label>
                <input v-model="form.name" type="text" placeholder="Coffeing"
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:ring-amber-500 focus:border-amber-500"
                    required />
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">Business Hours</label>
                <textarea v-model="form.businessHours" placeholder="Mon-Fri: 9 AM - 5 PM, Sat: 10 AM - 3 PM" rows="4"
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:ring-amber-500 focus:border-amber-500"></textarea>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">Address</label>
                <input v-model="form.address" type="text" placeholder="Street, City, Country"
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:ring-amber-500 focus:border-amber-500" />
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">Google Maps Link (optional)</label>
                <input v-model="form.googleMapsLink" type="url" placeholder="https://goo.gl/maps/coffeing"
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:ring-amber-500 focus:border-amber-500" />
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">Website or Instagram (optional)</label>
                <input v-model="form.website" type="url" placeholder="https://www.instagram.com/coffeing"
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:ring-amber-500 focus:border-amber-500" />
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">Description (optional)</label>
                <textarea v-model="form.description" rows="3"
                    placeholder="Cat cafe with individual sockets and cozy seating"
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:ring-amber-500 focus:border-amber-500"></textarea>
            </div>
            <div id="turnstile-container" class="cf-turnstile" data-theme="light" />
            <div>
                <button type="submit"
                    class="w-full py-2 px-4 bg-amber-500 text-white font-semibold rounded-md shadow hover:bg-amber-600 transition">
                    Submit Suggestion
                </button>
            </div>
        </form>
        <p v-if="submitted" class="mt-4 text-green-600">
            Thanks for your suggestion!
        </p>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const config = useRuntimeConfig();
const form = ref({
    name: '',
    location: '',
    description: '',
    website: '',
    businessHour: '',
});

const submitted = ref(false);

const handleSubmit = async () => {
    try {
        const token = window.turnstile?.getResponse();

        if (!token) {
            alert('Cloudflare Turnstile verification failed');
            return;
        }
        console.log('Submitted data:', form.value);

        await $fetch('/api/suggestions', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: { ...form.value, turnstileToken: token },
        });

        submitted.value = true;
        window.turnstile?.reset();
    } catch (e) {
        console.error('Error with Turnstile:', e);
    }
};
onMounted(() => {
    const container = document.getElementById('turnstile-container');
    if (window.turnstile && container) {
        window.turnstile.render(container, {
            sitekey: config.public.turnstileSiteKey,
            theme: 'light',
        });
    }
});

defineProps({});
</script>
