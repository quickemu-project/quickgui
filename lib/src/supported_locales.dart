/*
 * List of locales (language + country) we have translations for.
 *
 * If there is a file for the tuple (langue, country) in assets/lib/i18n, then this
 * will be used for translation.
 *
 * If there is not, then we'll look for a file for the language only.
 *
 * If there is no file for the language code, we'll fallback to the english file.
 *
 * Example : let's say the locale is fr_CH. We will look for "assets/lib/i18n/fr_CH.po",
 * "assets/lib/i18n/fr.po", and "assets/lib/i18n/en.po", stopping at the first file we
 * find.
 *
 * Translation files are not merged, meaning if some translations are missing in fr_CH.po
 * but are present in fr.po, the missing translations will not be picked up from fr.po,
 * and thus will show up in english.
 */
final supportedLocales = [
  'cs_CZ',
  //'cy',
  'de',
  'en',
  'es',
  'fr',
  //'gd',
  'hu',
  'it',
  'nl',
  'no',
  //'oc',
  'pt_PT',
  'ru',
  'ja',
  'sv',
  'pt_BR',
];
