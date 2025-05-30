<script setup>
const faqs = [
    {
        question: "What is OpenLearn?",
        answer: "OpenLearn is an online education platform designed to help you learn at your own pace, from anywhere in the world. We offer practical, accessible courses led by expert instructors."
    },
    {
        question: "How do I enroll in a course?",
        answer: "Simply create a free account, browse our catalog, and click 'Enroll' on the course you're interested in. You can start immediately or save it for later."
    },
    {
        question: "Are the courses free?",
        answer: "Yes! All our courses are completely free. We believe in making quality education accessible to everyone, everywhere."
    },
    {
        question: "Will I get a certificate after completing a course?",
        answer: "Yes! If you complete all modules and pass the final exam, you’ll receive a digital certificate."
    },
    {
        question: "Can I learn from my phone?",
        answer: "Absolutely. Our platform is fully responsive and works seamlessly on phones, tablets, and desktops. No app needed."
    },
    {
        question: "What happens if I don’t finish the course on time?",
        answer: "No worries — OpenLearn is self-paced. Your progress is saved automatically so you can continue anytime."
    },
];
</script>
<template>
    <div class="container my-5">
        <h2 class="text-center mb-4">Frequently Asked Questions (FAQ)</h2>
        <div class="accordion" id="faqAccordion">
            <div class="accordion-item" v-for="(faq, index) in faqs" :key="index">
                <h2 class="accordion-header" :id="'heading' + index">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                        :data-bs-target="'#collapse' + index" aria-expanded="false" :aria-controls="'collapse' + index">
                        {{ faq.question }}
                    </button>
                </h2>
                <div :id="'collapse' + index" class="accordion-collapse collapse" :aria-labelledby="'heading' + index"
                    data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        {{ faq.answer }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<style scoped>
.accordion-button {
    font-weight: bold;
    background-color: #f8f9fa;
}

.accordion-body {
    background-color: #fff;
}
</style>
