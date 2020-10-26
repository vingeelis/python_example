function get_col_name() {
    while IFS='_'; read -ra ADDR; do
    col="${ADDR[2]/col}"
    if [[ "$col" =~ ^[0-9].*$ ]]; then
        echo "${ADDR[0]}-qry-${ADDR[1]}-$(printf '%03d' $col)"
    elif [[ "$col" == "qn" ]]; then
        echo "${ADDR[0]}-qry-${ADDR[1]}"
    else
        echo "${ADDR[0]}-${ADDR[2]}-${ADDR[1]}"
    fi
    done <<< "$1"
}

get_col_name userinfoprep2_lvs_col2
userinfoprep2-qry-lvs-002

# re-balance
/home/runzhao/bin/perm-swap.sh lvc03c-4nfr lvc03c-7bmp
