#!/bin/bash

locales=$(grep '^TELEGRAM_LOCALES=' .env | cut -d '=' -f 2-)

version=$(poetry version | awk '{print $1}')

code_path="aiogram_bot_template/"
output_path="translations/"

args=(poetry run ftl-extract "$code_path" "$output_path" --default-ftl-file messages.ftl)

for locale in $(echo "$locales" | jq -r '.[]'); do
    args+=("-l" "$locale")
done

"${args[@]}"
