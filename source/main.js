import '@/base.css';

import { Elm } from '@/app/App.elm';

const app = Elm.App.init({
  node: document.querySelector('main#app'),
});
