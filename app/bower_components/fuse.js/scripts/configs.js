const path = require('path')
const replace = require('@rollup/plugin-replace')
const node = require('@rollup/plugin-node-resolve')
const babel = require('rollup-plugin-babel')
const copy = require('rollup-plugin-copy')
const pckg = require('../package.json')
const typescript = require('typescript')

const FILENAME = 'fuse'
const VERSION = process.env.VERSION || pckg.version
const AUTHOR = pckg.author
const HOMEPAGE = pckg.homepage
const DESCRIPTION = pckg.description

const banner = `/**
 * Fuse.js v${VERSION} - ${DESCRIPTION} (${HOMEPAGE})
 *
 * Copyright (c) ${new Date().getFullYear()} ${AUTHOR.name} (${AUTHOR.url})
 * All Rights Reserved. Apache Software License 2.0
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 */\n`

const resolve = (_path) => path.resolve(__dirname, '../', _path)

const FeatureFlags = {
  LOGICAL_SEARCH_ENABLED: false,
  EXTENDED_SEARCH_ENABLED: false
}

const fullBuildFeatures = {
  LOGICAL_SEARCH_ENABLED: true,
  EXTENDED_SEARCH_ENABLED: true
}

const builds = {
  // UMD full build
  'umd-dev-full': {
    entry: resolve('src/entry.js'),
    dest: resolve(`dist/${FILENAME}.js`),
    format: 'umd',
    env: 'development',
    features: {
      ...fullBuildFeatures
    },
    plugins: [
      copy({
        targets: [
          {
            src: resolve('src/index.d.ts'),
            dest: resolve('dist'),
            rename: `${FILENAME}.d.ts`,
            transform: (content) => {
              return `// Type definitions for Fuse.js v${VERSION}\n// TypeScript v${typescript.version}\n\n${content}`
            }
          }
        ]
      })
    ]
  },
  // UMD production build
  'umd-prod-full': {
    entry: resolve('src/entry.js'),
    dest: resolve(`dist/${FILENAME}.min.js`),
    format: 'umd',
    env: 'production',
    features: {
      ...fullBuildFeatures
    }
  },
  // UMD basic build
  'umd-dev-basic': {
    entry: resolve('src/entry.js'),
    dest: resolve(`dist/${FILENAME}.basic.js`),
    format: 'umd',
    env: 'development'
  },
  'umd-prod-basic': {
    entry: resolve('src/entry.js'),
    dest: resolve(`dist/${FILENAME}.basic.min.js`),
    format: 'umd',
    env: 'production'
  },
  // CommonJS full build
  'commonjs-full': {
    entry: resolve('src/entry.js'),
    dest: resolve(`dist/${FILENAME}.common.js`),
    env: 'development',
    features: {
      ...fullBuildFeatures
    },
    format: 'cjs'
  },
  // CommonJS basic build
  'commonjs-basic': {
    entry: resolve('src/entry.js'),
    dest: resolve(`dist/${FILENAME}.basic.common.js`),
    env: 'development',
    format: 'cjs'
  },
  // ES modules build (for bundlers)
  'esm-dev-full': {
    entry: resolve('src/entry.js'),
    dest: resolve(`dist/${FILENAME}.esm.js`),
    format: 'es',
    env: 'development',
    features: {
      ...fullBuildFeatures
    },
    transpile: false
  },
  'esm-prod-full': {
    entry: resolve('src/entry.js'),
    dest: resolve(`dist/${FILENAME}.esm.min.js`),
    format: 'es',
    env: 'production',
    features: {
      ...fullBuildFeatures
    },
    transpile: false
  },
  'esm-basic': {
    entry: resolve('src/entry.js'),
    dest: resolve(`dist/${FILENAME}.basic.esm.js`),
    format: 'es',
    env: 'development',
    transpile: false
  },
  'esm-prod-basic': {
    entry: resolve('src/entry.js'),
    dest: resolve(`dist/${FILENAME}.basic.esm.min.js`),
    format: 'es',
    env: 'production',
    transpile: false
  }
}

const defaultVars = {
  __VERSION__: VERSION
}

const defaultFeatures = Object.keys(FeatureFlags).reduce((map, key) => {
  map[`process.env.${key}`] = FeatureFlags[key]
  return map
}, {})

function genConfig(options) {
  // built-in vars
  const vars = { ...defaultVars, ...defaultFeatures }

  const config = {
    input: options.entry,
    plugins: [node(), ...(options.plugins || [])],
    output: {
      banner,
      file: options.dest,
      format: options.format,
      name: 'Fuse'
    }
  }

  // build-specific env
  if (options.env) {
    vars['process.env.NODE_ENV'] = JSON.stringify(options.env)
  }

  // feature flags
  if (options.features) {
    Object.keys(options.features).forEach((key) => {
      vars[`process.env.${key}`] = JSON.stringify(options.features[key])
    })
  }

  config.plugins.push(replace(vars))

  if (options.transpile !== false) {
    config.plugins.push(babel())
  }

  return config
}

function mapValues(obj, fn) {
  const res = {}
  Object.keys(obj).forEach((key) => {
    res[key] = fn(obj[key], key)
  })
  return res
}

if (process.env.TARGET) {
  module.exports = genConfig(builds[process.env.TARGET])
} else {
  module.exports = mapValues(builds, genConfig)
}
