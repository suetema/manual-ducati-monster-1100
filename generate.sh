#!/bin/bash
set -e

BASE_URL="${BASE_URL:-http://127.0.0.1:8080/Ducati/Workshop_manual/USA}"
OUTDIR="$HOME/ducati-manual/pages"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

mkdir -p "$OUTDIR"

pages=(
  M1100_S_ABS_10_A_1_3.3.1.html
  M1100_S_ABS_10_A_2_3.4.1.html
  M1100_S_ABS_10_A_3_3.5.1.html
  M1100_S_ABS_10_B_1_1.7.1.html
  M1100_S_ABS_10_C_1A4.9.1.html
  M1100_S_ABS_10_C_1B4.10.1.html
  M1100_S_ABS_10_C_2_4.11.1.html
  M1100_S_ABS_10_C_3_4.12.1.html
  M1100_S_ABS_10_C_4_4.13.1.html
  M1100_S_ABS_10_D_1_5.15.1.html
  M1100_S_ABS_10_D_2_5.16.1.html
  M1100_S_ABS_10_D_3_5.17.1.html
  M1100_S_ABS_10_D_4_5.18.1.html
  M1100_S_ABS_10_D_5_5.19.1.html
  M1100_S_ABS_10_E_1_4.21.1.html
  M1100_S_ABS_10_E_2_4.22.1.html
  M1100_S_ABS_10_E_3_4.23.1.html
  M1100_S_ABS_10_E_4_4.24.1.html
  M1100_S_ABS_10_F_1_6.26.1.html
  M1100_S_ABS_10_F_2_6.27.1.html
  M1100_S_ABS_10_F_3_6.28.1.html
  M1100_S_ABS_10_F_4_6.29.1.html
  M1100_S_ABS_10_F_5_6.30.1.html
  M1100_S_ABS_10_G_1_9.32.1.html
  M1100_S_ABS_10_G_2A9.33.1.html
  M1100_S_ABS_10_G_2B9.34.1.html
  M1100_S_ABS_10_G_3_9.35.1.html
  M1100_S_ABS_10_G_4_9.36.1.html
  M1100_S_ABS_10_G_5_9.37.1.html
  M1100_S_ABS_10_G_6_9.38.1.html
  M1100_S_ABS_10_G_7_9.39.1.html
  M1100_S_ABS_10_G_8_9.40.1.html
  M1100_S_ABS_10_G_9A9.41.1.html
  M1100_S_ABS_10_G_9B9.42.1.html
  M1100_S_ABS_10_G_9C9.43.1.html
  M1100_S_ABS_10_H_1_7.45.1.html
  M1100_S_ABS_10_H_2_7.46.1.html
  M1100_S_ABS_10_H_4_7.47.1.html
  M1100_S_ABS_10_H_5_7.48.1.html
  M1100_S_ABS_10_H_6_7.49.1.html
  M1100_S_ABS_10_H_7_7.50.1.html
  M1100_S_ABS_10_L2_10.52.1.html
  M1100_S_ABS_10_L6_10.53.1.html
  M1100_S_ABS_10_L7_10.54.1.html
  M1100_S_ABS_10_L8_10.55.1.html
  M1100_S_ABS_10_L10_10.56.1.html
  M1100_S_ABS_10_M_1_3.58.1.html
  M1100_S_ABS_10_M_2_3.59.1.html
  M1100_S_ABS_10_M_3_3.60.1.html
  M1100_S_ABS_10_N_1_9.62.1.html
  M1100_S_ABS_10_N_2A9.63.1.html
  M1100_S_ABS_10_N_2B9.64.1.html
  M1100_S_ABS_10_N_4A9.65.1.html
  M1100_S_ABS_10_N_4B9.66.1.html
  M1100_S_ABS_10_N_4C9.67.1.html
  M1100_S_ABS_10_N_4D9.68.1.html
  M1100_S_ABS_10_N_5_9.69.1.html
  M1100_S_ABS_10_N_6A9.70.1.html
  M1100_S_ABS_10_N_6B9.71.1.html
  M1100_S_ABS_10_N_6C9.72.1.html
  M1100_S_ABS_10_N_7A9.73.1.html
  M1100_S_ABS_10_N_7B9.74.1.html
  M1100_S_ABS_10_N_8_9.75.1.html
  M1100_S_ABS_10_N_9A9.76.1.html
  M1100_S_ABS_10_N_9B9.77.1.html
  M1100_S_ABS_10_N_9C9.78.1.html
  M1100_S_ABS_10_P_1A9.80.1.html
  M1100_S_ABS_10_P_1B9.81.1.html
  M1100_S_ABS_10_P_2_9.82.1.html
  M1100_S_ABS_10_P_3_9.83.1.html
  M1100_S_ABS_10_P_4_9.84.1.html
  M1100_S_ABS_10_P_5_9.85.1.html
  M1100_S_ABS_10_P_6_9.86.1.html
  M1100_S_ABS_10_P_7_9.87.1.html
  M1100_S_ABS_10_P_8_9.88.1.html
  M1100_S_ABS_10_P_9_9.89.1.html
)

total=${#pages[@]}
pdf_files=()

for i in "${!pages[@]}"; do
  page="${pages[$i]}"
  num=$(printf "%03d" $i)
  outfile="$OUTDIR/${num}_${page%.html}.pdf"
  pdf_files+=("$outfile")

  if [ -f "$outfile" ]; then
    echo "[$((i+1))/$total] Skipping (exists): $page"
    continue
  fi

  echo "[$((i+1))/$total] Printing: $page"
  "$CHROME" \
    --headless \
    --disable-gpu \
    --no-pdf-header-footer \
    --print-to-pdf="$outfile" \
    "${BASE_URL}/${page}" 2>/dev/null
  sleep 1
done

echo ""
echo "Merging ${#pdf_files[@]} PDFs..."
pdfunite "${pdf_files[@]}" "$HOME/ducati-manual/Ducati_Monster_1100_Workshop_Manual.pdf"
echo "Done: $HOME/ducati-manual/Ducati_Monster_1100_Workshop_Manual.pdf"
