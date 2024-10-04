
#!/bin/bash


opc=$(yad --form --title="Gerador de Senhas" \
    --field="Tamanho da Senha:NUM" --field="Maiúsculas:CHK" --field="Minúsculas:CHK" \
    --field="Números:CHK" --field="Especiais:CHK" --button="Gerar":0)

IFS="|" read -r length upper lower numbers special <<< "$opc"


charset_file=$(mktemp)
[ "$upper" == "TRUE" ] && echo {A..Z} >> "$charset_file"
[ "$lower" == "TRUE" ] && echo {a..z} >> "$charset_file"
[ "$numbers" == "TRUE" ] && echo {0..9} >> "$charset_file"
[ "$special" == "TRUE" ] && echo '!@#$%^&*()_+' >> "$charset_file"


if [ ! -s "$charset_file" ]; then
    yad --error --text="selecione ao menos um caractere"
    rm -f "$charset_file"
    exit 1
fi


password_file=$(mktemp)
for i in {1..3}; do
    shuf -n "$length" -e $(grep -o . "$charset_file") | tr -d '\n' >> "$password_file"
    echo >> "$password_file"
done

yad --title="senhas geradas" --text-info --filename="$password_file" --width=300 --height=200

rm -f "$charset_file" "$password_file"

