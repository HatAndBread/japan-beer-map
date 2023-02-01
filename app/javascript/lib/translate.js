export const translate = (thing) => {
  const language = document.getElementsByName("i18n-lang")[0].dataset.lang;
  const translations = JSON.parse(document.getElementsByName("js-translations")[0].dataset.data);
  return translations[thing][language]
}
