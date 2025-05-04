import AOS from 'aos'
import 'aos/dist/aos.css'

export default defineNuxtPlugin(() => {
  onMounted(() => {
    AOS.init({
      once: true, 
      duration: 800,
    })
  })
})
