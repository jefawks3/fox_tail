/** @type {import('tailwindcss').Config} */
const path = require('node:path')
const rootPath = path.resolve(__dirname, "../../");

// const { execSync } = require('node:child_process');
// const dir = execSync('gem which rails')
//console.log('test', dir.toString())

module.exports = {
    darkMode: 'class',
    content: [
        path.join(rootPath, "app/components/**/*.{rb,erb,js,ts,theme.yml}"),
        path.join(rootPath, "test/components/previews/**/*.{rb,erb}"),
        path.join(rootPath, "test/dummy/app/views/**/*.erb")
    ],
    theme: {
        extend: {},
    },
    plugins: [
        require('flowbite'),
        require('flowbite-typography'),
        require('../../plugin'),
    ],
}

