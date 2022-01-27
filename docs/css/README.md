## Next JS \* Tailwind CSS

> version : 3.0.15

- Tailwindcss のインストール

```
yarn add -D tailwindcss@latest postcss@latest autoprefixer@latest
```

- Tailwindcss の初期化

```
yarn tailwindcss init -p
```

- tailwind.config.js の編集

```
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx}',
    './src/components/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}

```

- globals.css の編集

```
@tailwind base;
@tailwind components;
@tailwind utilities;
```
