{unstable} :

unstable.writeShellScriptBin "deepl-jp" ''
  ${unstable.jq}/bin/jq -Rs '{text: [.] , target_lang: "EN"}' \
    | curl -X POST https://api-free.deepl.com/v2/translate \
        -H "Content-Type: application/json" \
        -H "Authorization: DeepL-Auth-Key $DEEPL_API_KEY" \
        --data @- \
    | ${unstable.jq}/bin/jq  -r '.translations[0].text'
  ''
