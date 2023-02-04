export const translate = (thing) => {
  const language = document.getElementsByName("i18n-lang")[0].dataset.lang;
  return translations()[thing][language]
}
function translations() {
  return {
    map_error: {
      en: "There was an error finding your location. Make sure location tracking is enabled in your browser. If you followed a link to this application from inside another application try opening this application directly in your default web browser.",
      ja: "あなたの位置を見つけるエラーが発生しました。ブラウザの位置トラッキングが有効になっていることを確認してください。別のアプリケーションからこのアプリケーションへのリンクに従った場合は、デフォルトのWebブラウザでこのアプリケーションを直接開いてください。"
    }
  }
}
