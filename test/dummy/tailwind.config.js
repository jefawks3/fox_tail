/** @type {import('tailwindcss').Config} */
const path = require('node:path')
const rootPath = path.resolve(__dirname, "../../");

// const { execSync } = require('node:child_process');
// const dir = execSync('gem which rails')
//console.log('test', dir.toString())

module.exports = {
    darkMode: 'class',
    content: [
        path.join(rootPath, "app/components/**/*.{rb,erb,ts,theme.yml}"),
        path.join(rootPath, "src/**/*.ts"),
        path.join(rootPath, "test/components/previews/**/*.{rb,erb}"),
        path.join(rootPath, "test/dummy/app/views/**/*.erb"),
    ],
    theme: {
        extend: {},
    },
    plugins: [
        require('flowbite/plugin'),
        require('flowbite-typography'),
        require(path.join(rootPath, "plugin.js")),
    ],
}

