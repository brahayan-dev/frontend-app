module.exports = {
  mount: {
    public: '/',
    source: '/out',
  },
  alias: {
    '@/': './source',
  },
  plugins: [
    'snowpack-plugin-elm',
    '@snowpack/plugin-dotenv',
    '@snowpack/plugin-postcss',
  ],
  routes: [
    { match: 'routes', src: '.*', dest: '/index.html' },
  ],
  optimize: {
    bundle: true,
    manifest: false,
    minify: true,
    target: 'es2018',
  },
  packageOptions: {
    /* ... */
  },
  devOptions: {
    port: 1234,
  },
  buildOptions: {
    /* ... */
  },
};
