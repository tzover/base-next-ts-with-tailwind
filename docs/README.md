## Create environments

- initial Dockerfile and docker-compose.yaml

```
FROM node:16.13.0-slim

RUN apt-get update && apt-get install -y \
    sudo curl vim wget procps \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

ENV USER_NAME=node
ENV USER_UID=1000
ARG wkdir=/home/${USER_NAME}/app

WORKDIR ${wkdir}

# COPY ./app/package*.json /home/${USER_NAME}/app/
# COPY ./app/yarn.lock /home/${USER_NAME}/app/

# RUN yarn install
# RUN yarn build

RUN echo "root:root" | chpasswd \
    && usermod -aG sudo ${USER_NAME} \
    && echo "${USER_NAME}:${USER_NAME}" | chpasswd \
    && echo "%${USER_NAME}    ALL=(ALL)    NOPASSWD:    ALL" >> /etc/sudoers.d/${USER_NAME} \
    && chmod 0440 /etc/sudoers.d/${USER_NAME} \
    && chown -hR ${USER_NAME}:${USER_NAME} ${wkdir}

USER ${USER_NAME}

# CMD [ "yarn", "start" ]

---
version: "3.3"
services:
  frontend:
    image: ${IMAGE_BASENAME}/ui:${TAG}
    container_name: ${CONTAINER_BASENAME}-ui
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - ./app:/home/node/app
      # - frontend-volume/:/home/node/app/node_modules
    ports:
      - ${FRONTEND_PORT}:3000
    tty: true
    restart: always
# volumes:
#   frontend-volume:
#     name: ${CONTAINER_BASENAME}-volume
#     driver: local
```

- Create Docker container and Next.js Projects

```
docker-compose up -d
docker-compose exec frontend bash

cd /home/node
yarn create-next-app --typescript app
```

- Dir tree structure

```
tree -a --dirsfirst -I "node_modules|\.git"

.
├── app
│   ├── pages
│   │   ├── api
│   │   │   └── hello.ts
│   │   ├── _app.tsx
│   │   └── index.tsx
│   ├── public
│   │   ├── favicon.ico
│   │   └── vercel.svg
│   ├── styles
│   │   ├── globals.css
│   │   └── Home.module.css
│   ├── .eslintrc.json
│   ├── .gitignore
│   ├── next.config.js
│   ├── next-env.d.ts
│   ├── package.json
│   ├── README.md
│   ├── tsconfig.json
│   └── yarn.lock
├── docs
│   └── README.md
├── images
├── docker-compose.yml
├── Dockerfile
├── .dockerignore
├── .env
├── .gitignore
└── README.md

```

- Add packages

```
yarn add -D eslint-config-airbnb-typescript prettier eslint-config-prettier @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-plugin-react @eslint/create-config
```

- Add ESLint

```
yarn eslint --init
```

> How would you like to use ESLint?

    -> To check syntax, find problems, and enforce code style

> What type of modules does your project use?

    -> JavaScript modules (import/export)

> Which framework does your project use?

    -> React

> Does your project use TypeScript?

    -> Yes

> Where does your code run?

    -> Browser

> How would you like to define a style for your project?

    -> Use a popular style guide

> Which style guide do you want to follow?

    -> Airbnb: https://github.com/airbnb/javascript

> What format do you want your config file to be in?

    -> JSON

> Would you like to install them now with npm?

    -> No

- tsconfig.json (編集)

```
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true
  },
  "include": ["next-env.d.ts", "src/**/*.ts", "src/**/*.tsx"],
  "exclude": ["node_modules"]
}
```

- tsconfig.eslint.json の作成

```
{
  "extends": "./tsconfig.json",
  "include": ["src/**/*.ts", "src/**/*.tsx", "src/**/*.js", "src/**/*.jsx"]
}
```

- eslintrc.json の編集 (project)

```
{
 "root": true,
  "env": {
    "browser": true,
    "es2021": true
  },
  "extends": [
    "airbnb-typescript",
    "prettier",
    "eslint:recommended",
    "plugin:@typescript-eslint/eslint-recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react/recommended"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "project": "./tsconfig.eslint.json",
    "ecmaFeatures": {
      "jsx": true
    },
    // "ecmaVersion": latest,
    "sourceType": "module"
  },
  "plugins": ["react", "@typescript-eslint"],
  "rules": {
    "@typescript-eslint/explicit-function-return-type": 0,
    "@typescript-eslint/no-explicit-any": 0,
    "@typescript-eslint/no-empty-function": 0,
    "react/prop-types": 0,
    "react/react-in-jsx-scope": 0,
    "no-empty-function": 0,
    "@typescript-eslint/ban-ts-comment": 0
  }
}
```

- .eslintignore の作成

```
node_modules
build
coverage
docs
.next
```

- .prettierrc の作成

```
{
  "jsxSingleQuote": true,
  "singleQuote": true,
  "trailingComma": "all",
  "semi": false
}
```

- package.json の編集 (lint)

```
{
  "name": "app",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "eslint src/**/*.{ts,tsx}",
    "lint:fix": "eslint src/**/*.{ts,tsx} --fix"
  },
  "dependencies": {
    "next": "11.1.2",
    "react": "17.0.2",
    "react-dom": "17.0.2"
  },
  "devDependencies": {
    "@types/react": "17.0.31",
    "@typescript-eslint/eslint-plugin": "^5.1.0",
    "@typescript-eslint/parser": "^5.1.0",
    "eslint": "8.0.1",
    "eslint-config-airbnb-typescript": "^14.0.1",
    "eslint-config-next": "11.1.2",
    "eslint-config-prettier": "^8.3.0",
    "eslint-plugin-react": "^7.26.1",
    "prettier": "^2.4.1",
    "typescript": "4.4.4"
  }
}
```

- next.config.json の編集

```
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  webpack: (config, { isServer }) => {
    if (!isServer) {
      config.resolve.fallback.fs = false
      config.resolve.fallback.child_process = false
      config.resolve.fallback.net = false
      config.resolve.fallback.dns = false
      config.resolve.fallback.tls = false
    }
    return config
  },
}

module.exports = nextConfig

```

- Add packages

```
yarn add axios
```

## testing environments

- Add packeges

```
yarn add -D @types/jest jest babel-jest axios-mock-adapter @testing-library/user-event @testing-library/react-hooks @testing-library/react @testing-library/jest-dom @testing-library/dom jest-css-modules
```

- create jest.config.json and jest.setup.json

```
// jest.config.json

module.exports = {
  collectCoverageFrom: [
    '**/*.{js,jsx,ts,tsx}',
    '!**/*.d.ts',
    '!**/node_modules/**',
  ],
  moduleNameMapper: {
    '\\.(css)$': '<rootDir>/node_modules/jest-css-modules',
  },
  roots: ['<rootDir>/src/'],
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  testPathIgnorePatterns: ['<rootDir>/node_modules/', '<rootDir>/.next/'],
  testEnvironment: 'jsdom',
  transform: {
    '^.+\\.(js|jsx|ts|tsx)$': ['babel-jest', { presets: ['next/babel'] }],
  },
  testEnvironment: 'jest-environment-jsdom',
}

// jest.setup.json

import '@testing-library/jest-dom/extend-expect'
```

- package.json の編集

```
"scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "test": "jest --watchAll=false",
    "test:ci": "jest --ci",
    "lint": "eslint src/**/*.{ts,tsx}",
    "lint:fix": "eslint src/**/*.{ts,tsx} --fix"
  },
```
