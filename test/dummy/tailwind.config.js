/** @type {import('tailwindcss').Config} */
const path = require('node:path')
const rootPath = path.resolve(__dirname, "../../");

module.exports = {
    darkMode: 'class',
    content: [
        path.join(rootPath, "app/components/**/*.{rb,html,js,ts,theme.yml}"),
        path.join(rootPath, "test/components/previews/**/*.rb"),
        path.join(rootPath, "test/dummy/app/views/**/*.erb")
    ],
    theme: {
        extend: {},
    },
    plugins: [
        require('flowbite'),
        require('flowbite-typography'),
    ],
}

