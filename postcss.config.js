const purgecss = require('@fullhuman/postcss-purgecss')({
  content: [
    './source/**/*.css',
    './source/app/**/*.elm',
  ],

  defaultExtractor: (content) => content.match(/[\w-/:]+(?<!:)/g) || [],
});

module.exports = {
  plugins: [
    require('tailwindcss'),
    require('autoprefixer'),
    ...process.env.NODE_ENV === 'production'
      ? [purgecss]
      : []
  ],
};
